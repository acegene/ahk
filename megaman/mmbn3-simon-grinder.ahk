#Requires AutoHotkey v2.0
#SingleInstance Force
#include <optimizations-gaming>

#include "%A_ScriptDir%\mmbn-lib\mmbn3-simon.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-pet.ahk"

#include <tool-tip-utils>
#include <window-utils>

/**
 * Grind gambler to obtain zenny
 *
 * prereqs
 *   * 'Under Square' location is available
 * usage
 *   * location: 'Under Square'
 *   * stand facing simon minigame navi then execute script
 *   * exit script by pressing escape key
 */

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

;; hardcoded vars
bugfrags_max := 9999
bugfrags_per_win := 30
buttons_per_simon := 99
tool_tip := ToolTipCfg()

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

bugfrags_initial := Mmbn3GetPetText(w_win, h_win, ["bugfrags"])["bugfrags"]
bugfrags_to_win := bugfrags_max - bugfrags_initial

SimonGameGrinder(w_win, h_win, bugfrags_to_win, tool_tip, buttons_per_simon, bugfrags_per_win)

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
