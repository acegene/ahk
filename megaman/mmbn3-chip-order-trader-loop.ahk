#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include "%A_ScriptDir%\mmbn-lib\mmbn3-armor-comp.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-gambler.ahk"
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

max_num_chips := 99
chips_per_trade := 10
zenny_per_chip := 100

find_chip_start_index := 118 ; max value of guard * is #133 NOTE: index is less if missing chips
num_battles_check_zenny := 20
num_battles_max := ""
num_battles_per_save := 50
start_battle_chip_state := { chip_slots_to_send: [1], num_chips_to_use: 0, post_chip_sleeps: [] }
zenny_gain_start_thresh := 936000
zenny_gain_method := "gamble"
zenny_use_stop_thresh := 999999
chip_min_thresh := 10

max_chips_per_chip_orders := max_num_chips - chip_min_thresh
zenny_per_chip_orders := zenny_per_chip * max_chips_per_chip_orders

tool_tip_cfg_trader := ToolTipCfg("dl", 1)
tool_tip_cfg_battle := ToolTipCfg("ur", 2)
tool_tip_cfg_gambler := ToolTipCfg("dr", 3)
tool_tip_cfg_summary := ToolTipCfg("ul", 4)

total_battles := 0
total_trader_in := 0
total_trader_out := 0
total_fails_enter_trader := 0
total_chips_ordered := 0
total_zenny_spent := 0
find_chip_index := ""
zenny := ""
highest_chip_count := chip_min_thresh

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

; TravelHigsbysAtHigsbysChipShopToHospLobbyAtChipTrader()
; TravelArmorCompToHospLobbyAtChipTrader()

while (true) {
    trade_summary := Mmbn3TradeUntilMinChipThresh(
        w_win,
        h_win,
        chip_min_thresh,
        chips_per_trade,
        tool_tip_cfg_trader
    )
    total_trader_in += trade_summary.trader_in
    total_trader_out += trade_summary.trader_out
    total_fails_enter_trader += trade_summary.num_fails_enter_trader
    highest_chip_count := trade_summary.highest_chip_count

    zenny := GetZenny(w_win, h_win)
    if (zenny <= zenny_gain_start_thresh + zenny_per_chip_orders) {
        if (zenny_gain_method = "gamble") {
            TravelHospLobbyAtChipTraderToVendingCompAtGambler(w_win, h_win)
            GamblerLoop(w_win, h_win, zenny_use_stop_thresh - zenny, tool_tip_cfg_gambler)
            TravelVendingCompAtGamblerToHospLobbyAtChipTrader()
        } else if (zenny_gain_method = "armor_comp") {
            TravelHospLobbyAtChipTraderToArmorComp()
            battle_summary := BattleLoop(
                w_win,
                h_win,
                ExecuteArmorCompBattleIfDetected,
                start_battle_chip_state,
                num_battles_per_save,
                num_battles_max,
                num_battles_check_zenny,
                zenny_use_stop_thresh,
                tool_tip_cfg_battle
            )
            total_battles += battle_summary.battles
            TravelArmorCompToHospLobbyAtChipTrader()
        } else {
            MsgBox("FATAL: unexpected zenny_gain_method=" . zenny_gain_method)
            ExitApp(1)
        }
    }

    TravelHospLobbyAtChipTraderToHigsbysAtHigsbysChipShop()

    chips_per_chip_order := Min(max_chips_per_chip_orders, max_num_chips - highest_chip_count)
    zenny_per_chip_orders := zenny_per_chip * chips_per_chip_order
    chip_order_summary := Mmbn3ChipOrderGuardLoop(find_chip_start_index, chips_per_chip_order)
    find_chip_index := chip_order_summary.find_chip_actual_index

    total_chips_ordered += chips_per_chip_order
    total_zenny_spent += zenny_per_chip_orders
    main_summary := Map(
        "chips_per_chip_order", chips_per_chip_order,
        "find_chip_start_index", find_chip_start_index,
        "find_chip_index", find_chip_index,
        "total_battles", total_battles,
        "total_chips_ordered", total_chips_ordered,
        "total_fails_enter_trader", total_fails_enter_trader,
        "total_trader_in", total_trader_in,
        "total_trader_out", total_trader_out,
        "total_zenny_spent", total_zenny_spent,
        "zenny", zenny,
        "zenny_gain_start_thresh", zenny_gain_start_thresh,
        "zenny_gain_method", zenny_gain_method,
        "zenny_per_chip_orders", zenny_per_chip_orders,
    )
    tool_tip_cfg_summary.DisplayMsg(MapToStr(main_summary), w_win, h_win)

    TravelHigsbysAtHigsbysChipShopToHospLobbyAtChipTrader()
}

$Esc:: {
    ClearHeldKeysE("w a s d j k e enter")
    ExitApp
}
