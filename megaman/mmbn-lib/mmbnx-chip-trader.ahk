#include "%A_ScriptDir%\mmbn-lib\mmbnx-ratio-rgbs.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-text.ahk"

#include <geometry-utils>
#include <keypress-utils>
#include <string-utils>
#include <tool-tip-utils>
#include <window-utils>

Mmbn3InitializeChipTrader() {
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1000)
}

Mmbn3EnterInsertChipsMenuChipTrader() {
    ;; click 'Insert X BtlChips?' or 'Try Again?'
    HoldKeyE("j", 50)
    Sleep(600)
}

Mmbn3InsertChipsChipTrader(chips_per_trade) {
    ;; insert chips
    Loop chips_per_trade {
        HoldKeyE("j", 50)
        Sleep(70)
    }
    Sleep(500)
    ;; confirm trade
    HoldKeyE("j", 50)
    Sleep(1300)
    ;; speed up text
    HoldKeyE("j", 50)
    Sleep(200)
    ;; display chip
    HoldKeyE("j", 50)
    Sleep(200)
    ;; speed up text
    HoldKeyE("j", 50)
    Sleep(1200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(400)
}

Mmbn3TradeUntilMinChipThresh(w_win, h_win, chip_trader_type, chip_min_thresh, tool_tip_cfg := ToolTipCfg(), check_only_top_chip := true, num_enter_trader_attempts := 3) {
    if (chip_trader_type = "higsbys") {
        chips_per_trade := 3
    } else if (chip_trader_type = "hospital" || chip_trader_type = "dnn") {
        chips_per_trade := 10
    } else {
        MsgBox("FATAL: unexpected chip_trader_type=" . chip_trader_type)
        ExitApp(1)
    }

    trader_in := 0
    trader_out := 0
    num_fails_enter_trader := 0
    Mmbn3InitializeChipTrader()
    while (true) {
        Loop num_enter_trader_attempts {
            Mmbn3EnterInsertChipsMenuChipTrader()
            if (mmbn3_ratio_rgbs_chip_count_menu_blue.DoesWindowMatchRatioRgbs(w_win, h_win) ||
                mmbn3_ratio_rgbs_chip_count_menu_white.DoesWindowMatchRatioRgbs(w_win, h_win)) {
                break
            }
            num_fails_enter_trader += 1
            if (num_enter_trader_attempts = A_Index) {
                MsgBox("ERROR: expected to be in chip trader")
                ExitApp(1)
            }
            RepeatHoldKeyForDurationE("k", 50, 2500)
            Mmbn3InitializeChipTrader()
        }
        if (check_only_top_chip) {
            highest_chip_count := Integer(Join(mmbn3_digits_chip_count.GetCharsRow(1, w_win, h_win)))
            trader_summary := Map(
                "chip_min_thresh", chip_min_thresh,
                "chips_per_trade", chips_per_trade,
                "highest_chip_count", highest_chip_count,
                "num_fails_enter_trader", num_fails_enter_trader,
                "trader_in", trader_in,
                "trader_out", trader_out,
            )
            tool_tip_cfg.DisplayMsg(MapToStr(trader_summary), w_win, h_win)
        } else {
            digits_2d := mmbn3_digits_chip_count.GetChars2D(w_win, h_win)
            highest_chip_count := Integer(Join(digits_2d[1]))
            trader_summary := Map(
                "chip_min_thresh", chip_min_thresh,
                "chips_per_trade", chips_per_trade,
                "highest_chip_count", highest_chip_count,
                "num_fails_enter_trader", num_fails_enter_trader,
                "trader_in", trader_in,
                "trader_out", trader_out,
            )
            tool_tip_cfg.DisplayMsg(MapToStr(trader_summary) .
                JoinN(digits_2d, 2, ["", "`n"]), w_win, h_win)
        }
        if (highest_chip_count < chip_min_thresh + chips_per_trade) {
            break
        }
        Mmbn3InsertChipsChipTrader(chips_per_trade)
        trader_in += chips_per_trade
        trader_out += 1
    }
    RepeatHoldKeyForDurationE("k", 50, 2500)

    return trader_summary
}

Mmbn3GetTraderType(w_win, h_win) {
    static ratio_rgbs_higsbys_at_chip_trader := RatioRgbs([0.591406, 0.842969], [0.467130, 0.868056], [0x005000, 0x005000])
    static ratio_rgbs_hosp_lobby_at_chip_trader := RatioRgbs([0.665104, 0.666667], [0.129167, 0.267130], [0xffffe8, 0xffffe8])
    static ratio_rgbs_tv_stn_hall_at_chip_trader := RatioRgbs([0.429167, 0.545573], [0.074074, 0.070370], [0xb6b69b, 0xb6b69b])

    if (ratio_rgbs_higsbys_at_chip_trader.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        return "higsbys"
    } else if (ratio_rgbs_hosp_lobby_at_chip_trader.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        return "hospital"
    } else if (ratio_rgbs_tv_stn_hall_at_chip_trader.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        return "dnn"
    }

    MsgBox("ERROR: could not discern chip trader type")
    ExitApp(1)
}
