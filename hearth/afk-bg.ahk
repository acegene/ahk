#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include <keypress-utils>
#include <mouse-utils>
#include <tool-tip-utils>
#include <window-utils>

title_hearthstone := "Hearthstone"
tool_tip := ToolTipCfg("ur", 1)
ratio_rgbs_bgs_play_button := RatioRgbs([0.740228, 0.740771], [0.750911, 0.752277], [0xffffff, 0xffffff])
ratio_rgbs_bgs_lost_match := RatioRgbs([0.497828, 0.497828], [0.570128, 0.581511], [0xffffff, 0xffffff])

MaximizeAndFocusWindow(title_hearthstone)

x_ratio_play := 0.740228
y_ratio_play := 0.750911

while (true) {
    Sleep(5000)
    MaximizeAndFocusWindow(title_hearthstone)
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_hearthstone)
    msg := ""
    if (ratio_rgbs_bgs_play_button.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        rng := Random()
        x_ratio_play_rng := x_ratio_play + (0.01 * rng)
        y_ratio_play_rng := y_ratio_play + (0.01 * rng)
        msg := msg . "PLAY?Y"
        MaximizeAndFocusWindow(title_hearthstone)
        ClickMouseWindowRatio(title_hearthstone, x_ratio_play_rng, y_ratio_play_rng)
    } else {
        msg := msg . "PLAY?N"
    }
    if (ratio_rgbs_bgs_lost_match.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        rng := Random()
        x_ratio_play_rng := x_ratio_play + (0.01 * rng)
        y_ratio_play_rng := y_ratio_play + (0.01 * rng)
        msg := msg . "LOSS?Y"
        MaximizeAndFocusWindow(title_hearthstone)
        ClickMouseWindowRatio(title_hearthstone, x_ratio_play_rng, y_ratio_play_rng)
    } else {
        msg := msg . "LOSS?N"
    }

    if (Mod(A_Index, 20) = 0) {
        rng := Random()
        x_ratio_play_rng := x_ratio_play + (0.01 * rng)
        y_ratio_play_rng := y_ratio_play + (0.01 * rng)
        MaximizeAndFocusWindow(title_hearthstone)
        ClickMouseWindowRatio(title_hearthstone, x_ratio_play_rng, y_ratio_play_rng)
    }

    tool_tip.DisplayMsg(A_Index . ": " . msg, w_win, h_win)
}


Pause:: Pause -1
$+Space:: Pause -1

$Esc:: {
    ExitApp
}
