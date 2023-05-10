#include "%A_ScriptDir%\mmbn-lib\mmbnx-ratio-rgbs.ahk"

#include <keypress-utils>
#include <string-utils>
#include <timer-utils>
#include <tool-tip-utils>
#include <window-utils>

InitiateBugfragTrader() {
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
}

Mmbn3TradeBugfrags() {
    HoldKeyE("j", 50)
    Sleep(100)
    KeysDownE(["k"])
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(3000)
    KeysUpE(["k"])
}

Mmbn3TradeNBugfrags(w_win, h_win, bugfrags_to_trade := 9999, tool_tip := ToolTipCfg(), bugfrags_per_trade := 10) {
    timer_trade_bugfrags := Timer()
    trade_bugfrags_summary := Map(
        "bugfrags_per_trade", bugfrags_per_trade,
        "bugfrags_to_trade", bugfrags_to_trade,
    )
    num_trades := bugfrags_to_trade // bugfrags_per_trade
    Loop num_trades {
        Mmbn3TradeBugfrags()

        trade_bugfrags_summary["bugfrags_traded"] := bugfrags_per_trade * A_Index
        trade_bugfrags_summary["chips_gained"] := A_Index
        trade_bugfrags_summary["chips_per_sec"] := Round(trade_bugfrags_summary["chips_gained"] / duration, 2)
        duration := timer_trade_bugfrags.ElapsedSec()
        trade_bugfrags_summary["duration"] := Round(duration)

        bugfrags_per_sec := trade_bugfrags_summary["bugfrags_traded"] / duration
        trade_bugfrags_summary["bugfrags_per_sec"] := Round(bugfrags_per_sec, 2)
        trade_bugfrags_summary["est_duration_remaining"] := Round((bugfrags_to_trade - trade_bugfrags_summary["bugfrags_traded"]) / bugfrags_per_sec)

        tool_tip.DisplayMsg(MapToStr(trade_bugfrags_summary), w_win, h_win)
    }

    return trade_bugfrags_summary
}

Mmbn3TradeNBugfragsWInitiate(w_win, h_win, bugfrags_to_trade := 9999, tool_tip := ToolTipCfg(), bugfrags_per_trade := 10) {
    InitiateBugfragTrader()
    return Mmbn3TradeNBugfrags(w_win, h_win, bugfrags_to_trade, tool_tip, bugfrags_per_trade)
}
