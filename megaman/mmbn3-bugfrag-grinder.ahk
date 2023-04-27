#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include "%A_ScriptDir%\mmbn-lib\mmbn3-armor-comp.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"

#include <keypress-utils>
#include <string-utils>
#include <window-utils>

;; location: 'Yoka'::'Front of Zoo'::'Hotel Front'::'Hotel Lobby'::'Armor Comp'
;; * can reach after first Flashman arc during Beastman arc
;; max bugfrags 9999
;; max chip duplicates 99
;; TODO: always selects top option during style change prompt (i.e. upgrade fully then force)

UpdateLoopTooltip(loops_completed, title, x_ratio := 0.005, y_ratio := 0.01, which_tool_tip := 1) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title)
    x_client := x_ratio * w_win
    y_client := y_ratio * h_win
    ToolTip("loops_completed=" . loops_completed, x_client, y_client, which_tool_tip)
}

PrintBattleDebug() {
    CoordMode("Mouse", "Client")
    global x_win, y_win, w_win, h_win, title_megaman_collection_1
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)
    global lu := PixelGetColor(x_ratio_l * w_win, y_ratio_u * h_win, "RGB")
    global lm := PixelGetColor(x_ratio_l * w_win, y_ratio_m * h_win, "RGB")
    global ld := PixelGetColor(x_ratio_l * w_win, y_ratio_d * h_win, "RGB")
    global mu := PixelGetColor(x_ratio_m * w_win, y_ratio_u * h_win, "RGB")
    global mm := PixelGetColor(x_ratio_m * w_win, y_ratio_m * h_win, "RGB")
    global md := PixelGetColor(x_ratio_m * w_win, y_ratio_d * h_win, "RGB")
    global ru := PixelGetColor(x_ratio_r * w_win, y_ratio_u * h_win, "RGB")
    global rm := PixelGetColor(x_ratio_r * w_win, y_ratio_m * h_win, "RGB")
    global rd := PixelGetColor(x_ratio_r * w_win, y_ratio_d * h_win, "RGB")
    MsgBox(GenerateDebugStr("lu lm ld mu mm md ru rm rd x_ratio_l x_ratio_m x_ratio_r y_ratio_u y_ratio_m y_ratio_d w_win h_win main_menu_tm"))
}

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"
num_battles_until_save := 100
start_battle_chip_state := { chip_slots_to_send: [1, 2, 3, 4, 5], num_chips_to_use: 0, post_chip_sleeps: [] }

Sleep 1000

MaximizeAndFocusWindow(title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

Loop {
    MaximizeAndFocusWindow(title_megaman_collection_1)

    WalkUntilBattle(title_megaman_collection_1)

    fight_executed := ExecuteArmorCompBattleIfDetected(start_battle_chip_state)

    if (!fight_executed) {
        PrintBattleDebug()
    }

    ShootAndContinueUntilBattleOver(title_megaman_collection_1)

    if (Mod(A_Index, num_battles_until_save) = 0) {
        SaveProgressOrStartGame(title_megaman_collection_1)
        JackOutThenIn()
    }

    UpdateLoopTooltip(A_Index, title_megaman_collection_1)
}

Esc:: {
    ClearHeldKeysE("w a s d j k e enter")
    ExitApp
}
