#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include "%A_ScriptDir%\mmbn-lib\mmbnx-chip-order.ahk"

#include <keypress-utils>
#include <window-utils>

Mmbn3SpamChipOrder() {
    While (True) {
        HoldKeyE("j", 50)
        Sleep(200)
        HoldKeyE("j", 50)
        Sleep(200)
        HoldKeyE("j", 50)
        Sleep(200)
        HoldKeyE("j", 50)
        Sleep(2000)
        HoldKeyE("j", 50)
        Sleep(500)
        HoldKeyE("s", 50)
        Sleep(100)
    }
}

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

MaximizeAndFocusWindow(title_megaman_collection_1)
RepeatHoldKeyForDurationE("k", 50, 2500)

Mmbn3InitiateChipOrder()
Mmbn3SpamChipOrder()

Esc:: {
    ClearHeldKeysE("s j k")
    ExitApp
}