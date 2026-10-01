# ThirdParty

Die fuer den Firmware-Build benoetigten externen Quellen werden als Git-Submodule in diesem Verzeichnis gehalten. Dadurch sind die verwendeten Revisionen direkt im Projekt gepinnt und CMake muss beim Konfigurieren keine Abhaengigkeiten per `FetchContent` laden.

## Gepinnte Revisionen

- `XMCLib`: Infineon `mtb-xmclib-cat3`, `release-v4.7.0`, Commit `c24888699c6c5cfd6e5475be90d9703e43540d04`
- `FreeRTOS-Kernel`: `V11.2.0`, Commit `0adc196d4bd52a2d91102b525b0aafc1e14a2386`
- `SEGGER_RTT`: Commit `4d8feab3150f86f37a9d323ddc88d6cdf5673072`

Nach einem normalen Clone oder nach dem Wechsel auf einen Stand mit neuen Submodulen:

```bash
git submodule update --init --recursive
```

Alternativ kann das Repository direkt inklusive Submodule geklont werden:

```bash
git clone --recurse-submodules https://github.com/Salvasohn/Infineon.git
```

Die Gitlinks der Submodule duerfen nur zusammen mit einem neuen Projekt-Versionsstand aktualisiert werden.
