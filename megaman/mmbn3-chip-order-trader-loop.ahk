#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include "%A_ScriptDir%\mmbn-lib\mmbn3-armor-comp.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-travel.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-battle.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-chip-order.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-chip-trader.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-pet.ahk"

#include <keypress-utils>
#include <string-utils>
#include <tool-tip-utils>
#include <window-utils>

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

start_battle_chip_state := { chip_slots_to_send: [1], num_chips_to_use: 0, post_chip_sleeps: [] }
max_num_chips := 99

num_battles_check_zenny := 20
num_battles_per_save := 50
num_battles_max := ""

total_battles := 0

total_trader_in := 0
total_trader_out := 0
total_fails_enter_trader := 0

total_chips_ordered := 0
total_zenny_spent := 0

find_chip_start_index := 90 ; guard *
find_chip_index := "NULL"
chip_min_thresh := 10
chips_per_trade := 10
max_chips_per_chip_orders := max_num_chips - chip_min_thresh
zenny_battle_start_thresh := 500000
zenny_battle_stop_thresh := 999999
zenny := "NULL"
zenny_per_chip := 100
zenny_per_chip_orders := zenny_per_chip * max_chips_per_chip_orders
highest_chip_count := chip_min_thresh

tool_tip_cfg_trader := ToolTipCfg("dl", 1)
tool_tip_cfg_battle := ToolTipCfg("ur", 2)
tool_tip_cfg_summary := ToolTipCfg("ul", 3)

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

; TravelHigsbysAtHigsbysChipShopToHospLobbyAtChipTrader()
; TravelArmorCompToHospLobbyAtChipTrader()

while (True) {
    trade_summary := Mmbn3TradeUntilMinChipThresh(w_win, h_win, chip_min_thresh, chips_per_trade, tool_tip_cfg_trader)
    total_trader_in += trade_summary.trader_in
    total_trader_out += trade_summary.trader_out
    total_fails_enter_trader += trade_summary.num_fails_enter_trader
    highest_chip_count := trade_summary.highest_chip_count

    zenny := GetZenny(w_win, h_win)
    if (zenny <= zenny_battle_start_thresh + zenny_per_chip_orders) {
        TravelHospLobbyAtChipTraderToArmorComp()
        BattleLoop(w_win, h_win, ExecuteArmorCompBattleIfDetected, start_battle_chip_state, num_battles_per_save, num_battles_max, num_battles_check_zenny, zenny_battle_stop_thresh, tool_tip_cfg_battle)
        TravelArmorCompToHospLobbyAtChipTrader()
    }

    TravelHospLobbyAtChipTraderToHigsbysAtHigsbysChipShop()

    chips_per_chip_orders := Min(max_chips_per_chip_orders, max_num_chips - highest_chip_count)
    zenny_per_chip_orders := zenny_per_chip * chips_per_chip_orders
    chip_order_summary := Mmbn3ChipOrderGuardLoop(find_chip_start_index, chips_per_chip_orders)
    find_chip_index := chip_order_summary.find_chip_actual_index

    total_chips_ordered += chips_per_chip_orders
    total_zenny_spent += zenny_per_chip_orders
    summary_map := Map(
        "chips_per_chip_orders", chips_per_chip_orders,
        "find_chip_index", find_chip_index,
        "find_chip_start_index", find_chip_start_index,
        "total_battles", total_battles,
        "total_chips_ordered", total_chips_ordered,
        "total_fails_enter_trader", total_fails_enter_trader,
        "total_trader_in", total_trader_in,
        "total_trader_out", total_trader_out,
        "total_zenny_spent", total_zenny_spent,
        "zenny", zenny,
        "zenny_battle_start_thresh", zenny_battle_start_thresh,
        "zenny_per_chip_orders", zenny_per_chip_orders,
    )
    tool_tip_cfg_summary.DisplayMsg(MapToStr(summary_map), w_win, h_win)

    TravelHigsbysAtHigsbysChipShopToHospLobbyAtChipTrader()
}

Esc:: {
    ClearHeldKeysE("w a s d j k e enter")
    ExitApp
}
