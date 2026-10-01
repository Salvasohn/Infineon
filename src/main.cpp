extern "C" {
#include "FreeRTOS.h"
#include "SEGGER_RTT.h"
#include "task.h"
}

#include "system_XMC4500.h"

#ifndef FW_VERSION
#define FW_VERSION "00.00.00"
#endif

namespace {
constexpr TickType_t heartbeat_period = pdMS_TO_TICKS(1000);

void heartbeat_task(void *)
{
    TickType_t next_wakeup = xTaskGetTickCount();

    for (;;) {
        const auto tick = static_cast<unsigned long>(xTaskGetTickCount());
        SEGGER_RTT_printf(0, "[tick %lu ms] FreeRTOS heartbeat\r\n", tick);
        vTaskDelayUntil(&next_wakeup, heartbeat_period);
    }
}

[[noreturn]] void halt_forever()
{
    taskDISABLE_INTERRUPTS();
    for (;;) {
        __asm volatile("nop");
    }
}
} // namespace

int main()
{
    SystemCoreClockUpdate();
    SEGGER_RTT_Init();

    SEGGER_RTT_printf(0,
        "\r\n[boot] XMC4500E144 | FreeRTOS | C++20 | fw %s\r\n",
        FW_VERSION);
    SEGGER_RTT_printf(0,
        "[boot] SystemCoreClock=%lu Hz, RTT channel 0 ready\r\n",
        static_cast<unsigned long>(SystemCoreClock));

    const BaseType_t created = xTaskCreate(
        heartbeat_task,
        "heartbeat",
        384,
        nullptr,
        tskIDLE_PRIORITY + 1,
        nullptr);

    configASSERT(created == pdPASS);
    vTaskStartScheduler();

    halt_forever();
}

extern "C" void vApplicationMallocFailedHook(void)
{
    SEGGER_RTT_WriteString(0, "[fault] FreeRTOS malloc failed\r\n");
    halt_forever();
}

extern "C" void vApplicationStackOverflowHook(TaskHandle_t, char *task_name)
{
    SEGGER_RTT_printf(0,
        "[fault] stack overflow: %s\r\n",
        task_name != nullptr ? task_name : "<unknown>");
    halt_forever();
}

extern "C" void vAssertCalled(const char *file, int line)
{
    SEGGER_RTT_printf(0,
        "[assert] %s:%d\r\n",
        file != nullptr ? file : "<unknown>",
        line);
    halt_forever();
}
