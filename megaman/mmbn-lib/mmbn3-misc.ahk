#include "%A_ScriptDir%\mmbn-lib\mmbnx-ratio-rgbs.ahk"

#include <keypress-utils>
#include <window-utils>

;;;; net actions
WalkUntilBattle(w_win, h_win) {
    while (true) {
        if (mmbn3_ratio_rgbs_health_bar_battle.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            break
        }
        if (mmbn3_ratio_rgbs_main_menu_tm.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            StartGame()
        }
        HoldKeyE("j", 50)
        Hold2KeyE("a", "k", 1000)
        Hold2KeyE("d", "k", 900)
    }
}

JackIn() {
    HoldKeyE("e", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(8000)
}

JackOut() {
    HoldKeyE("e", 50)
    Sleep(300)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("a", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep("1000")
}

JackOutThenIn() {
    JackOut()
    JackIn()
}

;;;; misc actions
StartGame() {
    Sleep(2000)
    HoldKeyE("enter", 50)
    Sleep(500)
    HoldKeyE("j", 50)
    Sleep(3000)
}

ResetGame() {
    HoldKeyE("esc", 50)
    Sleep(1000)
    HoldKeyE("w", 50)
    Sleep(200)
    HoldKeyE("w", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(500)
    HoldKeyE("a", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(2000)
    StartGame()
}

SaveProgress() {
    HoldKeyE("enter", 50)
    Sleep(300)
    HoldKeyE("w", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(1000)
    HoldKeyE("j", 50)
    Sleep(700)
    HoldKeyE("j", 50)
    RepeatHoldKeyForDurationE("k", 50, 1500)
}

SaveProgressOrStartGame(w_win, h_win) {
    if (mmbn3_ratio_rgbs_health_bar_net.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        ;; in net
        SaveProgress()
    } else if (mmbn3_ratio_rgbs_main_menu_tm.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        ;; in main menu
        StartGame()
    } else {
        MsgBox("ERROR: unexpected state")
        ExitApp(1)
    }
}

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
