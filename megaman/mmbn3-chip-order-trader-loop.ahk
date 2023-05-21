#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include "%A_ScriptDir%\mmbn-lib\mmbn3-armor-comp.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-gambler.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-travel.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-battle.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-chip-order.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-chip-trader.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-pet.ahk"

#include <keypress-utils>
#include <string-utils>
#include <timer-utils>
#include <tool-tip-utils>
#include <window-utils>

/**
 * Prereqs
 *       * 99 guard chips are available in chip order (i.e. the chip trader has had 99 guard chips inserted)
 *           * see 'grind_guard_chips' in mmbn3-battle-grinder.ahk
 *       * higsby's chip order is available
 *       * desired chip trader is available
 * Usage
 *       * can start at any of three chip traders
 *           * higsbys: right of trader as up as possible while looking left
 *           * hospital: above trader as left as possible while looking down
 *           * dnn: left of trader as up as possible while looking right
 *       * set 'settable vars' below based on your preferences
 *       * exit script by pressing escape key
 */

CallChipTraderLoopAndPopulateSummary(&summary, w_win, h_win, chip_trader_type, chip_min_thresh, tool_tip_cfg_trader, max_chips_per_chip_orders, max_num_chips, zenny_per_chip) {
    timed_summary_trader := TimedCallTruncatedWReturn(
        "S",
        Mmbn3TradeUntilMinChipThresh,
        w_win,
        h_win,
        chip_trader_type,
        chip_min_thresh,
        tool_tip_cfg_trader,
    )

    summary["duration_chip_trader"] += timed_summary_trader["duration"]
    summary["total_trader_in"] += timed_summary_trader["ret_val"]["trader_in"]
    summary["total_trader_out"] += timed_summary_trader["ret_val"]["trader_out"]
    summary["total_fails_enter_trader"] += timed_summary_trader["ret_val"]["num_fails_enter_trader"]
    summary["chips_per_chip_order"] := Min(max_chips_per_chip_orders, max_num_chips - timed_summary_trader["ret_val"]["highest_chip_count"])
    summary["zenny_per_chip_orders"] := zenny_per_chip * summary["chips_per_chip_order"]
}

CallGamblerLoopAndPopulateSummary(&summary, w_win, h_win, zenny_to_gamble_for, tool_tip_cfg_gambler) {
    timed_summary_gambler := TimedCallTruncatedWReturn("S", GamblerLoop, w_win, h_win, zenny_to_gamble_for, tool_tip_cfg_gambler)

    summary["duration_gambler"] += timed_summary_gambler["duration"]
    summary["total_gamble_runs"] += timed_summary_gambler["ret_val"]["num_runs"]
    summary["total_gamble_wins"] += timed_summary_gambler["ret_val"]["num_wins"]
    summary["zenny_gained_gambler"] += timed_summary_gambler["ret_val"]["zenny_won"]
}

CallChipOrderLoopAndPopulateSummary(&summary, w_win, h_win, zenny_per_chip_orders) {
    timed_summary_chip_order := TimedCallTruncatedWReturn("S", Mmbn3ChipOrderGuards, w_win, h_win, main_summary["find_chip_actual_index"], main_summary["chips_per_chip_order"])

    main_summary["duration_chip_order"] += timed_summary_chip_order["duration"]
    main_summary["find_chip_actual_index"] := timed_summary_chip_order["ret_val"]["find_chip_actual_index"]

    main_summary["total_chips_ordered"] += main_summary["chips_per_chip_order"]
    main_summary["total_zenny_spent"] += zenny_per_chip_orders
}

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

;; settable vars
chip_min_thresh := 10
find_chip_start_index := 50 ; max value of guard * is #133; NOTE: index must be less than 1 + 'num down presses necessary to select guard'
zenny_gain_start := 500000
zenny_gain_stop := 999999

;; hardcoded vars
max_num_chips := 99
tool_tip_cfg_gambler := ToolTipCfg("ur", 2)
tool_tip_cfg_summary := ToolTipCfg("ul", 1)
tool_tip_cfg_trader := ToolTipCfg("dl", 3)
zenny_max := 999999
zenny_per_chip := 100
zenny_per_gamble_win := 64000

;; derived vars
max_chips_per_chip_orders := max_num_chips - chip_min_thresh
zenny_per_chip_orders := zenny_per_chip * max_chips_per_chip_orders

main_summary := Map(
    "chips_per_chip_order", zenny_per_chip * max_chips_per_chip_orders,
    "find_chip_actual_index", find_chip_start_index,
    "find_chip_start_index", find_chip_start_index,
    "duration_chip_order", 0,
    "duration_chip_trader", 0,
    "duration_gambler", 0,
    "duration_travel", 0,
    "total_chips_ordered", 0,
    "total_gamble_runs", 0,
    "total_gamble_wins", 0,
    "total_fails_enter_trader", 0,
    "total_trader_in", 0,
    "total_trader_out", 0,
    "total_zenny_spent", 0,
    "zenny", 0,
    "zenny_gain_start", zenny_gain_start,
    "zenny_gain_stop", zenny_gain_stop,
    "zenny_gained_gambler", 0,
    "zenny_per_chip_orders", zenny_per_chip * max_chips_per_chip_orders,
)

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

chip_trader_type := Mmbn3GetTraderType(w_win, h_win)

if (chip_trader_type = "higsbys") {
    travel_chip_trader_to_higsbys_at_chip_shop := TravelHigsbysAtTraderToHigsbysAtShop
    travel_chip_trader_to_vending_comp_at_gambler := TravelHigsbysAtTraderToVendingCompAtGambler
    travel_higsbys_at_chip_shop_to_chip_trader := TravelHigsbysAtShopToHigsbysAtTrader
} else if (chip_trader_type = "hospital") {
    travel_chip_trader_to_higsbys_at_chip_shop := TravelHospLobbyAtTraderToHigsbysAtShop
    travel_chip_trader_to_vending_comp_at_gambler := TravelHospLobbyAtTraderToVendingCompAtGambler
    travel_higsbys_at_chip_shop_to_chip_trader := TravelHigsbysAtShopToHospLobbyAtTrader
} else if (chip_trader_type = "dnn") {
    travel_chip_trader_to_higsbys_at_chip_shop := TravelTVStnHallAtTraderToHigsbysAtShop
    travel_chip_trader_to_vending_comp_at_gambler := TravelTVStnHallAtTraderToVendingCompAtGambler
    travel_higsbys_at_chip_shop_to_chip_trader := TravelHigsbysAtShopToTVStnHallAtTrader
} else {
    MsgBox("ERROR: unexpected chip_trader_type=" . chip_trader_type)
    ExitApp(1)
}

while (true) {
    CallChipTraderLoopAndPopulateSummary(&main_summary, w_win, h_win, chip_trader_type, chip_min_thresh, tool_tip_cfg_trader, max_chips_per_chip_orders, max_num_chips, zenny_per_chip)

    main_summary["zenny"] := Mmbn3GetPetText(w_win, h_win, ["zenny"])["zenny"]
    if (main_summary["zenny"] < Min(zenny_gain_start + zenny_per_chip_orders, zenny_max)) {
        zenny_non_wasteful_gamble_limit := zenny_max - Mod((zenny_max - main_summary["zenny"]), zenny_per_gamble_win)
        zenny_to_gamble_for := Min(zenny_gain_stop - main_summary["zenny"], zenny_non_wasteful_gamble_limit - main_summary["zenny"])
        if (zenny_to_gamble_for > 0) {
            main_summary["duration_travel"] += TimedCallTruncated("S", travel_chip_trader_to_vending_comp_at_gambler, w_win, h_win)
            CallGamblerLoopAndPopulateSummary(&main_summary, w_win, h_win, zenny_to_gamble_for, tool_tip_cfg_gambler)
            main_summary["duration_travel"] += TimedCallTruncated("S", TravelVendingCompAtGamblerToHigsbysAtShop)
        } else {
            main_summary["duration_travel"] += TimedCallTruncated("S", travel_chip_trader_to_higsbys_at_chip_shop)
        }
    } else {
        main_summary["duration_travel"] += TimedCallTruncated("S", travel_chip_trader_to_higsbys_at_chip_shop)
    }

    CallChipOrderLoopAndPopulateSummary(&main_summary, w_win, h_win, zenny_per_chip_orders)
    main_summary["duration_travel"] += TimedCallTruncated("S", travel_higsbys_at_chip_shop_to_chip_trader)

    tool_tip_cfg_summary.DisplayMsg(MapToStr(main_summary), w_win, h_win)
}

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
