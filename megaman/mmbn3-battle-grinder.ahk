#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include "%A_ScriptDir%\mmbn-lib\mmbn3-armor-comp.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-battle.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-pet.ahk"

#include <keypress-utils>
#include <tool-tip-utils>
#include <window-utils>

/**
 * Grind battles primarily to facilitate style changes, bugfrags, and guard chips
 * 
 * Prereqs
 *       * BeastMan arc is active or completed in order to make location available
 * Usage
 *       * location: 'Yoka'::'Front of Zoo'::'Hotel Front'::'Hotel Lobby'::'Armor Comp'
 *           * can start script at warp jackin entry point or left corner
 *       * set 'settable vars' below based on your preferences
 *       * exit script by pressing escape key
 * Notes
 *       * zenny can be better obtained using mmbn3-gambler-grinder.ahk
 *       * bugfrags can be better obtained using mmbn3-simon-grinder.ahk
 */

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

;; settable vars
grind_guard_chips := false ;; if true, collect navicust program must be equipped
num_battles_check_text := 10
num_battles_max := ""
num_battles_until_save := 20
health_heal_ratio := 0.7 ;; heal when ratio drops below current_health / total_health
start_battle_chip_state := Mmbn3ChooseStartBattleChipState("none") ;; see Mmbn3ChooseStartBattleChipState docs for options

;; hardcoded vars
tool_tip_cfg_battle := ToolTipCfg("ur", 2)

;; derived vars
battle_func := grind_guard_chips ? ExecuteArmorCompBattleIfDetectedWMettaurStall : ExecuteArmorCompBattleIfDetected

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

BattleGrinder(
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

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
