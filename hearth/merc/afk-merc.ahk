#Requires AutoHotkey v2.0
#SingleInstance Force
#include <optimizations-gaming>

#include "merc-utils\battle-utils.ahk"
#include "merc-utils\misc-utils.ahk"

#include <array-utils>
#include <keypress-utils>
#include <misc-utils>
#include <mouse-utils>
#include <string-utils>
#include <tool-tip-utils>
#include <window-utils>

title_hearthstone := "Hearthstone"
tool_tip := ToolTipCfg("ur", 1)
ratio_rgbs_merc_main_menu := RatioRgbs([0.541260, 0.363192], [0.096084, 0.140255], [0x12131e, 0x181927])

MaximizeAndFocusWindow(title_hearthstone)

win_title := ""
minutes_per_battle := 15

while (true) {
    MaximizeAndFocusWindow(title_hearthstone)
    current_status := SpeedupAnimationsUntilStatusDetected()

    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_hearthstone)
    num_iters := A_Index
    tool_tip.DisplayMsg(num_iters . ": " . current_status, w_win, h_win)
    switch current_status {
        case "bounty_selection": ;; no action
            BountySelectionToBountyMap()
            BountyPlay()
            PlayFromHandPhase(1, 2, 3)
            if (win_title != "") {
                try {
                    MaximizeAndFocusWindow(win_title)
                } catch TargetError {
                }
            }
            Loop minutes_per_battle {
                tool_tip.DisplayMsg(num_iters . ": " . current_status . ": mins=" . A_Index - 1, w_win, h_win)
                Sleep(60000)
            }
            try {
                win_title := WinGetTitle("A")
            } catch TargetError {
                win_title := ""
            }
        case "minions_died_need_to_replace":
            FarmFire("rgbs")
            PressReady()
        case "open_rewards":
            OpenBountyRewards()
        case "start_turn":
            num_friendly_minions := GetNumFriendlyMinions()
            FarmFire(SubStr("rgbs", 1, num_friendly_minions))
            PressReady()
        case "take_treasure":
            BountyTakeTreasure()
            BountyRetire()
        default: MsgBox("ERROR: unexpected result from SpeedupAnimationsUntilStatusDetected(): current_status=" . current_status)
    }
}


Pause:: Pause -1
$+Space:: Pause -1

$Esc:: {
    ExitApp
}
