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

/**
 * A loop between gaining bugfrags from the simon minigame then using the bugfrag trader
 *
 * prereqs
 *   * path to SecretArea3 bugfrag trader is unblocked
 *   * for sneakrun to work in undernet 1-3, must have 720 Total HP without navicust modifications
 * usage
 *   * can start at following locations:
 *       * right of bugfrag trader as up as possible while looking left
 *       * left of tamako's HP while as up as possible while looking right
 *       * above simon says minigame navi in Under Square
 *   * sneakrun navicust program must be equipped
 *   * set 'settable vars' below based on your preferences
 *   * exit script by pressing escape key
 */

CallBugFragTraderAndPopulateSummary(&summary, w_win, h_win, bugfrags_to_trade, tool_tip_bugfrag_trader) {
    timed_summary_trader := TimedCallTruncatedWReturn("S", Mmbn3TradeNBugfragsWInitiate, w_win, h_win, bugfrags_to_trade, tool_tip_bugfrag_trader)

    summary["duration_bugfrag_trader"] += timed_summary_trader["duration"]
    summary["bugfrags_traded"] += timed_summary_trader["ret_val"]["bugfrags_traded"]
    summary["chips_gained"] += timed_summary_trader["ret_val"]["chips_gained"]
}

CallChipTraderAndPopulateSummary(&summary, w_win, h_win, chip_trader_type, chip_min_thresh, tool_tip_chip_trader) {
    timed_summary_chip_trader := TimedCallTruncatedWReturn("S", Mmbn3TradeUntilMinChipThresh, w_win, h_win, chip_trader_type, chip_min_thresh, tool_tip_chip_trader)

    summary["chip_trader_in"] += timed_summary_chip_trader["ret_val"]["trader_in"]
    summary["chip_trader_out"] += timed_summary_chip_trader["ret_val"]["trader_out"]
    summary["duration_chip_trader"] += timed_summary_chip_trader["duration"]
}

CallSimonAndPopulateSummary(&summary, w_win, h_win, max_bugfrags, tool_tip_simon) {
    summary_bugfrag_loop["bugfrags"] := Mmbn3GetPetText(w_win, h_win, ["bugfrags"])["bugfrags"]
    bugfrags_to_win := max_bugfrags - summary_bugfrag_loop["bugfrags"]
    timed_summary_simon := TimedCallTruncatedWReturn("S", SimonGameGrinder, w_win, h_win, bugfrags_to_win, tool_tip_simon)

    summary_bugfrag_loop["duration_simon"] += timed_summary_simon["duration"]
    summary_bugfrag_loop["bugfrags_gained"] += timed_summary_simon["ret_val"]["bugfrags_won"]
}

ConditionallyCallChipTraderWTravelAndPopulateSummary(&summary, w_win, h_win, chip_trader_start, chip_trader_type, chip_min_thresh, tool_tip_chip_trader) {
    if (Mmbn3GetLargestLibraryChipCount(w_win, h_win) >= chip_trader_start) {
        if (chip_trader_type = "higsbys") {
            travel_hotel_front_at_tamakos_hp_to_chip_trader := TravelHotelFrontAtTamakosHPToHigsbysAtTrader
            travel_chip_trader_to_hotel_front_at_tamakos_hp := TravelHigsbysAtTraderToHotelFrontAtTamakosHP
        } else if (chip_trader_type = "hospital") {
            travel_hotel_front_at_tamakos_hp_to_chip_trader := TravelHotelFrontAtTamakosHPToHospLobbyAtTrader
            travel_chip_trader_to_hotel_front_at_tamakos_hp := TravelHospLobbyAtTraderToHotelFrontAtTamakosHP
        } else if (chip_trader_type = "dnn") {
            travel_hotel_front_at_tamakos_hp_to_chip_trader := TravelHotelFrontAtTamakosHPToTVStnHallAtTrader
            travel_chip_trader_to_hotel_front_at_tamakos_hp := TravelTVStnHallAtTraderToHotelFrontAtTamakosHP
        } else {
            MsgBox("FATAL: unexpected chip_trader_type=".chip_trader_type)
            ExitApp(1)
        }

        summary_bugfrag_loop["duration_travel_tamako_to_chip"] += TimedCallTruncated("S", travel_hotel_front_at_tamakos_hp_to_chip_trader)
        CallChipTraderAndPopulateSummary(&summary, w_win, h_win, chip_trader_type, chip_min_thresh, tool_tip_chip_trader)
        summary_bugfrag_loop["duration_travel_chip_to_tamako"] += TimedCallTruncated("S", travel_chip_trader_to_hotel_front_at_tamakos_hp)
    }
}

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

;; settable vars
initial_bugfrags_to_trader := 6000
max_bugfrags := 9999
chip_min_thresh := 10
chip_trader_start := 99
chip_trader_type := "dnn"

;; hardcoded vars
tool_tip_bugfrag_trader := ToolTipCfg("dl", 3)
tool_tip_chip_trader := ToolTipCfg("dr", 4)
tool_tip_simon := ToolTipCfg("ur", 2)
tool_tip_summary := ToolTipCfg("ul", 1)

summary_bugfrag_loop := Map(
    "bugfrags", 0,
    "bugfrags_gained", 0,
    "bugfrags_traded", 0,
    "chips_gained", 0,
    "chip_trader_in", 0,
    "chip_trader_out", 0,
    "duration_chip_trader", 0,
    "duration_simon", 0,
    "duration_total", 0,
    "duration_bugfrag_trader", 0,
    "duration_travel_chip_to_tamako", 0,
    "duration_travel_simon_to_trader", 0,
    "duration_travel_trader_to_simon", 0,
    "duration_travel_tamako_to_chip", 0,
    "duration_travel_tamako_to_simon", 0,
    "duration_travel_tamako_to_trader", 0,
)

MaximizeAndFocusWindow(title_megaman_collection_1)
WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

RepeatHoldKeyForDurationE("k", 50, 2500)

if (mmbn3_ratio_rgbs_bugfrag_trader.DoesWindowMatchRatioRgbs(w_win, h_win)) {
    summary_bugfrag_loop["bugfrags"] := Mmbn3GetPetText(w_win, h_win, ["bugfrags"])["bugfrags"]
    CallBugFragTraderAndPopulateSummary(&summary_bugfrag_loop, w_win, h_win, summary_bugfrag_loop["bugfrags"], tool_tip_bugfrag_trader)
    summary_bugfrag_loop["duration_travel_trader_to_simon"] += TimedCallTruncated("S", TravelSecretArea3AtTraderToUnderSquareAtSimon, w_win, h_win)
}
else if (mmbn3_ratio_rgbs_hotel_lobby_at_tamakos_pc.DoesWindowMatchRatioRgbs(w_win, h_win)) {
    summary_bugfrag_loop["bugfrags"] := Mmbn3GetPetText(w_win, h_win, ["bugfrags"])["bugfrags"]
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
    ConditionallyCallChipTraderWTravelAndPopulateSummary(&summary_bugfrag_loop, w_win, h_win, chip_trader_start, chip_trader_type, chip_min_thresh, tool_tip_chip_trader)
    summary_bugfrag_loop["duration_travel_simon_to_trader"] += TimedCallTruncated("S", TravelUnderSquareAtSimonToSecretArea3AtTrader, w_win, h_win)

    CallBugFragTraderAndPopulateSummary(&summary_bugfrag_loop, w_win, h_win, max_bugfrags, tool_tip_bugfrag_trader)
    summary_bugfrag_loop["duration_travel_trader_to_simon"] += TimedCallTruncated("S", TravelSecretArea3AtTraderToUnderSquareAtSimon, w_win, h_win)

    tool_tip_summary.DisplayMsg(MapToStr(summary_bugfrag_loop), w_win, h_win)
}

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
