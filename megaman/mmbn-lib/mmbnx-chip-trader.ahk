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

Mmbn3TradeUntilMinChipThresh(w_win, h_win, chip_min_thresh, chips_per_trade, tool_tip_cfg := ToolTipCfg(), check_only_top_chip := true, num_enter_trader_attempts := 3) {
    trader_in := 0
    trader_out := 0
    num_fails_enter_trader := 0
    Mmbn3InitializeChipTrader()
    while (true) {
        Loop num_enter_trader_attempts {
            Mmbn3EnterInsertChipsMenuChipTrader()
            if (mmbn3_ratio_rgb_chip_trader_insert_menu_blue.DoesWindowMatchRatioRgbs(w_win, h_win) ||
                mmbn3_ratio_rgb_chip_trader_insert_menu_white.DoesWindowMatchRatioRgbs(w_win, h_win)) {
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
            highest_chip_count := Integer(Join(mmbn3_digits_chip_trader.GetCharsRow(1, w_win, h_win)))
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
            digits_2d := mmbn3_digits_chip_trader.GetChars2D(w_win, h_win)
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

mmbn3_x_ratio_l_chip_trader_digit_1_edge := 0.528646
mmbn3_x_ratio_r_chip_trader_digit_1_edge := 0.546615
mmbn3_x_ratio_l_chip_trader_digit_2_edge := 0.553646
;; mmbn3_x_ratio_r_chip_trader_digit_2_edge := 0.571615
mmbn3_y_ratio_u_chip_trader_chip_1_edge := 0.248611
mmbn3_y_ratio_d_chip_trader_chip_1_edge := 0.304167

mmbn3_y_ratio_u_chip_trader_chip_7_edge := 0.781944

mmbn3_rgb_chip_trader_chip_count := 0xf2fcfc
mmbn3_chip_trader_num_rows := 7
mmbn3_chip_trader_num_columns := 2

mmbn3_digits_chip_trader := CharGridColorChecker(
    mmbn3_x_ratio_l_chip_trader_digit_1_edge,
    mmbn3_y_ratio_u_chip_trader_chip_1_edge,
    mmbn3_x_ratio_r_chip_trader_digit_1_edge - mmbn3_x_ratio_l_chip_trader_digit_1_edge,
    mmbn3_y_ratio_d_chip_trader_chip_1_edge - mmbn3_y_ratio_u_chip_trader_chip_1_edge,
    (mmbn3_y_ratio_u_chip_trader_chip_7_edge - mmbn3_y_ratio_u_chip_trader_chip_1_edge) / 6.0,
    mmbn3_x_ratio_l_chip_trader_digit_2_edge - mmbn3_x_ratio_l_chip_trader_digit_1_edge,
    mmbn3_chip_trader_num_rows,
    mmbn3_chip_trader_num_columns,
    mmbn3_digit_check_ratios,
    mmbn3_digit_check_map,
    mmbn3_rgb_chip_trader_chip_count,
)
