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

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

bugfrags_max := 9999
max_num_chips := 99
zenny_max := 999999
zenny_per_chip := 100
zenny_per_gamble_win := 64000

bugfrags_gain_stop := 9999 ;; max 9999
chip_min_thresh := 10
chip_trader_type := "dnn" ;; higbys, hospital, or dnn
find_chip_start_index := 118 ; max value of guard * is #133; NOTE: index is less if missing chips
num_battles_check_text := 20
num_battles_max := ""
num_battles_per_save := 50
health_heal_ratio := 0.7
start_battle_chip_state := ChooseStartBattleChipState("team")
zenny_gain_start := 500000
zenny_gain_stop := 999999
zenny_per_bugfrag_battle := 30

max_chips_per_chip_orders := max_num_chips - chip_min_thresh
zenny_per_chip_orders := zenny_per_chip * max_chips_per_chip_orders

tool_tip_cfg_trader := ToolTipCfg("dl", 1)
tool_tip_cfg_battle := ToolTipCfg("ur", 2)
tool_tip_cfg_gambler := ToolTipCfg("dr", 3)
tool_tip_cfg_summary := ToolTipCfg("ul", 4)

bugfrags_gained_battle := 0
duration_battle := 0
duration_chip_order := 0
duration_chip_trader := 0
duration_gambler := 0
duration_travel := 0
duration_total := 0
highest_chip_count := chip_min_thresh
find_chip_actual_index := find_chip_start_index
total_battles := 0
total_chips_ordered := 0
total_gamble_runs := 0
total_gamble_wins := 0
total_fails_enter_trader := 0
total_trader_in := 0
total_trader_out := 0
total_zenny_spent := 0
zenny_gained_battle := 0
zenny_gained_gambler := 0

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

if (chip_trader_type = "higbys") {
    chips_per_trade := 3
    travel_chip_trader_to_higsbys_at_higsbys_chip_shop := TravelHigsbysAtHigsbysChipTraderToHigsbysAtHigsbysChipShop
    travel_chip_trader_to_vending_comp_at_gambler := TravelHigsbysAtHigsbysChipTraderToVendingCompAtGambler
    travel_chip_trader_to_armor_comp := TravelHigsbysAtHigsbysChipTraderToArmorComp
    travel_higsbys_at_higsbys_chip_shop_to_chip_trader := TravelHigsbysAtHigsbysChipShopToHigsbysAtHigsbysChipTrader
} else if (chip_trader_type = "hospital") {
    chips_per_trade := 10
    travel_chip_trader_to_higsbys_at_higsbys_chip_shop := TravelHospLobbyAtChipTraderToHigsbysAtHigsbysChipShop
    travel_chip_trader_to_vending_comp_at_gambler := TravelHospLobbyAtChipTraderToVendingCompAtGambler
    travel_chip_trader_to_armor_comp := TravelHospLobbyAtChipTraderToArmorComp
    travel_higsbys_at_higsbys_chip_shop_to_chip_trader := TravelHigsbysAtHigsbysChipShopToHospLobbyAtChipTrader
} else if (chip_trader_type = "dnn") {
    chips_per_trade := 10
    travel_chip_trader_to_higsbys_at_higsbys_chip_shop := TravelTVStnHallAtChipTraderToHigsbysAtHigsbysChipShop
    travel_chip_trader_to_vending_comp_at_gambler := TravelTVStnHallAtChipTraderToVendingCompAtGambler
    travel_chip_trader_to_armor_comp := TravelTVStnHallAtChipTraderToArmorComp
    travel_higsbys_at_higsbys_chip_shop_to_chip_trader := TravelHigsbysAtHigsbysChipShopToTVStnHallAtChipTrader
} else {
    MsgBox("FATAL: unexpected chip_trader_type=" . chip_trader_type)
    ExitApp(1)
}

while (true) {
    timed_trade_summary := TimedCallTruncatedWReturn(
        "S",
        Mmbn3TradeUntilMinChipThresh,
        w_win,
        h_win,
        chip_min_thresh,
        chips_per_trade,
        tool_tip_cfg_trader,
    )
    duration_chip_trader += timed_trade_summary["duration"]
    total_trader_in += timed_trade_summary["ret_val"]["trader_in"]
    total_trader_out += timed_trade_summary["ret_val"]["trader_out"]
    total_fails_enter_trader += timed_trade_summary["ret_val"]["num_fails_enter_trader"]
    highest_chip_count := timed_trade_summary["ret_val"]["highest_chip_count"]

    pet_text := GetPetText(w_win, h_win, ["bugfrags", "zenny"])
    bugfrags_zenny_start := Max(zenny_max - ((bugfrags_gain_stop - pet_text["bugfrags"]) * zenny_per_bugfrag_battle), 0)
    if (pet_text["bugfrags"] < bugfrags_gain_stop && pet_text["zenny"] < bugfrags_zenny_start) {
        duration_travel += TimedCallTruncated("S", travel_chip_trader_to_armor_comp)
        timed_battle_summary := TimedCallTruncatedWReturn(
            "S",
            BattleLoop,
            w_win,
            h_win,
            ExecuteArmorCompBattleIfDetected,
            start_battle_chip_state,
            num_battles_per_save,
            health_heal_ratio,
            num_battles_max,
            num_battles_check_text,
            bugfrags_gain_stop,
            zenny_gain_stop,
            tool_tip_cfg_battle
        )
        duration_battle += timed_battle_summary["duration"]
        total_battles += timed_battle_summary["ret_val"]["battles"]
        bugfrags_gained_battle += timed_battle_summary["ret_val"]["bugfrags_gained"]
        zenny_gained_battle += timed_battle_summary["ret_val"]["zenny_gained"]
        duration_travel += TimedCallTruncated("S", TravelArmorCompToHigsbysAtHigsbysChipShop)
    } else if (pet_text["zenny"] < Min(zenny_gain_start + zenny_per_chip_orders, zenny_max)) {
        zenny_non_wasteful_gamble_limit := zenny_max - Mod((zenny_max - pet_text["zenny"]), zenny_per_gamble_win)
        zenny_to_gamble_for := Min(zenny_gain_stop - pet_text["zenny"], zenny_non_wasteful_gamble_limit - pet_text["zenny"])
        if (zenny_to_gamble_for > 0) {
            duration_travel += TimedCallTruncated("S", travel_chip_trader_to_vending_comp_at_gambler, w_win, h_win)
            timed_gambler_summary := TimedCallTruncatedWReturn("S", GamblerLoop, w_win, h_win, zenny_to_gamble_for, tool_tip_cfg_gambler)
            duration_gambler += timed_gambler_summary["duration"]
            total_gamble_runs += timed_gambler_summary["ret_val"]["num_runs"]
            total_gamble_wins += timed_gambler_summary["ret_val"]["num_wins"]
            zenny_gained_gambler += timed_gambler_summary["ret_val"]["zenny_won"]
            duration_travel += TimedCallTruncated("S", TravelVendingCompAtGamblerToHigsbysAtHigsbysChipShop)
        } else {
            duration_travel += TimedCallTruncated("S", travel_chip_trader_to_higsbys_at_higsbys_chip_shop)
        }
    } else {
        duration_travel += TimedCallTruncated("S", travel_chip_trader_to_higsbys_at_higsbys_chip_shop)
    }

    chips_per_chip_order := Min(max_chips_per_chip_orders, max_num_chips - highest_chip_count)
    zenny_per_chip_orders := zenny_per_chip * chips_per_chip_order
    timed_chip_order_summary := TimedCallTruncatedWReturn("S", Mmbn3ChipOrderGuardLoop, w_win, h_win, find_chip_actual_index, chips_per_chip_order)
    duration_chip_order += timed_chip_order_summary["duration"]
    find_chip_actual_index := timed_chip_order_summary["ret_val"]["find_chip_actual_index"]

    total_chips_ordered += chips_per_chip_order
    total_zenny_spent += zenny_per_chip_orders
    main_summary := Map(
        "bugfrags", pet_text["bugfrags"],
        "bugfrags_gained_battle", bugfrags_gained_battle,
        "bugfrags_gain_stop", bugfrags_gain_stop,
        "bugfrags_zenny_start", bugfrags_zenny_start,
        "chips_per_chip_order", chips_per_chip_order,
        "find_chip_actual_index", find_chip_actual_index,
        "find_chip_start_index", find_chip_start_index,
        "duration_battle", duration_battle,
        "duration_chip_order", duration_chip_order,
        "duration_chip_trader", duration_chip_trader,
        "duration_gambler", duration_gambler,
        "duration_travel", duration_travel,
        "total_battles", total_battles,
        "total_chips_ordered", total_chips_ordered,
        "total_gamble_runs", total_gamble_runs,
        "total_gamble_wins", total_gamble_wins,
        "total_fails_enter_trader", total_fails_enter_trader,
        "total_trader_in", total_trader_in,
        "total_trader_out", total_trader_out,
        "total_zenny_spent", total_zenny_spent,
        "zenny", pet_text["zenny"],
        "zenny_gain_start", zenny_gain_start,
        "zenny_gain_stop", zenny_gain_stop,
        "zenny_gained_battle", zenny_gained_battle,
        "zenny_gained_gambler", zenny_gained_gambler,
        "zenny_per_bugfrag_battle", zenny_per_bugfrag_battle,
        "zenny_per_chip_orders", zenny_per_chip_orders,
    )
    tool_tip_cfg_summary.DisplayMsg(MapToStr(main_summary), w_win, h_win)

    duration_travel += TimedCallTruncated("S", travel_higsbys_at_higsbys_chip_shop_to_chip_trader)
}

$Esc:: {
    ClearHeldKeysE("w a s d j k e enter")
    ExitApp
}
