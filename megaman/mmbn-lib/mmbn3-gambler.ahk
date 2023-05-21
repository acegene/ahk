#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-ratio-rgbs.ahk"

#include <keypress-utils>
#include <string-utils>
#include <timer-utils>
#include <window-utils>

InitiateGambler() {
    HoldKeyE("j", 50)
    Sleep(100)
    SendEvent("{k down}")
    Sleep(700)
    HoldKeyE("j", 50)
    Sleep(700)
}

Gamble(w_win, h_win, number_of_wins, round_sleeps) {
    number_of_wins_actual := 0
    Loop number_of_wins {
        Sleep(round_sleeps[A_Index])
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
        is_success := mmbn3_ratio_rgbs_gambler_success_win_round.DoesWindowMatchRatioRgbs(w_win, h_win)
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
    if (mmbn3_ratio_rgbs_megaman_back.DoesWindowMatchRatioRgbs(w_win, h_win)) {
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
    timer_gambler := Timer()

    num_rounds_to_win := 3 ;; 4 times bankrupts gambler
    zenny_gambler_base := 1000
    fails_until_reset := 25
    reset_sleep := 5000
    round_sleeps := [0, 0, 0]
    round_sleeps_redos_win := [2, 2]
    sleep_increments := [100, 100, 100]

    round_sleeps_redos_default := [0, 0]
    round_sleeps_redos := round_sleeps_redos_default
    zenny_per_win := (4 ** num_rounds_to_win) * zenny_gambler_base

    duration_cycle := 0
    duration_total := 0
    gamble_win := false
    num_losses := 0
    num_losses_consecutive := 0
    num_no_megaman_back := 0
    num_resets := 0
    num_runs := 0
    num_wins := 0
    zenny_won := 0

    SaveProgress()
    ResetGame()
    duration_startup := timer_gambler.ElapsedSecTruncated()
    duration_total += duration_startup
    while (true) {
        timer_gambler.Reset()
        InitiateGambler()
        gamble_result := Gamble(w_win, h_win, num_rounds_to_win, round_sleeps)

        if (gamble_result.gamble_win) {
            round_sleeps := [0, 0, 0]
            round_sleeps_redos := round_sleeps_redos_default
            num_wins += 1
            num_losses_consecutive := 0
            zenny_won += zenny_per_win
        } else if (gamble_result.number_of_wins_actual = num_rounds_to_win) {
            round_sleeps_redos := round_sleeps_redos_default
            num_wins += 1
            num_no_megaman_back += 1
            num_losses_consecutive := 0
        } else {
            Loop gamble_result.number_of_wins_actual {
                round_sleeps_redos[A_Index] := round_sleeps_redos_win[A_Index]
            }
            if (gamble_result.number_of_wins_actual < round_sleeps_redos.Length && round_sleeps_redos[gamble_result.number_of_wins_actual + 1] > 0) {
                round_sleeps_redos[gamble_result.number_of_wins_actual + 1] -= 1
            } else {
                round_sleeps[gamble_result.number_of_wins_actual + 1] += sleep_increments[gamble_result.number_of_wins_actual + 1]
                Loop num_rounds_to_win - (gamble_result.number_of_wins_actual + 1) {
                    round_sleeps[A_Index + gamble_result.number_of_wins_actual + 1] := 0
                }
                Loop Max(num_rounds_to_win - (gamble_result.number_of_wins_actual + 2), 0) {
                    round_sleeps_redos[A_Index + gamble_result.number_of_wins_actual + 1] := 0
                }
            }
            num_losses += 1
            num_losses_consecutive += 1
            if (num_losses_consecutive >= fails_until_reset) {
                num_losses_consecutive := 0
                round_sleeps := [0, 0, 0]
                round_sleeps_redos := round_sleeps_redos_default
                num_resets += 1
                Sleep(reset_sleep)
                SaveProgress()
                ResetGame()
            }
        }
        num_runs += 1

        duration_cycle := timer_gambler.ElapsedSecTruncated()
        duration_total += duration_cycle
        gambler_summary := Map(
            "gamble_win", gamble_result.gamble_win,
            "duration_cycle", duration_cycle,
            "duration_startup", duration_startup,
            "duration_total", duration_total,
            "fails_until_reset", fails_until_reset,
            "sleep_increments", Join(sleep_increments, " "),
            "round_sleeps", Join(round_sleeps, " "),
            "round_sleeps_redos", Join(round_sleeps_redos, " "),
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
            return gambler_summary
        }
    }
}
