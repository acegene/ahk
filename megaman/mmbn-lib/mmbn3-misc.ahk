#include <keypress-utils>
#include <window-utils>

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
x_ratio_health_bar_net := 0.253906
y_ratio_health_bar_net := 0.098148

rgb_main_menu_tm_1 := 0x000000
rgb_main_menu_tm_2 := 0xffffff
x_ratio_main_menu_tm_1 := 0.794792
x_ratio_main_menu_tm_2 := 0.797656
y_ratio_main_menu_tm_1 := 0.127778
y_ratio_main_menu_tm_2 := 0.140741

rgb_megaman_side_foot := 0x0b9bdd
x_ratio_megaman_side_foot := 0.499479
y_ratio_megaman_side_foot := 0.511111

;;;; battle actions
ShootAndContinueUntilBattleOver(title) {
    while (true) {
        if (IsWindowRatioColorEqualToColor(title, x_ratio_megaman_side_foot, y_ratio_megaman_side_foot, rgb_megaman_side_foot)) {
            break
        }
        HoldKeyE("k", 50)
        Sleep(100)
        HoldKeyE("j", 50)
        Sleep(100)
    }
}

StartBattle(start_battle_chip_state) {
    HoldKeyE("enter", 50)
    Sleep(100)
    Loop 5 {
        HoldKeyE("d", 50)
        Sleep(100)
    }
    for chip_slot in start_battle_chip_state.chip_slots_to_send {
        HoldKeyE("enter", 50)
        Sleep(100)
        Loop chip_slot {
            HoldKeyE("d", 50)
            Sleep(100)
            HoldKeyE("j", 50)
            Sleep(100)
        }
    }
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1320)
    Loop start_battle_chip_state.num_chips_to_use {
        HoldKeyE("j", 50)
        Sleep(start_battle_chip_state.post_chip_sleeps[A_Index])
    }
}

StartBattleSendChip1() {
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("d", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1300)
}

StartBattleUseTimestopChip1(timestop_duration) {
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("d", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1320)
    HoldKeyE("j", 50)
    Sleep(timestop_duration)
}

DoReflect() {
    SendEvent("{k down}")
    Sleep(30)
    SendEvent("{a down}")
    Sleep(30)
    SendEvent("{k up}")
    Sleep(50)
    SendEvent("{a up}")
    Sleep(400)
}

;;;; net actions
StartGame() {
    Sleep(2000)
    HoldKeyE("enter", 50)
    Sleep(500)
    HoldKeyE("j", 50)
    Sleep(3000)
}

WalkUntilBattle(title) {
    while (true) {
        if (IsWindowRatioColorEqualToColor(title, x_ratio_health_bar_battle, y_ratio_health_bar_battle, rgb_health_bar)) {
            break
        }
        if (AreWindowRatioColorsEqualToColors(title, [x_ratio_main_menu_tm_1, x_ratio_main_menu_tm_2], [y_ratio_main_menu_tm_1, y_ratio_main_menu_tm_2], [rgb_main_menu_tm_1, rgb_main_menu_tm_2])) {
            StartGame()
        }
        HoldKeyE("j", 50)
        HoldTwoKeyE("a", "k", 1000)
        HoldTwoKeyE("d", "k", 900)
    }
}

JackOutThenIn() {
    ;; jack out
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
    ;; jack in
    HoldKeyE("e", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(8000)
}

;;;; misc actions
SaveProgressOrStartGame(title) {
    if (IsWindowRatioColorEqualToColor(title, x_ratio_health_bar_net, y_ratio_health_bar_net, rgb_health_bar)) {
        ;; in net
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
    } else if (AreWindowRatioColorsEqualToColors(title, [x_ratio_main_menu_tm_1, x_ratio_main_menu_tm_2], [y_ratio_main_menu_tm_1, y_ratio_main_menu_tm_2], [rgb_main_menu_tm_1, rgb_main_menu_tm_2])) {
        ;; in main menu
        StartGame()
    } else {
        MsgBox("ERROR: unexpected state")
        ExitApp(1)
    }
}
