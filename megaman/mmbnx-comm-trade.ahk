#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include <keypress-utils>
#include <window-utils>

/**
 * Automate 'Wait for a Request' + 'Send no chip' or 'Send a Request' + 'Get to chip seleciton menu'
 * 
 * usage
 *   * Go to comm menu with 'NetBattle' and 'Trade' listed and highlight 'NetBattle'
 *   * set 'settable vars' below based on your preferences
 *   * exit script by pressing escape key
 * compatibility
 *   * mmbn3
 */

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

;; settable vars
no_chip := false

MaximizeAndFocusWindow(title_megaman_collection_1)

if (no_chip) {
    HoldKeyE("s", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(2000)
    HoldKeyE("q", 50)
    Sleep(500)
    HoldKeyE("j", 50)
    Sleep(500)
    HoldKeyE("j", 50)
    Sleep(500)
} else {
    HoldKeyE("s", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("s", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(2000)
}

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
