#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include "%A_ScriptDir%\mmbn-lib\mmbn3-armor-comp.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-battle.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-pet.ahk"

#include <keypress-utils>
#include <window-utils>

;; location: 'Yoka'::'Front of Zoo'::'Hotel Front'::'Hotel Lobby'::'Armor Comp'
;; * can reach after first Flashman arc during Beastman arc
;; NOTE: max bugfrags 9999, max chip duplicates 99
;; TODO: always selects top option during style change prompt (i.e. upgrade fully then force)

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

num_battles_check_zenny := 10
num_battles_max := ""
num_battles_until_save := 50

start_battle_chip_state := { chip_slots_to_send: [1], num_chips_to_use: 0, post_chip_sleeps: [] }

zenny_battle_stop_thresh := 999999

tool_tip_cfg_battle := ToolTipCfg("ur", 2)

WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

MaximizeAndFocusWindow(title_megaman_collection_1)
RepeatHoldKeyForDurationE("k", 50, 2500)

BattleLoop(w_win, h_win, ExecuteArmorCompBattleIfDetected, start_battle_chip_state, num_battles_until_save, "", num_battles_check_zenny, "", tool_tip_cfg_battle)

Esc:: {
    ClearHeldKeysE("w a s d j k e enter")
    ExitApp
}
