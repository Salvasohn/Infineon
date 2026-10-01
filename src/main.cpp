#include <cstdint>

extern "C" {
#include "FreeRTOS.h"
#include "task.h"
}

#include "system_XMC4500.h"

#ifndef FW_VERSION
#define FW_VERSION "00.00.00"
#endif

namespace {
volatile TickType_t g_last_heartbeat_tick = 0;

void heartbeat_task(void *)
{
    for (;;) {
        g_last_heartbeat_tick = xTaskGetTickCount();
        vTaskDelay(pdMS_TO_TICKS(1000));
    }
}
} // namespace

int main()
{
    SystemCoreClockUpdate();

    const BaseType_t created = xTaskCreate(
        heartbeat_task,
        "heartbeat",
        384,
        nullptr,
        tskIDLE_PRIORITY + 1,
        nullptr);

    configASSERT(created == pdPASS);
    vTaskStartScheduler();

    for (;;) {
        __asm volatile("nop");
    }
}

extern "C" void vApplicationMallocFailedHook(void)
{
    taskDISABLE_INTERRUPTS();
    for (;;) {
        __asm volatile("nop");
    }
}

extern "C" void vApplicationStackOverflowHook(TaskHandle_t, char *)
{
    taskDISABLE_INTERRUPTS();
    for (;;) {
        __asm volatile("nop");
    }
}

extern "C" void vAssertCalled(const char *, int)
{
    taskDISABLE_INTERRUPTS();
    for (;;) {
        __asm volatile("nop");
    }
}
