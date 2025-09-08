#Requires AutoHotkey v2.0
#SingleInstance Force

; ========== Config ==========
global appVersion := "v1.0.1"

; INI path per le preferenze utente
SettingsPath() => A_ScriptDir "\WindowMover.ini"

; Carica/imposta lingua: solo da INI, altrimenti fallback EN
LoadSettings() {
    lang := IniRead(SettingsPath(), "General", "Language", "")
    if !(lang ~= "^(en|it|es|fr|de)$")
        lang := "en"
    return lang
}
SaveSettings(lang) {
    IniWrite(lang, SettingsPath(), "General", "Language")
}

; ========== Localizzazione ==========
global L := Map(
    "en", Map(
        "AppTitle","Window Mover","ColTitle","Title","ColApp","App","ColHWND","HWND",
        "BtnRefresh","Refresh","BtnMem","Store","LblControls","Controls:",
        "BtnLeft","◀ Left","BtnRight","Right ▶","BtnUndo","↩ Undo",
        "LblNone","No window selected","LblSelected","Selected:",
        "MsgPickRow","Select a row.","MsgGone","The window no longer exists.",
        "MsgNoTarget","No window stored or it was closed. Select it and press 'Store'.",
        "TrayStored","Stored window:","LblVersion","Version:","LangLabel","Language:",
        "HotkeysHdr","Keyboard Shortcuts",
        "HKRight","Ctrl+Alt+Right  — Move to right monitor",
        "HKLeft","Ctrl+Alt+Left   — Move to left monitor",
        "HKUndo","Ctrl+Alt+Backspace — Undo last move"
    ),
    "it", Map(
        "AppTitle","Window Mover","ColTitle","Titolo","ColApp","App","ColHWND","HWND",
        "BtnRefresh","Aggiorna","BtnMem","Memorizza","LblControls","Controlli:",
        "BtnLeft","◀ Sinistra","BtnRight","Destra ▶","BtnUndo","↩ Indietro",
        "LblNone","Nessuna finestra selezionata","LblSelected","Selezionata:",
        "MsgPickRow","Seleziona una riga.","MsgGone","La finestra non esiste più.",
        "MsgNoTarget","Nessuna finestra memorizzata o è stata chiusa. Selezionala e premi 'Memorizza'.",
        "TrayStored","Finestra memorizzata:","LblVersion","Versione:","LangLabel","Lingua:",
        "HotkeysHdr","Scorciatoie da tastiera",
        "HKRight","Ctrl+Alt+Freccia Destra  — Sposta sul monitor di destra",
        "HKLeft","Ctrl+Alt+Freccia Sinistra — Sposta sul monitor di sinistra",
        "HKUndo","Ctrl+Alt+Backspace       — Annulla l’ultimo spostamento"
    ),
    "es", Map(
        "AppTitle","Window Mover","ColTitle","Título","ColApp","App","ColHWND","HWND",
        "BtnRefresh","Actualizar","BtnMem","Guardar","LblControls","Controles:",
        "BtnLeft","◀ Izquierda","BtnRight","Derecha ▶","BtnUndo","↩ Deshacer",
        "LblNone","Ninguna ventana seleccionada","LblSelected","Seleccionada:",
        "MsgPickRow","Selecciona una fila.","MsgGone","La ventana ya no existe.",
        "MsgNoTarget","No hay ventana guardada o se cerró. Selecciónala y pulsa 'Guardar'.",
        "TrayStored","Ventana guardada:","LblVersion","Versión:","LangLabel","Idioma:",
        "HotkeysHdr","Atajos de teclado",
        "HKRight","Ctrl+Alt+→  — Mover al monitor derecho",
        "HKLeft","Ctrl+Alt+←  — Mover al monitor izquierdo",
        "HKUndo","Ctrl+Alt+Backspace — Deshacer último movimiento"
    ),
    "fr", Map(
        "AppTitle","Window Mover","ColTitle","Titre","ColApp","App","ColHWND","HWND",
        "BtnRefresh","Rafraîchir","BtnMem","Mémoriser","LblControls","Contrôles :",
        "BtnLeft","◀ Gauche","BtnRight","Droite ▶","BtnUndo","↩ Annuler",
        "LblNone","Aucune fenêtre sélectionnée","LblSelected","Sélectionnée :",
        "MsgPickRow","Sélectionnez une ligne.","MsgGone","La fenêtre n’existe plus.",
        "MsgNoTarget","Aucune fenêtre mémorisée ou elle a été fermée. Sélectionnez-la et cliquez sur 'Mémoriser'.",
        "TrayStored","Fenêtre mémorisée :","LblVersion","Version :","LangLabel","Langue :",
        "HotkeysHdr","Raccourcis clavier",
        "HKRight","Ctrl+Alt+→  — Déplacer vers l’écran de droite",
        "HKLeft","Ctrl+Alt+←  — Déplacer vers l’écran de gauche",
        "HKUndo","Ctrl+Alt+Backspace — Annuler le dernier déplacement"
    ),
    "de", Map(
        "AppTitle","Window Mover","ColTitle","Titel","ColApp","App","ColHWND","HWND",
        "BtnRefresh","Aktualisieren","BtnMem","Speichern","LblControls","Steuerung:",
        "BtnLeft","◀ Links","BtnRight","Rechts ▶","BtnUndo","↩ Rückgängig",
        "LblNone","Kein Fenster ausgewählt","LblSelected","Ausgewählt:",
        "MsgPickRow","Wählen Sie eine Zeile aus.","MsgGone","Das Fenster existiert nicht mehr.",
        "MsgNoTarget","Kein Fenster gespeichert oder es wurde geschlossen. Wählen Sie es aus und klicken Sie auf 'Speichern'.",
        "TrayStored","Gespeichertes Fenster:","LblVersion","Version:","LangLabel","Sprache:",
        "HotkeysHdr","Tastenkürzel",
        "HKRight","Strg+Alt+→  — Auf rechten Monitor verschieben",
        "HKLeft","Strg+Alt+←  — Auf linken Monitor verschieben",
        "HKUndo","Strg+Alt+Backspace — Letzte Aktion rückgängig"
    )
)

; ========== Stato ==========
global currentLang := LoadSettings()
global g_Hwnd := 0
global g_History := Map()

; ========== GUI ==========
global winGui, lv, txtSel, lblControls, btnRef, btnMem, btnLeft, btnRight, btnUndo, lblVersion, ddLang, lblLang, lblHot, txtHK

BuildGui()
RefreshList()
winGui.Show()
ApplyTexts()

; ========= Hotkeys =========
^!Right:: MovePhysical("right")
^!Left::  MovePhysical("left")
^!Backspace:: UndoMove()

; ========= Funzioni GUI / Localizzazione =========
BuildGui() {
    global winGui, lv, txtSel, lblControls, btnRef, btnMem, btnLeft, btnRight, btnUndo, lblVersion, ddLang, lblLang, currentLang, appVersion, lblHot, txtHK

    winGui := Gui("", GetText("AppTitle") " " appVersion)

    ; Barra lingua
    lblLang := winGui.Add("Text", "xm ym", GetText("LangLabel"))
    ddLang  := winGui.Add("DropDownList", "x+6 w200 vLANG Choose1", ["English","Italiano","Español","Français","Deutsch"])
    langs := Map("en",1,"it",2,"es",3,"fr",4,"de",5)
    ddLang.Choose(langs.Has(currentLang) ? langs[currentLang] : 1)
    ddLang.OnEvent("Change", (*) => OnLangChanged())

    ; Lista finestre
    lv := winGui.Add("ListView", "xm y+8 w820 r18 vLV Grid", [GetText("ColTitle"), GetText("ColApp"), GetText("ColHWND")])

    ; Pulsanti e label
    btnRef := winGui.Add("Button", "xm y+6 w160", GetText("BtnRefresh"))
    btnMem := winGui.Add("Button", "x+10 w200",   GetText("BtnMem"))
    txtSel := winGui.Add("Text", "x+10 w380", GetText("LblNone"))

    lblControls := winGui.Add("Text", "xm y+10", GetText("LblControls"))
    btnLeft  := winGui.Add("Button", "xm w160", GetText("BtnLeft"))
    btnRight := winGui.Add("Button", "x+10 w160", GetText("BtnRight"))
    btnUndo  := winGui.Add("Button", "x+10 w200", GetText("BtnUndo"))

    lblVersion := winGui.Add("Text", "xm y+16 cGray", GetText("LblVersion") " " appVersion)

    ; Colonne
    lv.ModifyCol(1, 380,       GetText("ColTitle"))
    lv.ModifyCol(2, "AutoHdr", GetText("ColApp"))
    lv.ModifyCol(3, "AutoHdr", GetText("ColHWND"))

    ; Scorciatoie visibili
    lblHot := winGui.Add("Text", "xm y+14", GetText("HotkeysHdr"))
    lblHot.SetFont("Bold")
    txtHK  := winGui.Add("Text", "xm y+4 w820", BuildHotkeysText())

    ; Eventi
    btnRef.OnEvent("Click", RefreshList)
    btnMem.OnEvent("Click", BindSelected)
    btnLeft.OnEvent("Click", (*) => MovePhysical("left"))
    btnRight.OnEvent("Click", (*) => MovePhysical("right"))
    btnUndo.OnEvent("Click", (*) => UndoMove())
    lv.OnEvent("DoubleClick", BindSelected)
    winGui.OnEvent("Size", (*) => AutoResizeCols())
}

BuildHotkeysText() {
    return GetText("HKRight") "`n" GetText("HKLeft") "`n" GetText("HKUndo")
}

OnLangChanged() {
    global ddLang, currentLang
    idx := ddLang.Value
    langByIndex := ["en","it","es","fr","de"]
    currentLang := (idx >= 1 && idx <= langByIndex.Length) ? langByIndex[idx] : "en"
    SaveSettings(currentLang)
    ApplyTexts()
}

ApplyTexts() {
    global winGui, lv, btnRef, btnMem, txtSel, lblControls, btnLeft, btnRight, btnUndo, lblVersion, lblLang, lblHot, txtHK, appVersion
    winGui.Title := GetText("AppTitle") " " appVersion
    lblLang.Text := GetText("LangLabel")

    lv.ModifyCol(1, 380,       GetText("ColTitle"))
    lv.ModifyCol(2, "AutoHdr", GetText("ColApp"))
    lv.ModifyCol(3, "AutoHdr", GetText("ColHWND"))

    btnRef.Text := GetText("BtnRefresh")
    btnMem.Text := GetText("BtnMem")
    lblControls.Text := GetText("LblControls")
    btnLeft.Text := GetText("BtnLeft")
    btnRight.Text := GetText("BtnRight")
    btnUndo.Text := GetText("BtnUndo")

    if !StrLen(txtSel.Text) || RegExMatch(txtSel.Text, "i)^(No window|Nessuna|Ninguna|Aucune|Kein)\s")
        txtSel.Text := GetText("LblNone")
    lblVersion.Text := GetText("LblVersion") " " appVersion

    lblHot.Text := GetText("HotkeysHdr")
    txtHK.Text  := BuildHotkeysText()

    AutoResizeCols()
}

GetText(key) {
    global L, currentLang
    return L[currentLang].Has(key) ? L[currentLang][key] : "[" key "]"
}

AutoResizeCols() {
    global lv
    lv.ModifyCol(1, 380)
    lv.ModifyCol(2, "AutoHdr")
    lv.ModifyCol(3, "AutoHdr")
}

; ========= Logica =========
RefreshList(*) {
    global lv
    lv.Delete()
    for hwnd in WinGetList() {
        title := WinGetTitle("ahk_id " hwnd)
        if (title = "")
            continue
        class := WinGetClass("ahk_id " hwnd)
        if (class = "Progman" || class = "WorkerW")
            continue
        if !(WinGetStyle("ahk_id " hwnd) & 0x10000000)
            continue
        exe := ""
        try exe := WinGetProcessName("ahk_id " hwnd)
        lv.Add("", title, exe, hwnd)
    }
    AutoResizeCols()
}

BindSelected(*) {
    global lv, txtSel, g_Hwnd
    if !(row := lv.GetNext()) {
        MsgBox(GetText("MsgPickRow"))
        return
    }
    hwndText := lv.GetText(row, 3)
    g_Hwnd := hwndText + 0
    if !WinExist("ahk_id " g_Hwnd) {
        MsgBox(GetText("MsgGone"))
        return
    }
    t := WinGetTitle("ahk_id " g_Hwnd)
    txtSel.Text := GetText("LblSelected") " " t
    TrayTip(GetText("AppTitle"), GetText("TrayStored") " " t, 1)
}

EnsureTarget() {
    global g_Hwnd
    if !g_Hwnd || !WinExist("ahk_id " g_Hwnd) {
        SoundBeep(750)
        MsgBox(GetText("MsgNoTarget"))
        return false
    }
    return true
}

MovePhysical(dir, hwnd := 0) {
    global g_Hwnd, g_History
    if !hwnd
        hwnd := g_Hwnd
    if !EnsureTarget()
        return
    wt := "ahk_id " hwnd
    state := WinGetMinMax(wt)
    if (state = -1)
        WinRestore(wt)

    WinGetPos(&x, &y, &w, &h, wt)
    cx := x + w/2, cy := y + h/2

    cnt := MonitorGetCount(), mons := [], curIdx := 1
    Loop cnt {
        MonitorGet(A_Index, &L, &T, &R, &B)
        mons.Push({i:A_Index, L:L, T:T, R:R, B:B, cx:(L+R)/2, cy:(T+B)/2})
        if (cx>=L && cx<R && cy>=T && cy<B)
            curIdx := A_Index
    }

    cur := mons[curIdx]
    best := 0, bestDelta := (dir = "right") ? 1e9 : -1e9
    for m in mons {
        if (m.i = curIdx)
            continue
        dx := m.cx - cur.cx
        if (dir = "right") {
            if (dx > 0 && dx < bestDelta)
                best := m, bestDelta := dx
        } else {
            if (dx < 0 && dx > bestDelta)
                best := m, bestDelta := dx
        }
    }

    if !best {
        for m in mons {
            if (m.i = curIdx)
                continue
            if !best || (dir = "right" ? m.cx < best.cx : m.cx > best.cx)
                best := m
        }
    }

    if !best
        return

    if !g_History.Has(hwnd)
        g_History[hwnd] := []
    g_History[hwnd].Push({mon: curIdx, state: state})

    WinRestore(wt)
    WinMove(best.L+10, best.T+10,,, wt)
    WinMaximize(wt)
}

UndoMove() {
    global g_Hwnd, g_History
    if !EnsureTarget()
        return
    hwnd := g_Hwnd
    if !g_History.Has(hwnd) || g_History[hwnd].Length = 0 {
        SoundBeep(600)
        return
    }
    prev := g_History[hwnd].Pop()
    MonitorGet(prev.mon, &L, &T, &R, &B)
    wt := "ahk_id " hwnd
    WinRestore(wt)
    WinMove(L+10, T+10,,, wt)
    if (prev.state = 1)
        WinMaximize(wt)
}
