#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include "%A_ScriptDir%\mmbn-lib\mmbnx-chip-order.ahk"

#include <keypress-utils>
#include <window-utils>

/**
 * Script to buy all chips from chip order
 * 
 * Usage
 *   * stand facing Higby then execute script
 *   * if script gets stuck trying to purchase one undesired chip, spam down key until next chip is highlighted
 *   * exit script by pressing escape key
 */

Mmbn3SpamChipOrder() {
    While (true) {
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
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

Mmbn3InitiateChipOrder(w_win, h_win)
Mmbn3SpamChipOrder()

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
