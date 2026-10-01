# XMC4500E144 + FreeRTOS + C++20 + J-Link RTT

Initiales VS-Code-Projekt fuer einen **Infineon XMC4500E144x1024** (Cortex-M4F, 1 MiB Flash) mit **C++20**, **FreeRTOS** und **SEGGER RTT** als erster Debug-Ausgabe ueber einen J-Link Ultra+.

Aktueller Entwicklungsstand: **00.00.07** auf Branch `develop`.

## Branch- und Versionsregel

- `master` wird nicht automatisch veraendert und nur nach expliziter Anweisung aktualisiert.
- Die Entwicklung erfolgt linear auf `develop`.
- Jeder gespeicherte Stand erhaelt eine Versionsnummer im Format `xx.xx.xx` in der Datei `VERSION` und einen gleichnamigen Git-Tag. Die Commit-Beschreibung enthaelt keine Versionskennung.
- Der Workflow `.github/workflows/version-tags.yml` prueft die lineare `develop`-Historie und erzeugt fehlende Versions-Tags aus den jeweiligen `VERSION`-Dateien.
- Externe Quellen sind auf feste Versionen bzw. Commits gepinnt und als Git-Submodule unter `ThirdParty/` eingebunden.

## Enthaltene Komponenten

- Arm GNU Toolchain (`arm-none-eabi-gcc/g++/gdb`)
- CMake >= 3.24 und Ninja
- Infineon XMCLib `release-v4.7.0` (Commit `c24888699c6c5cfd6e5475be90d9703e43540d04`)
- Arm CMSIS `5.9.0` (Commit `2b7495b8535bdcb306dac29b9ded4cfb679d7e5c`) fuer die generischen Cortex-M4-Core-Header
- FreeRTOS Kernel `V11.2.0` (Commit `0adc196d4bd52a2d91102b525b0aafc1e14a2386`), Port `GCC_ARM_CM4F`, Heap `heap_4`
- SEGGER RTT, gepinnt auf Commit `4d8feab3150f86f37a9d323ddc88d6cdf5673072`
- VS Code mit CMake Tools, Cortex-Debug und C/C++

XMCLib liefert die Infineon-spezifischen XMC4500 Device-Dateien, das Startup-File `startup_XMC4500.S`, das Linkerscript `XMC4500x1024.ld` und die XMC4500-SVD-Datei. Arm CMSIS liefert unter anderem `core_cm4.h`. Die Firmware wird fuer `XMC4500_E144x1024` kompiliert.

## Voraussetzungen

Folgende Programme muessen im `PATH` liegen:

```text
git
arm-none-eabi-gcc
arm-none-eabi-g++
arm-none-eabi-gdb
cmake
ninja
```

Zusaetzlich muss das aktuelle **SEGGER J-Link Software and Documentation Pack** installiert sein. Der J-Link Ultra+ wird per SWD mit dem Target verbunden; das Target muss separat bzw. passend zur Hardware versorgt sein.

Die externen Quellen liegen als Git-Submodule unter `ThirdParty/`. Nach einem normalen Clone oder nach dem Wechsel auf diesen Stand einmal ausfuehren:

```bash
git submodule update --init --recursive
```

Alternativ direkt inklusive Submodule klonen:

```bash
git clone --recurse-submodules https://github.com/Salvasohn/Infineon.git
```

CMake verwendet danach ausschliesslich die lokalen Quellen aus `ThirdParty/` und laedt beim Konfigurieren keine Bibliotheken per `FetchContent` nach.

## Build

```bash
cmake --preset debug
cmake --build --preset debug
```

Nach Aenderungen an Toolchain- oder globalen Compiler-Flags sollte der CMake-Cache einmal verworfen werden:

```bash
cmake --preset debug --fresh
cmake --build --preset debug
```

Die Artefakte liegen danach in `build/debug/`:

```text
xmc4500_freertos_rtt.elf
xmc4500_freertos_rtt.hex
xmc4500_freertos_rtt.bin
xmc4500_freertos_rtt.map
```

## Debuggen mit VS Code und J-Link Ultra+

1. Repository inklusive Submodule vorbereiten (`git submodule update --init --recursive`).
2. Repository in VS Code oeffnen.
3. Empfohlene Extensions installieren.
4. J-Link Ultra+ per USB verbinden und SWD/Reset/GND mit dem XMC4500-Target verbinden.
5. In **Run and Debug** die Konfiguration `XMC4500 - J-Link + RTT` auswaehlen.
6. `F5` starten. Der Pre-Launch-Task konfiguriert und baut den Debug-Stand automatisch.
7. Cortex-Debug startet den J-Link GDB Server fuer `XMC4500-1024`, programmiert das ELF und oeffnet RTT Kanal 0 im VS-Code-Terminal.

Die J-Link-Geschwindigkeit ist initial auf 4 MHz gesetzt. Falls die Hardwareverbindung noch nicht stabil ist, kann der Wert in `.vscode/launch.json` reduziert werden.

## Erwartete RTT-Ausgabe

Direkt nach dem Start sollte sinngemaess folgende Ausgabe erscheinen:

```text
[boot] XMC4500E144 | FreeRTOS | C++20 | fw 00.00.07
[boot] SystemCoreClock=120000000 Hz, RTT channel 0 ready
[tick 0 ms] FreeRTOS heartbeat
[tick 1000 ms] FreeRTOS heartbeat
[tick 2000 ms] FreeRTOS heartbeat
...
```

Der konkrete `SystemCoreClock`-Wert wird zur Laufzeit ausgegeben. Die Heartbeat-Task schreibt einmal pro Sekunde ueber SEGGER RTT und belegt damit gleichzeitig, dass Scheduler, SysTick und RTT funktionieren.

## Projektstruktur

```text
.github/workflows/         automatische Versions-Tag-Pruefung
.vscode/                  VS-Code Build/Debug-Konfiguration
cmake/                    Toolchain und lokale Dependency-Einbindung
ThirdParty/               gepinnte Git-Submodule fuer XMCLib, CMSIS, FreeRTOS und RTT
include/FreeRTOSConfig.h  FreeRTOS-Konfiguration fuer Cortex-M4F
src/main.cpp              C++20 Einstieg, Task und RTT-Ausgabe
src/runtime_stubs.c       minimale newlib/CRT-Hooks fuer Bare-Metal
CMakeLists.txt            Firmware-Build
CMakePresets.json         Debug/Release Presets
VERSION                   Firmware-Versionsstand
CHANGELOG.md              lineare Versionshistorie
```

Weitere Details zu den externen Revisionen stehen in `ThirdParty/README.md`.

## Hinweise zum ersten Hardware-Test

Der Stand ist als reproduzierbares Projektgeruest fuer den ersten Flash-/Debug-Test vorbereitet. Ein realer Hardwarelauf kann in dieser Umgebung nicht ausgefuehrt werden, da hier weder dein XMC4500-Board noch dein J-Link physisch angeschlossen sind. Nach dem ersten Lauf auf deiner Hardware sollten wir insbesondere Taktinitialisierung, SWD-Geschwindigkeit und ggf. Board-spezifische Pin-/Versorgungsdetails gegen dein konkretes Board pruefen.
