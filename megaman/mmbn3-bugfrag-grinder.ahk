#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include "%A_ScriptDir%\mmbn-lib\mmbn3-armor-comp.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-battle.ahk"

#include <keypress-utils>
#include <string-utils>
#include <window-utils>

;; location: 'Yoka'::'Front of Zoo'::'Hotel Front'::'Hotel Lobby'::'Armor Comp'
;; * can reach after first Flashman arc during Beastman arc
;; max bugfrags 9999
;; max chip duplicates 99
;; TODO: new fights are added when game is complete
;; TODO: always selects top option during style change prompt (i.e. upgrade fully then force)

UpdateLoopTooltip(loops_completed, title, x_ratio := 0.005, y_ratio := 0.01, which_tool_tip := 1) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title)
    x_client := x_ratio * w_win
    y_client := y_ratio * h_win
    ToolTip("loops_completed=" . loops_completed, x_client, y_client, which_tool_tip)
}

WalkUntilBattle() {
    while (true) {
        CoordMode("Mouse", "Client")
        WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)
        x_client_health_bar := x_ratio_health_bar_battle * w_win
        y_client_health_bar := y_ratio_health_bar_battle * h_win
        rgb_health_bar_actual := PixelGetColor(x_client_health_bar, y_client_health_bar, "RGB")
        if (rgb_health_bar_actual = rgb_health_bar) {
            break
        }
        HoldKeyE("j", 50)
        HoldTwoKeyE("a", "k", 1000)
        HoldTwoKeyE("d", "k", 900)
    }
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
    MsgBox(GenerateDebugStr("lu lm ld mu mm md ru rm rd x_ratio_l x_ratio_m x_ratio_r y_ratio_u y_ratio_m y_ratio_d w_win h_win"))
}

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

Sleep 1000

MaximizeAndFocusWindow(title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

Loop {
    MaximizeAndFocusWindow(title_megaman_collection_1)

    WalkUntilBattle()

    fight_executed := ExecuteArmorCompBattleIfDetected()

    if (!fight_executed) {
        PrintBattleDebug()
    }

    RepeatHoldKeyForDurationE("k", 50, 1000)

    RepeatHoldKeyForDurationE("j", 50, 6500)

    UpdateLoopTooltip(A_Index, title_megaman_collection_1)
}

+Esc:: {
    ClearHeldKeysE("w a s d j k")
    ExitApp
}
