# Changelog

Die Versionsnummer liegt in `VERSION`. Jeder gespeicherte Entwicklungsstand erhoeht die Nummer im Format `xx.xx.xx`, traegt einen gleichnamigen Git-Tag und bleibt Teil einer linearen Historie auf `develop`. Die Commit-Beschreibung enthaelt keine Versionskennung.

## 00.00.13

- clang-tidy um den expliziten newlib-Sysroot der Arm GNU Toolchain erweitert.
- `--sysroot=<toolchain>/arm-none-eabi` wird zusammen mit `--target=arm-none-eabi` und `--gcc-toolchain` verwendet, damit C-Standardheader aus der gepinnten Bare-Metal-Toolchain korrekt aufgeloest werden.

## 00.00.12

- Unbenutztes `<cstdint>` aus `main.cpp` entfernt, damit clang-tidy fuer das ARM-Bare-Metal-Target keine unnoetigen C++-Standardbibliothek-Header aufloesen muss.
- `performance-enum-size` gezielt deaktiviert, da der Check ausschliesslich gepinnte FreeRTOS-Enums in `ThirdParty/` beanstandet und dort keine ABI-Aenderungen erzwungen werden sollen.
- clang-format bleibt als harter First-Party-Formatcheck aktiv; clang-tidy bleibt auf Analyzer-, Bugprone-, Performance- und Portability-Pruefungen fuer den eigenen Code ausgerichtet.

## 00.00.11

- clang-format-Regeln an den bestehenden Embedded-Stil angepasst (`ColumnLimit: 0`, einfache Fortsetzungs-Einrueckung, unveraenderte Include-Reihenfolge).
- Bestehende mehrzeilige RTT-Aufrufe an die definierte Fortsetzungs-Einrueckung angepasst.
- Die bewusst tabellarisch ausgerichtete FreeRTOS-Makrosektion mit `clang-format off/on` vor automatischer Umformatierung geschuetzt.

## 00.00.10

- Projektweite `.clang-format`-Konfiguration fuer den eigenen C/C++-Code hinzugefuegt.
- `.clang-tidy` mit Analyzer-, Bugprone-, Performance- und Portability-Checks hinzugefuegt.
- CMake-Ziele `format`, `format-check` und `tidy` angelegt; `tidy` nutzt die Debug-Compile-Database und analysiert fuer `arm-none-eabi`.
- VS-Code-Tasks fuer Formatieren, Format-Pruefung und clang-tidy ergaenzt.
- GitHub Actions um einen separaten Code-Quality-Job mit clang-format 18 und clang-tidy 18 erweitert.
- `ThirdParty/` bleibt von den projektweiten Format-/Tidy-Regeln ausgenommen.

## 00.00.09

- CI auf die Arm GNU Toolchain `14.2.rel1` (GCC `14.2.1`) fest gepinnt, passend zur lokal verwendeten Toolchain.
- Offizielles Arm-Toolchain-Archiv wird in der CI per SHA-256 vor der Installation verifiziert.
- GitHub Actions auf Node-24-faehige Versionen `actions/checkout@v5` und `actions/upload-artifact@v6` aktualisiert.
- Debug- und Release-Build bleiben als getrennte CI-Jobs mit Artefaktpruefung erhalten.

## 00.00.08

- Release-Build als VS-Code-Task auf Basis des vorhandenen CMake-Presets `release` ergaenzt.
- GitHub-Actions-Pipeline fuer reproduzierbare Debug- und Release-Builds hinzugefuegt.
- CI initialisiert alle Git-Submodule, installiert die Arm-GNU-Bare-Metal-Toolchain und baut beide Presets frisch.
- CI prueft ELF/HEX/BIN/MAP und stellt die erzeugten Firmware-Dateien als Build-Artefakte bereit.

## 00.00.07

- FreeRTOS-Option `INCLUDE_xTaskDelayUntil` aktiviert, damit `xTaskDelayUntil()` mitgebaut und gelinkt wird.
- Bare-Metal-Runtime-Stubs `_init` und `_fini` fuer die Kombination aus Infineon-Startup, newlib und `-nostartfiles` hinzugefuegt.
- `runtime_stubs.c` in den Firmware-Build aufgenommen.
- Hinweis auf frisches CMake-Konfigurieren nach Toolchain-/Flag-Aenderungen ergaenzt.

## 00.00.06

- Arm CMSIS 5.9.0 als eigenes gepinntes Submodule `ThirdParty/CMSIS_5` hinzugefuegt.
- Fehlenden Cortex-M4-Core-Header `core_cm4.h` durch den korrekten CMSIS-Core-Include-Pfad bereitgestellt.
- CMake-Include-Pfade fuer Plattform und FreeRTOS von der nicht existierenden XMCLib-Core-Struktur auf `ThirdParty/CMSIS_5/CMSIS/Core/Include` umgestellt.
- ThirdParty-Pruefung und Dokumentation erweitert.

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
