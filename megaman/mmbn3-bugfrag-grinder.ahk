#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include <keypress-utils>
#include <string-utils>
#include <window-utils>

;; location: 'Yoka'::'Front of Zoo'::'Hotel Front'::'Hotel Lobby'::'Armor Comp'
;; * can reach after first Flashman arc during Beastman arc
;; max bugfrags 9999
;; max chip duplicates 99
;; TODO: new fights are added when game is complete
;; TODO: always selects top option during style change prompt (i.e. upgrade fully then force)

FindEnemyFieldColorMatches(rgb, w_win, h_win, w_ratio_offset, h_ratio_offset){
    x_l_color_check := (x_ratio_l + w_ratio_offset) * w_win
    x_m_color_check := (x_ratio_m + w_ratio_offset) * w_win
    x_r_color_check := (x_ratio_r + w_ratio_offset) * w_win
    y_u_color_check := (y_ratio_u + h_ratio_offset) * h_win
    y_m_color_check := (y_ratio_m + h_ratio_offset) * h_win
    y_d_color_check := (y_ratio_d + h_ratio_offset) * h_win

    CoordMode("Mouse", "Client")
    result := 0
    if(rgb = PixelGetColor(x_l_color_check, y_u_color_check, "RGB")){
        result := result + 1
    }
    if(rgb = PixelGetColor(x_l_color_check, y_m_color_check, "RGB")){
        result := result + 2
    }
    if(rgb = PixelGetColor(x_l_color_check, y_d_color_check, "RGB")){
        result := result + 4
    }
    if(rgb = PixelGetColor(x_m_color_check, y_u_color_check, "RGB")){
        result := result + 8
    }
    if(rgb = PixelGetColor(x_m_color_check, y_m_color_check, "RGB")){
        result := result + 16
    }
    if(rgb = PixelGetColor(x_m_color_check, y_d_color_check, "RGB")){
        result := result + 32
    }
    if(rgb = PixelGetColor(x_r_color_check, y_u_color_check, "RGB")){
        result := result + 64
    }
    if(rgb = PixelGetColor(x_r_color_check, y_m_color_check, "RGB")){
        result := result + 128
    }
    if(rgb = PixelGetColor(x_r_color_check, y_d_color_check, "RGB")){
        result := result + 256
    }

    return result
}

FindRedMettaur(w_win, h_win){
    return FindEnemyFieldColorMatches(rgb_mettaur_red, w_win, h_win, w_ratio_mettaur, h_ratio_mettaur)
}

FindYellowMettaur(w_win, h_win){
    return FindEnemyFieldColorMatches(rgb_mettaur_yellow, w_win, h_win, w_ratio_mettaur, h_ratio_mettaur)
}

FindFishy3(w_win, h_win){
    return FindEnemyFieldColorMatches(rgb_fishy3, w_win, h_win, w_ratio_fishy, h_ratio_fishy)
}

FindHardHead(w_win, h_win){
    return FindEnemyFieldColorMatches(rgb_hard_head, w_win, h_win, w_ratio_hard_head, h_ratio_hard_head)
}

StartBattle(){
    HoldKeyE("k", 50)
    Sleep(500)
    HoldKeyE("Enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1300)
}

UpdateLoopTooltip(loops_completed, title, x_ratio := 0.005, y_ratio := 0.01, which_tool_tip := 1){
    CoordMode("Mouse", "Client")
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title)
    x_client := x_ratio * w_win
    y_client := y_ratio * h_win
    ToolTip("loops_completed=" . loops_completed, x_client, y_client, which_tool_tip)
}

ClearHeldKeysE("a d j k")

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

x_ratio_l_field_edge := 0.499740
y_ratio_u_field_edge := 0.538889
x_ratio_r_field_edge := 0.873958
y_ratio_d_field_edge := 0.942593

w_square := (x_ratio_r_field_edge - x_ratio_l_field_edge) / 3.0
h_square := (y_ratio_d_field_edge - y_ratio_u_field_edge) / 3.0

x_ratio_m := 0.5 * (x_ratio_l_field_edge + x_ratio_r_field_edge)
x_ratio_l := x_ratio_m - w_square
x_ratio_r := x_ratio_m + w_square
y_ratio_m := 0.5 * (y_ratio_u_field_edge + y_ratio_d_field_edge)
y_ratio_u := y_ratio_m - h_square
y_ratio_d := y_ratio_m + h_square

rgb_health_bar := 0x3f5975
x_ratio_health_bar_battle := 0.631250
y_ratio_health_bar_battle := 0.098148

rgb_mettaur_yellow := 0xffD400
rgb_mettaur_red := 0xff4862
x_ratio_m_mettaur := 0.695052
y_ratio_m_mettaur := 0.652315
w_ratio_mettaur := x_ratio_m_mettaur - x_ratio_m
h_ratio_mettaur := y_ratio_m_mettaur - y_ratio_m

rgb_fishy3 := 0xffb61b
x_ratio_l_fishy := 0.627083
y_ratio_d_fishy := 0.728704
w_ratio_fishy := x_ratio_l_fishy - x_ratio_l
h_ratio_fishy := y_ratio_d_fishy - y_ratio_d

rgb_hard_head := 0x3f2c48
x_ratio_l_hard_head := x_ratio_l
y_ratio_d_hard_head := y_ratio_d
w_ratio_hard_head := x_ratio_l_hard_head - x_ratio_l
h_ratio_hard_head := y_ratio_d_hard_head - y_ratio_d

Sleep 1000

MaximizeAndFocusWindow(title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

Loop{
    MaximizeAndFocusWindow(title_megaman_collection_1)

    while(true){
        CoordMode("Mouse", "Client")
        WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)
        x_client_health_bar := x_ratio_health_bar_battle * w_win
        y_client_health_bar := y_ratio_health_bar_battle * h_win
        rgb_health_bar_actual := PixelGetColor(x_client_health_bar, y_client_health_bar, "RGB")
        if(rgb_health_bar_actual = rgb_health_bar){
            break
        }
        HoldKeyE("j", 50)
        HoldTwoKeyE("a", "k", 1000)
        HoldTwoKeyE("d", "k", 900)
    }

    existing_red_mettaur := FindRedMettaur(w_win, h_win)
    existing_yellow_mettaur := FindYellowMettaur(w_win, h_win)
    existing_fishy3 := FindFishy3(w_win, h_win)
    existing_hard_head := FindHardHead(w_win, h_win)

    if(existing_yellow_mettaur = 40 && existing_red_mettaur = 0){
        StartBattle()
        Sleep(1650)
        HoldKeyE("k", 50)
        sleep(1750)
        HoldKeyE("k", 50)
        sleep(700)
    }else if(existing_yellow_mettaur = 130 && existing_red_mettaur = 0){
        StartBattle()
        Sleep(850)
        HoldKeyE("k", 50)
        sleep(800)
        HoldKeyE("k", 50)
        sleep(700)
    }else if(existing_yellow_mettaur = 128 && existing_red_mettaur = 5){
        StartBattle()
        Sleep(800)
        HoldKeyE("k", 50)
        sleep(1200)
        HoldKeyE("k", 50)
        sleep(750)
        HoldKeyE("k", 50)
    }else if(existing_yellow_mettaur = 40 && existing_red_mettaur = 2){
        StartBattle()
        Sleep(400)
        HoldKeyE("k", 50)
        sleep(1650)
        HoldKeyE("k", 50)
        sleep(1650)
        HoldKeyE("k", 50)
    }else if(existing_yellow_mettaur = 84 && existing_red_mettaur = 0){
        StartBattle()
        Sleep(1650)
        HoldKeyE("k", 50)
        sleep(900)
        HoldKeyE("k", 50)
        sleep(1600)
        HoldKeyE("k", 50)
    }else if(existing_yellow_mettaur = 0 && existing_red_mettaur = 273){
        StartBattle()
        Sleep(750)
        HoldKeyE("k", 50)
        sleep(800)
        HoldKeyE("k", 50)
        sleep(1200)
        HoldKeyE("k", 50)
    }else if(existing_yellow_mettaur = 273 && existing_red_mettaur = 0){
        StartBattle()
        Sleep(1650)
        HoldKeyE("k", 50)
        sleep(900)
        HoldKeyE("k", 50)
        sleep(1600)
        HoldKeyE("k", 50)
    }else if(existing_yellow_mettaur = 0 && existing_red_mettaur = 84){
        StartBattle()
        Sleep(800)
        HoldKeyE("k", 50)
        sleep(750)
        HoldKeyE("k", 50)
        sleep(1150)
        HoldKeyE("k", 50)
    }else{
        lu := PixelGetColor(x_ratio_l * w_win, y_ratio_u * h_win, "RGB")
        lm := PixelGetColor(x_ratio_l * w_win, y_ratio_m * h_win, "RGB")
        ld := PixelGetColor(x_ratio_l * w_win, y_ratio_d * h_win, "RGB")
        mu := PixelGetColor(x_ratio_m * w_win, y_ratio_u * h_win, "RGB")
        mm := PixelGetColor(x_ratio_m * w_win, y_ratio_m * h_win, "RGB")
        md := PixelGetColor(x_ratio_m * w_win, y_ratio_d * h_win, "RGB")
        ru := PixelGetColor(x_ratio_r * w_win, y_ratio_u * h_win, "RGB")
        rm := PixelGetColor(x_ratio_r * w_win, y_ratio_m * h_win, "RGB")
        rd := PixelGetColor(x_ratio_r * w_win, y_ratio_d * h_win, "RGB")
        MsgBox(GenerateDebugStr("existing_yellow_mettaur existing_red_mettaur existing_fishy3 existing_hard_head lu lm ld mu mm md ru rm rd x_ratio_l x_ratio_m x_ratio_r y_ratio_u y_ratio_m y_ratio_d w_win h_win"))
    }

    RepeatHoldKeyForDurationE("k", 50, 1000)

    RepeatHoldKeyForDurationE("j", 50, 6500)

    UpdateLoopTooltip(A_Index, title_megaman_collection_1)
}

Esc::ExitApp
