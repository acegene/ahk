#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

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

grind_guard_chips := false
num_battles_check_text := 10
num_battles_max := ""
num_battles_until_save := 20
health_heal_ratio := 0.7
start_battle_chip_state := ChooseStartBattleChipState("custom")

zenny_battle_stop_thresh := 999999

tool_tip_cfg_battle := ToolTipCfg("ur", 2)

battle_func := grind_guard_chips ? ExecuteArmorCompBattleIfDetectedWMettaurStall : ExecuteArmorCompBattleIfDetected

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

BattleLoop(
    w_win,
    h_win,
    battle_func,
    start_battle_chip_state,
    num_battles_until_save,
    health_heal_ratio,
    "",
    num_battles_check_text,
    "",
    "",
    tool_tip_cfg_battle,
)

Esc:: {
    ClearHeldKeysE("w a s d j k e enter")
    ExitApp
}
