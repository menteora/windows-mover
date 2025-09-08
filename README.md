# Window Mover

![Version](https://img.shields.io/badge/version-v1.0.0-blue)
![Platform](https://img.shields.io/badge/Windows-11-tested)
![AHK](https://img.shields.io/badge/AutoHotkey-v2.x-green)

<p align="center">
  <img src="window-mover-simple-256.png" alt="Window Mover Icon" width="128" />
</p>

A small AutoHotkey v2 utility to move a selected window between monitors (by physical layout) and maximize it.  
**Tested on Windows 11.**

---

## English

### Features
- Pick a window from the list and **store** it.
- Move to **left** / **right** monitor (physical position), then **maximize**.
- **Undo** last move.
- **Auto language detection** with manual override (EN/IT/ES/FR/DE) persisted in `WindowMover.ini`.
- Resizable UI + columns you can resize.
- Version label visible in the app.
- Comes with a clean fullscreen-inspired icon.

### Hotkeys
- **Ctrl+Alt+Right** → Move to right monitor  
- **Ctrl+Alt+Left** → Move to left monitor  
- **Ctrl+Alt+Backspace** → Undo

### Requirements
- [AutoHotkey v2](https://www.autohotkey.com/)

### How to run
1. Install AutoHotkey v2.  
2. Save `WindowMover.ahk` somewhere (same folder recommended).  
3. Double-click `WindowMover.ahk`.

### Compile to EXE (optional)
- Use **Ahk2Exe** (bundled with AutoHotkey).  
- Select `WindowMover.ahk`, set **Custom Icon** to `window-mover-simple.ico`, and build.

---

## Italiano

### Funzionalità
- Seleziona una finestra dall’elenco e **memorizzala**.
- Sposta sul monitor **a sinistra** / **a destra** (posizione fisica) e **massimizza**.
- **Annulla** l’ultimo spostamento.
- **Rilevamento automatico lingua** con scelta manuale (IT/EN/ES/FR/DE) salvata in `WindowMover.ini`.
- Interfaccia ridimensionabile + colonne ridimensionabili.
- Etichetta **versione** visibile nell’app.
- Include un’icona pulita ispirata al fullscreen.

### Scorciatoie
- **Ctrl+Alt+Freccia Destra** → Sposta a destra  
- **Ctrl+Alt+Freccia Sinistra** → Sposta a sinistra  
- **Ctrl+Alt+Backspace** → Annulla

### Requisiti
- [AutoHotkey v2](https://www.autohotkey.com/)

### Esecuzione
1. Installa AutoHotkey v2.  
2. Salva `WindowMover.ahk` (stessa cartella consigliata).  
3. Doppio clic su `WindowMover.ahk`.

### Compilare in EXE (opzionale)
- Apri **Ahk2Exe** → scegli `WindowMover.ahk`,  
  imposta **Icona personalizzata** su `window-mover-simple.ico` e compila.

---

## Español

Funciones: seleccionar y guardar ventana; mover a monitor **izquierdo/derecho** y **maximizar**; **deshacer**; detección automática de idioma con selección manual (ES/EN/IT/FR/DE); UI/columnas redimensionables; etiqueta de **versión**; incluye un icono inspirado en pantalla completa.

Atajos: Ctrl+Alt+→ / Ctrl+Alt+← / Ctrl+Alt+Backspace  
Requisitos: AutoHotkey v2  
EXE: Ahk2Exe + `window-mover-simple.ico`.

---

## Français

Fonctionnalités : choisir et mémoriser une fenêtre ; déplacer vers l’écran **gauche/droite** et **maximiser** ; **annuler** ; détection auto de la langue avec choix manuel (FR/EN/IT/ES/DE) ; interface/colonnes redimensionnables ; étiquette de **version** ; icône inspirée du plein écran.

Raccourcis : Ctrl+Alt+→ / Ctrl+Alt+← / Ctrl+Alt+Backspace  
Prérequis : AutoHotkey v2  
EXE : Ahk2Exe + `window-mover-simple.ico`.

---

## Deutsch

Funktionen: Fenster auswählen & speichern; auf **linken/rechten** Monitor verschieben und **maximieren**; **Rückgängig**; automatische Spracherkennung mit manueller Auswahl (DE/EN/IT/ES/FR); UI/Spalten skalierbar; **Versionslabel**; Icon im Fullscreen-Stil.

Tasten: Strg+Alt+→ / Strg+Alt+← / Strg+Alt+Backspace  
Voraussetzungen: AutoHotkey v2  
EXE: Ahk2Exe + `window-mover-simple.ico`.

---

## Files

- `WindowMover.ahk` – the script  
- `WindowMover.ini` – user settings (language)  
- `window-mover-simple.ico` – application icon (for EXE)  
- `window-mover-simple-256.png` – preview icon for README  

---

## License

MIT

---

## Build Icons (Windows / Linux / macOS)

This project includes a cross-platform script to generate icons.

### Requirements
- [Python 3](https://www.python.org/downloads/)
- [Pillow](https://pypi.org/project/pillow/) (`pip install pillow`)

### Usage
Run from the project root:

```bash
# Default (black on transparent, PNG 256px + ICO multi-size)
python make_icons.py

# Example: white on blue background, PNG 512px
python make_icons.py --fg #FFFFFF --bg #1E90FF --size 512

# Custom output paths
python make_icons.py --png assets/icon.png --ico assets/icon.ico

