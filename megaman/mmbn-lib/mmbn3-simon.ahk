#include "%A_ScriptDir%\mmbn-lib\mmbnx-ratio-rgbs.ahk"

#include <keypress-utils>
#include <timer-utils>
#include <tool-tip-utils>
#include <window-utils>

InitiateSimon(w_win, h_win) {
    if (!mmbn3_ratio_rgbs_simon.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        MsgBox("ERROR: expected to be at simon")
        ExitApp(1)
    }

    HoldKeyE("j", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(100)
    RepeatHoldKeyForDurationE("k", 50, 6500)
    Sleep(2500)
}

PressSimonButton(w_win, h_win) {
    static sleep_per_button := 150

    static ratio_rgbs_up_a_lb := RatioRgbs([0.565625], [0.301852], [0xffffff])
    static ratio_rgbs_down := RatioRgbs([0.571354], [0.332870], [0xffffff])
    static ratio_rgbs_right := RatioRgbs([0.580729], [0.318519], [0xffffff])
    static ratio_rgbs_left := RatioRgbs([0.562760], [0.316204], [0xffffff])
    static ratio_rgbs_b_if_not_arrow := RatioRgbs([0.571354], [0.314815], [0x062f54])

    static button_map := Map(
        "a", "j",
        "b", "k",
        "lb", "q",
        "rb", "e",
        "up", "w",
        "left", "a",
        "down", "s",
        "right", "d",
    )

    if (ratio_rgbs_up_a_lb.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        rgb := GetRatioColor(w_win, h_win, 0.567187, 0.318518)
        if (rgb = 0x062f54) {
            symbol := "a"
        } else if (rgb = 0xffffff) {
            symbol := "lb"
        }
        else {
            symbol := "up"
        }
    } else if (ratio_rgbs_down.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        symbol := "down"
    } else if (ratio_rgbs_right.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        symbol := "right"
    } else if (ratio_rgbs_left.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        symbol := "left"
    } else {
        symbol := ratio_rgbs_b_if_not_arrow.DoesWindowMatchRatioRgbs(w_win, h_win) ? "b" : "rb"
    }

    HoldKeyE(button_map[symbol], 50)
    Sleep(sleep_per_button)
}

PressSimonButtons(w_win, h_win, buttons_per_simon := 99, bugfrags_per_win := 30) {
    Loop buttons_per_simon {
        PressSimonButton(w_win, h_win)
    }

    while (mmbn3_ratio_rgbs_simon_game_active.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        PressSimonButton(w_win, h_win)
    }

    RepeatHoldKeyForDurationE("k", 50, 5500)
}

SimonGameGrinder(w_win, h_win, bugfrags_to_win := 9999, tool_tip := ToolTipCfg(), buttons_per_simon := 99, bugfrags_per_win := 30) {
    timer_simon := Timer()

    bugfrags_won := 0
    num_loops := Ceil(bugfrags_to_win / bugfrags_per_win)
    failures := 0
    loop_index := 1

    if (!mmbn3_ratio_rgbs_simon.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        MsgBox("ERROR: expected to be at simon")
        ExitApp(1)
    }

    while (loop_index <= num_loops) {
        InitiateSimon(w_win, h_win)
        if (!mmbn3_ratio_rgbs_simon_game_active.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            num_loops += 1
            failures += 1
            continue
        }
        PressSimonButtons(w_win, h_win, buttons_per_simon, bugfrags_per_win)

        bugfrags_won += bugfrags_per_win
        duration := timer_simon.ElapsedSec()
        secs_per_win := duration / A_Index
        simon_summary := Map(
            "bugfrags_per_sec", Round(bugfrags_won / duration, 2),
            "bugfrags_to_win", bugfrags_to_win,
            "bugfrags_won", bugfrags_won,
            "buttons_per_simon", buttons_per_simon,
            "duration", Round(duration),
            "est_duration_remaining", Round(secs_per_win * (num_loops - loop_index)),
            "failures", failures,
            "secs_per_win", Round(secs_per_win, 2),
        )

        tool_tip.DisplayMsg(MapToStr(simon_summary), w_win, h_win)
    }

    return simon_summary
}
