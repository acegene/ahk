#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"

#include <keypress-utils>
#include <string-utils>
#include <window-utils>

InitiateGambler() {
    HoldKeyE("j", 50)
    Sleep(100)
    SendEvent("{k down}")
    Sleep(700)
    HoldKeyE("j", 50)
    Sleep(700)
}

Gamble(w_win, h_win, number_of_wins, sleeps_pre_gamble) {
    number_of_wins_actual := 0
    Loop number_of_wins {
        Sleep(sleeps_pre_gamble[A_Index])
        ;; click "Yes" or "Try Again?"
        HoldKeyE("j", 50)
        Sleep(100)
        SendEvent("{k down}")
        Sleep(3800)
        HoldKeyE("j", 50)
        Sleep(200)
        HoldKeyE("j", 50)
        Sleep(300)
        HoldKeyE("j", 50)
        Sleep(200)
        HoldKeyE("j", 50)
        Sleep(2500)
        is_success := ratio_rgbs_gambler_success_win_round.DoesWindowMatchRatioRgbs(w_win, h_win)
        if (!is_success) {
            SendEvent("{k up}")
            ResetGame()
            return {
                number_of_wins_actual: number_of_wins_actual,
                gamble_win: false,
            }
        }
        Sleep(1000)
        HoldKeyE("j", 50)
        Sleep(200)
        HoldKeyE("j", 50)
        Sleep(250)
        number_of_wins_actual += 1
    }
    SendEvent("{k up}")
    Sleep(3000)
    HoldKeyE("d", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(500)
    RepeatHoldKeyForDurationE("j", 50, 5000)
    Sleep(100)
    HoldKeysE(["d", "k"], 200)
    Sleep(100)
    HoldKeysE(["w", "k"], 300)
    Sleep(500)
    if (ratio_rgbs_megaman_back.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        SaveProgress()
        return {
            number_of_wins_actual: number_of_wins_actual,
            gamble_win: true,
        }
    } else {
        ResetGame()
        return {
            number_of_wins_actual: number_of_wins_actual,
            gamble_win: false,
        }
    }
}

GamblerLoop(w_win, h_win, zenny_to_gain := "", tool_tip_cfg_gambler := ToolTipCfg()) {
    num_rounds_to_win := 3 ;; 4 times bankrupts gambler
    zenny_gambler_base := 1000
    fails_until_reset := 20
    reset_sleep := 5000
    sleeps_pre_gamble := [0, 0, 0]
    sleeps_increment := [100, 100, 100]
    sleeps_redos_per_round_win := [2, 2]

    zenny_per_win := (4 ** num_rounds_to_win) * zenny_gambler_base
    sleeps_retries_since_win_default := [0, 0]
    sleeps_redos_per_round := sleeps_retries_since_win_default

    gamble_win := false
    zenny_won := 0
    num_resets := 0
    num_losses := 0
    num_losses_consecutive := 0
    num_wins := 0
    num_runs := 0
    num_no_megaman_back := 0

    SaveProgress()
    ResetGame()
    while (true) {
        InitiateGambler()
        gamble_result := Gamble(w_win, h_win, num_rounds_to_win, sleeps_pre_gamble)

        if (gamble_result.gamble_win) {
            sleeps_pre_gamble := [0.0, 0.0, 0.0]
            sleeps_redos_per_round := sleeps_retries_since_win_default
            num_wins += 1
            num_losses_consecutive := 0
            zenny_won += zenny_per_win
        } else if (gamble_result.number_of_wins_actual = num_rounds_to_win) {
            Loop gamble_result.number_of_wins_actual - 1 {
                sleeps_redos_per_round[A_Index] := sleeps_redos_per_round_win[A_Index]
            }
            num_wins += 1
            num_no_megaman_back += 1
            num_losses_consecutive := 0
        } else {
            Loop gamble_result.number_of_wins_actual {
                sleeps_redos_per_round[A_Index] := sleeps_redos_per_round_win[A_Index]
            }
            if (gamble_result.number_of_wins_actual < sleeps_redos_per_round.Length && sleeps_redos_per_round[gamble_result.number_of_wins_actual + 1] > 0) {
                sleeps_redos_per_round[gamble_result.number_of_wins_actual + 1] -= 1
            } else {
                sleeps_pre_gamble[gamble_result.number_of_wins_actual + 1] += sleeps_increment[gamble_result.number_of_wins_actual + 1]
                Loop num_rounds_to_win - (gamble_result.number_of_wins_actual + 1) {
                    sleeps_pre_gamble[A_Index + gamble_result.number_of_wins_actual + 1] := 0
                }
            }
            num_losses += 1
            num_losses_consecutive += 1
            if (num_losses_consecutive > fails_until_reset) {
                num_losses_consecutive := 0
                sleeps_pre_gamble := [0.0, 0.0, 0.0]
                sleeps_redos_per_round := sleeps_retries_since_win_default
                num_resets += 1
                Sleep(reset_sleep)
                SaveProgress()
            }
        }
        num_runs += 1

        gambler_summary := Map(
            "gamble_win", gamble_result.gamble_win,
            "fails_until_reset", fails_until_reset,
            "sleeps_increment", Join(sleeps_increment, " "),
            "sleeps_pre_gamble", Join(sleeps_pre_gamble, " "),
            "sleeps_redos_per_round", Join(sleeps_redos_per_round, " "),
            "num_losses", num_losses,
            "num_losses_consecutive", num_losses_consecutive,
            "num_no_megaman_back", num_no_megaman_back,
            "num_resets", num_resets,
            "num_rounds_to_win", num_rounds_to_win,
            "num_runs", num_runs,
            "num_wins", num_wins,
            "zenny_gambler_base", zenny_gambler_base,
            "zenny_per_win", zenny_per_win,
            "zenny_to_gain", zenny_to_gain,
            "zenny_won", zenny_won,
        )
        tool_tip_cfg_gambler.DisplayMsg(MapToStr(gambler_summary), w_win, h_win)

        if (zenny_to_gain != "" && zenny_won >= zenny_to_gain) {
            break
        }
    }
}

ratio_rgbs_gambler_success_win_round := RatioRgbs([0.249479], [0.349074], [0x0648a4])
