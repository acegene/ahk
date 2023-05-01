#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include "%A_ScriptDir%\mmbn-lib\mmbn3-gambler.ahk"

#include <keypress-utils>
#include <tool-tip-utils>
#include <window-utils>

;; location: Beach::'Beach St'::Shoreline::'Hosp Lobby'::'Vending Comp'

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

tool_tip_cfg_gambler := ToolTipCfg("ul", 1)

WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

MaximizeAndFocusWindow(title_megaman_collection_1)
RepeatHoldKeyForDurationE("k", 50, 2500)

GamblerLoop(w_win, h_win, "", tool_tip_cfg_gambler)

$Esc:: {
    ClearHeldKeysE("w a s d j k e enter")
    ExitApp
}
