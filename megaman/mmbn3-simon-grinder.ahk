#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include "%A_ScriptDir%\mmbn-lib\mmbn3-simon.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-pet.ahk"

#include <tool-tip-utils>
#include <window-utils>

;; location: 'Under Square'

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

tool_tip := ToolTipCfg()

buttons_per_simon := 99
bugfrags_max := 9999
bugfrags_per_win := 30
bugfrags_to_win := 70

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

bugfrags_initial := GetPetText(w_win, h_win, ["bugfrags"])["bugfrags"]
bugfrags_to_win := bugfrags_max - bugfrags_initial

SimonGameGrinder(w_win, h_win, bugfrags_to_win, tool_tip, buttons_per_simon, bugfrags_per_win)

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
