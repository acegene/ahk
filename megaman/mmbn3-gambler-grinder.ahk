#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include "%A_ScriptDir%\mmbn-lib\mmbn3-gambler.ahk"

#include <keypress-utils>
#include <tool-tip-utils>
#include <window-utils>

/**
 * Grind gambler to obtain zenny
 * 
 * prereqs
 *   * PlantMan arc is active or completed in order to make location available
 * usage
 *   * location: Beach::'Beach St'::Shoreline::'Hosp Lobby'::'Vending Comp'
 *   * stand facing gambler then execute script
 *   * exit script by pressing escape key
 * notes
 *   * 3 wins of gambler are the max because 4 wins causes gambler to go bankrupt indefinitely
 */

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

tool_tip_cfg_gambler := ToolTipCfg("ul", 1)

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

GamblerLoop(w_win, h_win, "", tool_tip_cfg_gambler)

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
