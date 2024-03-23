#include "%A_ScriptDir%\merc-utils\battle-utils.ahk"

#include <array-utils>
#include <misc-utils>
#include <mouse-utils>
#include <timer-utils>
#include <tool-tip-utils>
#include <window-utils>

one_sided_mouse_rng_range := 0.002

;; TODO: unused but should be correct
; x_ratio_enter_travel_point := 0.495928
; y_ratio_enter_travel_point := 0.228142
; x_ratio_barrens_normal := 0.668838
; y_ratio_barrens_normal := 0.435603
; x_ratio_travel_point_choose := 0.667210
; y_ratio_travel_point_choose := 0.668488
; x_ratio_1_of_6_bounty := 0.220141
; y_ratio_1_of_6_bounty := 0.301002

BountyTakeTreasure() {
    static x_ratio_bounty_select_treasure_1_of_3 := 0.406623
    static y_ratio_bounty_select_treasure_1_of_3 := 0.448087
    static x_ratio_bounty_take_treasure := 0.582248
    static y_ratio_bounty_take_treasure := 0.804645

    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_select_treasure_1_of_3, y_ratio_bounty_select_treasure_1_of_3, one_sided_mouse_rng_range, "L", 100)
    Sleep(1000)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_take_treasure, y_ratio_bounty_take_treasure, one_sided_mouse_rng_range, "L", 100)
    Sleep(3000)
}

BountyRetire() {
    static x_ratio_bounty_view_party := 0.408252
    static y_ratio_bounty_view_party := 0.877505
    static x_ratio_bounty_retire := 0.565418
    static y_ratio_bounty_retire := 0.698543
    static x_ratio_bounty_retire_confirm := 0.428610
    static y_ratio_bounty_retire_confirm := 0.542805

    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_view_party, y_ratio_bounty_view_party, one_sided_mouse_rng_range, "L", 100)
    Sleep(1500)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_retire, y_ratio_bounty_retire, one_sided_mouse_rng_range, "L", 100)
    Sleep(1000)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_retire_confirm, y_ratio_bounty_retire_confirm, one_sided_mouse_rng_range, "L", 100)
    Sleep(1500)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_retire_confirm, y_ratio_bounty_retire_confirm, one_sided_mouse_rng_range, "L", 100)
    Sleep(1500)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_retire_confirm, y_ratio_bounty_retire_confirm, one_sided_mouse_rng_range, "L", 100)
    Sleep(3000)
}

BountySelectionToBountyMap() {
    static x_ratio_bounty_choose := 0.781216
    static y_ratio_bounty_choose := 0.739526
    static x_ratio_1_of_9_party := 0.220141
    static y_ratio_1_of_9_party := 0.301002
    static x_ratio_bounty_party_choose := 0.732628
    static y_ratio_bounty_party_choose := 0.797814
    static x_ratio_bounty_party_choose_confirm := 0.427796
    static y_ratio_bounty_party_choose_confirm := 0.555100

    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_choose, y_ratio_bounty_choose, one_sided_mouse_rng_range, "L", 100)
    Sleep(3000)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_1_of_9_party, y_ratio_1_of_9_party, one_sided_mouse_rng_range, "L", 100)
    Sleep(1000)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_party_choose, y_ratio_bounty_party_choose, one_sided_mouse_rng_range, "L", 100)
    Sleep(2000)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_party_choose_confirm, y_ratio_bounty_party_choose_confirm, one_sided_mouse_rng_range, "L", 100)
    Sleep(6000)
}

BountyPlay() {
    static x_ratio_bounty_play := 0.787188
    static y_ratio_bounty_play := 0.743169
    static ratio_rgbs_play_from_hand_ready := RatioRgbs([0.814875], [0.423497], [0xd0ad02])

    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_play, y_ratio_bounty_play, one_sided_mouse_rng_range, "L", 100)
    Sleep(1000)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_bounty_play, y_ratio_bounty_play, one_sided_mouse_rng_range, "L", 100)

    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_hearthstone)
    while (!ratio_rgbs_play_from_hand_ready.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        Sleep(1000)
    }
    Sleep(500)
}

OpenBountyRewards() {
    static x_ratio_reward_up_middle := 0.519273
    static y_ratio_reward_up_middle := 0.270947
    static x_ratio_reward_bottoom_left := 0.357220
    static y_ratio_reward_bottoom_left := 0.669854
    static x_ratio_reward_bottoom_right := 0.685396
    static y_ratio_reward_bottoom_right := 0.695811
    static x_ratio_reward_confirm_1 := 0.511129
    static y_ratio_reward_confirm_1 := 0.549636
    static x_ratio_reward_confirm_2 := 0.482628
    static y_ratio_reward_confirm_2 := 0.768215

    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_reward_up_middle, y_ratio_reward_up_middle, one_sided_mouse_rng_range, "L", 100)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_reward_bottoom_left, y_ratio_reward_bottoom_left, one_sided_mouse_rng_range, "L", 100)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_reward_bottoom_right, y_ratio_reward_bottoom_right, one_sided_mouse_rng_range, "L", 100)
    Sleep(1000)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_reward_confirm_1, y_ratio_reward_confirm_1, one_sided_mouse_rng_range, "L", 100)
    Sleep(2000)
    ClickMouseWindowRatioRngRange(title_hearthstone, x_ratio_reward_confirm_2, y_ratio_reward_confirm_2, one_sided_mouse_rng_range, "L", 100)
    Sleep(2000)
}

DetectStatus() {
    static rgb_take_treasure := 0x79552c
    static ratio_rgbs_take_treasure := RatioRgbs([0.481542], [0.235428], [rgb_take_treasure])
    static rgb_bounty_selection := 0x443423
    static ratio_rgbs_bounty_selection := RatioRgbs([0.848534], [0.057832], [rgb_bounty_selection])
    static x_ratio_rgbs_play_from_hand_ready := 0.814875
    static y_ratio_rgbs_play_from_hand_ready := 0.423497
    static rgb_play_from_hand_avg := 0xcfac03 ; 0xd0ae03, 0xd0ad02, 0xceaa01, 0xceaa00, 0xcfac01, 0xceab00
    static rgb_open_rewards := 0x000818
    static ratio_rgbs_open_rewards := RatioRgbs([0.495385], [0.461749], [rgb_open_rewards])
    static tool_tip := ToolTipCfg("ul", 2)

    MaximizeAndFocusWindow(title_hearthstone)
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_hearthstone)

    rgb_play_from_hand_ready_actual := GetRatioColor(w_win, h_win, x_ratio_rgbs_play_from_hand_ready, y_ratio_rgbs_play_from_hand_ready)
    rgb_take_treasure_actual := ratio_rgbs_take_treasure.GetWindowRatioRgbs(w_win, h_win)[1]
    rgb_bounty_selection_actual := ratio_rgbs_bounty_selection.GetWindowRatioRgbs(w_win, h_win)[1]
    rgb_open_rewards_actual := ratio_rgbs_open_rewards.GetWindowRatioRgbs(w_win, h_win)[1]

    ;; TODO: green ready button after all actions in battle are queued up
    tool_tip.DisplayMsg(
        "take_treasure:" . rgb_take_treasure_actual .
        "`nbounty_selection:" . rgb_bounty_selection_actual .
        "`nplay_from_hand:" . rgb_play_from_hand_ready_actual .
        "`nopen_rewards:" . rgb_open_rewards_actual,
        w_win,
        h_win,
    )

    if (rgb_take_treasure_actual == rgb_take_treasure) {
        return "take_treasure"
    }
    if (rgb_bounty_selection_actual == rgb_bounty_selection) {
        return "bounty_selection"
    }
    if (AreColorsNear(rgb_play_from_hand_ready_actual, rgb_play_from_hand_avg, 3)) {
        if (GetActionlessFriendlies().Length == 0) {
            return "minions_died_need_to_replace"
        } else {
            return "start_turn"
        }
    }
    if (rgb_open_rewards_actual == rgb_open_rewards_actual) {
        return "open_rewards"
    }

    return ""
}

SpeedupAnimations(duration) {
    static x_ratio_speedup_animation := 0.217949
    static y_ratio_speedup_animation := 0.364011
    static timer_animations := Timer()
    timer_animations.Reset()

    x := x_ratio_speedup_animation + (0.05 * Random() * (Random() > 0.5 ? 1 : -1))
    y := y_ratio_speedup_animation + (0.05 * Random() * (Random() > 0.5 ? 1 : -1))
    while (timer_animations.ElapsedMilliSec() < duration) {
        ClickMouseWindowRatio(title_hearthstone, x, y, "L", 100)
        SleepRandom(300)
    }
}

SpeedupAnimationsUntilStatusDetected(duration_between_checks := 2000) {
    static timer_dbg := Timer()
    static abort_duration_mins := 1

    timer_dbg.Reset()
    while (timer_dbg.ElapsedMin() < abort_duration_mins) {
        status := DetectStatus()
        if (status != "") {
            Sleep(1000)
            return status
        }
        SpeedupAnimations(duration_between_checks)
    }
    MsgBox("ERROR: SpeedupAnimationsUntilStatusDetected(): status not found within abort_duration_mins='" . abort_duration_mins . "'")
    ExitApp(1)
}
