#include <keypress-utils>
#include <timer-utils>
#include <tool-tip-utils>
#include <window-utils>

InitiateSimon() {
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

PressSimonButtons(buttons_per_simon := 99, bugfrags_per_win := 30) {
    static sleep_per_button := 150

    static ratio_rgbs_up_a_lb := RatioRgbs([0.565625], [0.301852], [0xffffff])
    static ratio_rgbs_down := RatioRgbs([0.571354], [0.332870], [0xffffff])
    static ratio_rgbs_right := RatioRgbs([0.580729], [0.318519], [0xffffff])
    static ratio_rgbs_left := RatioRgbs([0.562760], [0.316204], [0xffffff])
    static ratio_rgbs_b_if_not_arrow := RatioRgbs([0.571354], [0.314815], [0x062f54])


    Loop buttons_per_simon {
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
            symbol := ratio_rgbs_b_if_not_arrow.DoesWindowMatchAnyRatioRgbs(w_win, h_win) ? "b" : "rb"
        }

        HoldKeyE(button_map[symbol], 50)
        Sleep(sleep_per_button)
    }

    RepeatHoldKeyForDurationE("k", 50, 5500)
}

SimonGameLoop(w_win, h_win, bugfrags_to_win := 9999, tool_tip := ToolTipCfg(), buttons_per_simon := 99, bugfrags_per_win := 30) {
    timer_simon := Timer()

    bugfrags_won := 0
    num_loops := Ceil(bugfrags_to_win / bugfrags_per_win)
    Loop num_loops {
        InitiateSimon()
        PressSimonButtons(buttons_per_simon, bugfrags_per_win)

        bugfrags_won += bugfrags_per_win
        simon_summary := Map(
            "bugfrags_won", bugfrags_won,
            "bugfrags_to_win", bugfrags_to_win,
            "buttons_per_simon", buttons_per_simon,
            "duration", timer_simon.ElapsedSecTruncated(),
        )

        tool_tip.DisplayMsg(MapToStr(simon_summary), w_win, h_win)
    }

    return simon_summary
}
