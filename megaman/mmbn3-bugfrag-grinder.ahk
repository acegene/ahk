#Requires AutoHotkey v2.0-a
#SingleInstance Force

;; location: 'Yoka'::'Front of Zoo'::'Hotel Front'::'Hotel Lobby'::'Armor Comp'
;; * can reach after first Flashman arc during Beastman arc
;; max bugfrags 9999
;; max chip duplicates 99
;; TODO: new fights are added when game is complete
;; TODO: always selects top option during style change prompt (i.e. upgrade fully then force)

MaximizeWindow(window_title){
    style := WinGetStyle(window_title)
    ; 0x1000000 is the WS_MAXIMIZE style
    if !(style & 0x1000000){
        WinMaximize(window_title)
    }
}

FocusWindow(window_title){
    if not WinActive(window_title){
        WinActivate(window_title)
    }
}

MaximizeAndFocusWindow(window_title){
    MaximizeWindow(window_title)
    FocusWindow(window_title)
    Sleep(50)
}

HoldKey(key, duration){
    SendEvent("{" . key . " down}")
    Sleep(duration)
    SendEvent("{" . key . " up}")
}

HoldTwoKey(key_1, key_2, duration){
    SendEvent("{" . key_1 . " down}{" . key_2 . " down}")
    Sleep(duration)
    SendEvent("{" . key_1 . " up}{" . key_2 . " up}")
}

RepeatHoldKeyForDuration(key, duration_key_press, duration_repeat){
    end_time := A_TickCount + duration_repeat
    while (A_TickCount < end_time) {
        HoldKey(key, duration_key_press)
    }
}

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

FindRedMettaurs(w_win, h_win){
    return FindEnemyFieldColorMatches(rgb_mettaur_red, w_win, h_win, w_ratio_mettaur, h_ratio_mettaur)
}

FindYellowMettaurs(w_win, h_win){
    return FindEnemyFieldColorMatches(rgb_mettaur_yellow, w_win, h_win, w_ratio_mettaur, h_ratio_mettaur)
}

UpdateLoopTooltip(loops_completed, title, x_ratio := 0.005, y_ratio := 0.01, which_tool_tip := 1){
    CoordMode("Mouse", "Client")
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title)
    x_client := x_ratio * w_win
    y_client := y_ratio * h_win
    ToolTip("loops_completed=" . loops_completed, x_client, y_client, which_tool_tip)
}

StartBattle(){
    HoldKey("k", 50)
    Sleep(500)
    HoldKey("Enter", 50)
    Sleep(200)
    HoldKey("j", 50)
    Sleep(1300)
}

ClearHeldKeys(){
    SendEvent("{a up}")
    SendEvent("{d up}")
    SendEvent("{j up}")
    SendEvent("{k up}")
}

ClearHeldKeys()

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

Sleep 1000

MaximizeAndFocusWindow(title_megaman_collection_1)

RepeatHoldKeyForDuration("k", 50, 2500)

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
        HoldKey("j", 50)
        HoldTwoKey("a", "k", 1000)
        HoldTwoKey("d", "k", 900)
    }

    existing_red_mettaurs := FindRedMettaurs(w_win, h_win)
    existing_yellow_mettaurs := FindYellowMettaurs(w_win, h_win)

    if(existing_yellow_mettaurs = 40 && existing_red_mettaurs = 0){
        StartBattle()
        Sleep(1650)
        HoldKey("k", 50)
        sleep(1750)
        HoldKey("k", 50)
        sleep(700)
    }else if(existing_yellow_mettaurs = 130 && existing_red_mettaurs = 0){
        StartBattle()
        Sleep(850)
        HoldKey("k", 50)
        sleep(800)
        HoldKey("k", 50)
        sleep(700)
    }else if(existing_yellow_mettaurs = 128 && existing_red_mettaurs = 5){
        StartBattle()
        Sleep(800)
        HoldKey("k", 50)
        sleep(1200)
        HoldKey("k", 50)
        sleep(750)
        HoldKey("k", 50)
    }else if(existing_yellow_mettaurs = 40 && existing_red_mettaurs = 2){
        StartBattle()
        Sleep(400)
        HoldKey("k", 50)
        sleep(1650)
        HoldKey("k", 50)
        sleep(1650)
        HoldKey("k", 50)
    }else if(existing_yellow_mettaurs = 84 && existing_red_mettaurs = 0){
        StartBattle()
        Sleep(1650)
        HoldKey("k", 50)
        sleep(900)
        HoldKey("k", 50)
        sleep(1600)
        HoldKey("k", 50)
    }else if(existing_yellow_mettaurs = 0 && existing_red_mettaurs = 273){
        StartBattle()
        Sleep(750)
        HoldKey("k", 50)
        sleep(800)
        HoldKey("k", 50)
        sleep(1200)
        HoldKey("k", 50)
    }else if(existing_yellow_mettaurs = 273 && existing_red_mettaurs = 0){
        StartBattle()
        Sleep(1650)
        HoldKey("k", 50)
        sleep(900)
        HoldKey("k", 50)
        sleep(1600)
        HoldKey("k", 50)
    }else if(existing_yellow_mettaurs = 0 && existing_red_mettaurs = 84){
        StartBattle()
        Sleep(800)
        HoldKey("k", 50)
        sleep(750)
        HoldKey("k", 50)
        sleep(1150)
        HoldKey("k", 50)
    }else{
        lu := PixelGetColor(x_ratio_l * x_win, y_ratio_u * h_win, "RGB")
        lm := PixelGetColor(x_ratio_l * x_win, y_ratio_m * h_win, "RGB")
        ld := PixelGetColor(x_ratio_l * x_win, y_ratio_d * h_win, "RGB")
        mu := PixelGetColor(x_ratio_m * x_win, y_ratio_u * h_win, "RGB")
        mm := PixelGetColor(x_ratio_m * x_win, y_ratio_m * h_win, "RGB")
        md := PixelGetColor(x_ratio_m * x_win, y_ratio_d * h_win, "RGB")
        ru := PixelGetColor(x_ratio_r * x_win, y_ratio_u * h_win, "RGB")
        rm := PixelGetColor(x_ratio_r * x_win, y_ratio_m * h_win, "RGB")
        rd := PixelGetColor(x_ratio_r * x_win, y_ratio_d * h_win, "RGB")
        MsgBox("existing_yellow_mettaurs=" . existing_yellow_mettaurs . "`n" . "existing_red_mettaurs=" . existing_red_mettaurs . "`n" . "lu=" . lu . "`n" . "lm=" . lm . "`n" . "ld=" . ld . "`n" . "mu=" . mu . "`n" . "mm=" . mm . "`n" . "md=" . md . "`n" . "ru=" . ru . "`n" . "rm=" . rm . "`n" . "rd=" . rd)
    }

    RepeatHoldKeyForDuration("k", 50, 1000)

    RepeatHoldKeyForDuration("j", 50, 6500)

    UpdateLoopTooltip(A_Index, title_megaman_collection_1)
}

Esc::ExitApp
