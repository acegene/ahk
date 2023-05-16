#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include <keypress-utils>
#include <window-utils>

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

MaximizeAndFocusWindow(title_megaman_collection_1)

no_chip := false

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
