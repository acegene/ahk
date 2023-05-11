#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#Include <keypress-utils>
#Include <window-utils>

MenuSelection(btn, info) {
    global gui_focus_timer
    global gui_script_selection
    global hotkey_bases
    global hotkey_file_map
    global LB
    global show_gui

    index_selection := LB.Value

    gui_script_selection.Hide
    SetHotkeys(hotkey_bases, hotkey_file_map.Count, "Off")
    SetTimer(gui_focus_timer, 0)
    show_gui := false

    Run(hotkey_file_map[hotkey_bases[index_selection]].file_path)
}

GeneralHotkeyFunc(hotkey_pressed) {
    global hotkey_file_map

    Run(hotkey_file_map[hotkey_pressed].file_path)
}

SetHotkeys(hotkey_bases, num_hotkeys, callback) {
    loop num_hotkeys {
        Hotkey(hotkey_bases[A_Index], callback)
    }
}

FocusActions() {
    global gui_focus_timer
    global gui_script_selection
    global show_gui

    if (!WinActive(GuiFromHwnd(gui_script_selection.Hwnd).Title)) {
        gui_script_selection.Hide
        SetHotkeys(hotkey_bases, hotkey_file_map.Count, "Off")
        SetTimer(gui_focus_timer, 0)
        show_gui := false
    }
}

if (A_Args.Length != 1) {
    MsgBox("ERROR: expected one cmd line argument equal to the mmbn version")
    ExitApp(1)
}

mmbn_version_number := A_Args[1]
if (!IsInteger(mmbn_version_number) || mmbn_version_number < 1 || mmbn_version_number > 6) {
    MsgBox("ERROR: unexpected mmbn_version_number=" . mmbn_version_number . "; Please pass 1-6 as a cmd line arg")
    ExitApp(1)
}

mmbn_version := "mmbn" . mmbn_version_number
mmbn_all_versions := "mmbnx"

title_megaman := mmbn_version_number < 4 ? "MegaMan_BattleNetwork_LegacyCollection_Vol1" : "MegaMan_BattleNetwork_LegacyCollection_Vol2"

gui_focus_timer := ObjBindMethod(FocusActions)
hotkey_bases := ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
show_gui := false

hotkey_file_map := Map()
menu_choices := []
Loop Files, A_ScriptDir . "\*"
{
    if (StrLower(A_LoopFileExt) = "ahk" && A_LoopFileName != A_ScriptName && (InStr(A_LoopFileName, mmbn_version) || InStr(A_LoopFileName, mmbn_all_versions))) {
        key := hotkey_bases[hotkey_file_map.Count + 1]
        hotkey_file_map[key] := {
            file_name: A_LoopFileName,
            file_path: A_LoopFileFullPath,
        }
        menu_choices.Push(key . ": " . A_LoopFileName)
    }
}

SetHotkeys(hotkey_bases, hotkey_file_map.Count, GeneralHotkeyFunc)
SetHotkeys(hotkey_bases, hotkey_file_map.Count, "Off")

gui_script_selection := Gui(), gui_script_selection.SetFont('s10')
LB := gui_script_selection.AddListBox('w300 R' . menu_choices.Length, menu_choices)
gui_script_selection.AddButton('wp Default', 'OK').OnEvent('Click', MenuSelection)

$!m:: {
    global show_gui
    global gui_focus_timer
    global title_megaman

    show_gui := !show_gui
    if (show_gui) {
        gui_script_selection.Show
        SetHotkeys(hotkey_bases, hotkey_file_map.Count, "On")
        SetTimer(gui_focus_timer, 250)
    } else {
        gui_script_selection.Hide
        SetHotkeys(hotkey_bases, hotkey_file_map.Count, "Off")
        SetTimer(gui_focus_timer, 0)
        MaximizeAndFocusWindow(title_megaman)
    }
}

$+Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
