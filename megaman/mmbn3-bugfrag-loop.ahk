#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include "%A_ScriptDir%\mmbn-lib\mmbn3-simon.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-travel.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-bugfrag-trader.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-chip-trader.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-pet.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-ratio-rgbs.ahk"

#include <keypress-utils>

;; TODO: trade chips

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

initial_bugfrags_to_trader := 6000
max_bugfrags := 9999
chip_trader_start := 99
chip_trader_type := "dnn"

tool_tip_summary := ToolTipCfg("ul", 1)
tool_tip_simon := ToolTipCfg("ur", 2)
tool_tip_bugfrag_trader := ToolTipCfg("dl", 3)

summary_bugfrag_loop := Map(
    "bugfrags", 0,
    "bugfrags_gained", 0,
    "bugfrags_traded", 0,
    "chips_gained", 0,
    "duration_simon", 0,
    "duration_total", 0,
    "duration_trader", 0,
    "duration_travel_simon_to_trader", 0,
    "duration_travel_trader_to_simon", 0,
    "duration_travel_tamako_to_simon", 0,
    "duration_travel_tamako_to_trader", 0,
)

CallBugFragTraderAndPopulateSummary(&summary, w_win, h_win, bugfrags_to_trade, tool_tip_bugfrag_trader) {
    timed_summary_trader := TimedCallTruncatedWReturn("S", Mmbn3TradeNBugfragsWInitiate, w_win, h_win, bugfrags_to_trade, tool_tip_bugfrag_trader)

    summary["duration_trader"] += timed_summary_trader["duration"]
    summary["bugfrags_traded"] += timed_summary_trader["ret_val"]["bugfrags_traded"]
    summary["chips_gained"] += timed_summary_trader["ret_val"]["chips_gained"]
}

CallSimonAndPopulateSummary(&summary, w_win, h_win, max_bugfrags, tool_tip_simon) {
    summary_bugfrag_loop["bugfrags"] := GetPetText(w_win, h_win, ["bugfrags"])["bugfrags"]
    bugfrags_to_win := max_bugfrags - summary_bugfrag_loop["bugfrags"]
    timed_summary_simon := TimedCallTruncatedWReturn("S", SimonGameGrinder, w_win, h_win, bugfrags_to_win, tool_tip_simon)

    summary_bugfrag_loop["duration_simon"] += timed_summary_simon["duration"]
    summary_bugfrag_loop["bugfrags_gained"] += timed_summary_simon["ret_val"]["bugfrags_won"]
}

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

if (mmbn3_ratio_rgbs_bugfrag_trader.DoesWindowMatchRatioRgbs(w_win, h_win)) {
    summary_bugfrag_loop["bugfrags"] := GetPetText(w_win, h_win, ["bugfrags"])["bugfrags"]
    CallBugFragTraderAndPopulateSummary(&summary_bugfrag_loop, w_win, h_win, summary_bugfrag_loop["bugfrags"], tool_tip_bugfrag_trader)
    summary_bugfrag_loop["duration_travel_trader_to_simon"] += TimedCallTruncated("S", TravelSecretArea3AtTraderToUnderSquareAtSimon, w_win, h_win)
}
else if (mmbn3_ratio_rgbs_hotel_lobby_at_tamakos_pc.DoesWindowMatchRatioRgbs(w_win, h_win)) {
    summary_bugfrag_loop["bugfrags"] := GetPetText(w_win, h_win, ["bugfrags"])["bugfrags"]
    if (summary_bugfrag_loop["bugfrags"] > initial_bugfrags_to_trader) {
        summary_bugfrag_loop["duration_travel_tamako_to_trader"] += TimedCallTruncated("S", TravelHotelFrontAtTamakosHPToSecretArea3AtTrader, w_win, h_win)
        CallBugFragTraderAndPopulateSummary(&summary_bugfrag_loop, w_win, h_win, summary_bugfrag_loop["bugfrags"], tool_tip_bugfrag_trader)
        summary_bugfrag_loop["duration_travel_trader_to_simon"] += TimedCallTruncated("S", TravelSecretArea3AtTraderToUnderSquareAtSimon, w_win, h_win)
    } else {
        summary_bugfrag_loop["duration_travel_tamako_to_simon"] += TimedCallTruncated("S", TravelHotelFrontAtTamakosHPToUnderSquareAtSimon)
    }
} else if (mmbn3_ratio_rgbs_simon.DoesWindowMatchRatioRgbs(w_win, h_win)) {
    Sleep(0) ;; do nothing
} else {
    MsgBox("ERROR: unsupported location. try one of the following locations:" .
        "`n             - left upper corner of tamako's hp (jacked out)" .
        "`n             - right upper corner of bugfrag trader" .
        "`n             - above simon minigame character in Under Square"
    )
}

while (true) {
    CallSimonAndPopulateSummary(&summary_bugfrag_loop, w_win, h_win, max_bugfrags, tool_tip_simon)
    summary_bugfrag_loop["duration_travel_simon_to_trader"] += TimedCallTruncated("S", TravelUnderSquareAtSimonToSecretArea3AtTrader, w_win, h_win)

    CallBugFragTraderAndPopulateSummary(&summary_bugfrag_loop, w_win, h_win, max_bugfrags, tool_tip_bugfrag_trader)
    summary_bugfrag_loop["duration_travel_trader_to_simon"] += TimedCallTruncated("S", TravelSecretArea3AtTraderToUnderSquareAtSimon, w_win, h_win)

    tool_tip_summary.DisplayMsg(MapToStr(summary_bugfrag_loop), w_win, h_win)
}

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
