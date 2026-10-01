# Changelog

Die Versionsnummer liegt in `VERSION`. Jeder gespeicherte Entwicklungsstand erhoeht die Nummer im Format `xx.xx.xx`, traegt einen gleichnamigen Git-Tag und bleibt Teil einer linearen Historie auf `develop`. Die Commit-Beschreibung enthaelt keine Versionskennung.

## 00.00.05

- XMCLib, FreeRTOS-Kernel und SEGGER RTT als gepinnte Git-Submodule unter `ThirdParty/` eingebunden.
- CMake von `FetchContent` auf die lokalen `ThirdParty`-Quellen umgestellt.
- Cortex-Debug-SVD-Pfad auf die lokale XMCLib-Kopie angepasst.
- Clone-/Submodule-Anleitung dokumentiert.
- Versionskennungen rueckwirkend aus den Commit-Beschreibungen entfernt und als Git-Tags definiert.
- GitHub-Workflow zur Pruefung und Erzeugung fehlender Versions-Tags hinzugefuegt.

## 00.00.04

- Projektdokumentation und Build-/Debug-Anleitung ergaenzt.
- XMC4500 SVD in Cortex-Debug eingebunden.
- C++ Runtime-Optionen fuer Bare-Metal nachgeschaerft.

## 00.00.03

- SEGGER RTT eingebunden.
- Exemplarische Boot- und FreeRTOS-Heartbeat-Ausgabe auf RTT Kanal 0.
- VS-Code-Konfiguration fuer J-Link/Cortex-Debug hinzugefuegt.

## 00.00.02

- Infineon XMC4500 Startup, CMSIS und 1-MiB-Linkerscript eingebunden.
- FreeRTOS Kernel V11.2.0 mit GCC Cortex-M4F Port und heap_4 integriert.
- Erste FreeRTOS Task angelegt.

## 00.00.01

- C++20 Cross-Compile-Grundgeruest mit CMake/Ninja und Arm GNU Toolchain angelegt.
