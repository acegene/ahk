#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include <keypress-utils>
#include <tool-tip-utils>
#include <window-utils>

/**
 * Automate entry of error codes or ex codes into navicustomizer
 * 
 * Prereqs
 *       * Modtools has been obtained
 * Usage
 *       * open error/ex code entry menu then execute script
 *       * either enter an error code, or one of the options displayed in the top right corner (case insensitive)
 *       * exit script by pressing escape key
 */

RepeatKey(key, repetetitons) {
    Loop repetetitons {
        HoldKeyE(key, 50)
        Sleep(100)
    }
}

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

tool_tip := ToolTipCfg()

ex_code_map := Map(
    "AirShoes", { error_code: "ZN3UDOIQ", bug: "Custom-1" },
    "AntiDamage", { error_code: "L3KJGUEO", bug: "Custom-1" },
    "Block", { error_code: "ZBKDEU1W", bug: "" },
    "BreakBuster", { error_code: "SI1IEMGO", bug: "Custom-1" },
    "BreakCharge", { error_code: "SKDSHUEO", bug: "Custom-2" },
    "FastGauge", { error_code: "XBCJF2RI", bug: "Custom-2" },
    "FloatShoes", { error_code: "PEOTIR2G", bug: "" },
    "GigaFolder1", { error_code: "KSIK1EIG", bug: "PoisonPanel" },
    "HP100", { error_code: "JIEU1AWT", bug: "" },
    "HP1000", { error_code: "CNJDU2EM", bug: "" },
    "HP150", { error_code: "U2IEOSKW", bug: "" },
    "HP200", { error_code: "ASK3IETN", bug: "" },
    "HP250", { error_code: "SIE1TMSD", bug: "" },
    "HP300", { error_code: "SEIUT1NG", bug: "" },
    "HP350", { error_code: "GJHURIE2", bug: "" },
    "HP400", { error_code: "AWE3ETSW", bug: "Custom-1" },
    "HP450", { error_code: "3MZNBXH1", bug: "Custom-1" },
    "HP500", { error_code: "2YTIWOAM", bug: "Custom-1" },
    "HP550", { error_code: "O3IUTNWQ", bug: "Custom-1" },
    "HP600", { error_code: "ZMJ1IGIE", bug: "Custom-2" },
    "HP650", { error_code: "SRUEIT3A", bug: "Custom-2" },
    "HP800", { error_code: "DMGEIO3W", bug: "Custom-2" },
    "HP900", { error_code: "SM2UIROA", bug: "Custom-2" },
    "Humor", { error_code: "SJH1UEKA", bug: "" },
    "MegaFolder1", { error_code: "JDKGJ1U2", bug: "" },
    "MegaFolder2", { error_code: "3DIVNEIQ", bug: "Custom-1" },
    "MegaFolder3", { error_code: "URY33RRO", bug: "PoisonPanel" },
    "MegaFolder4", { error_code: "FFIM1OWE", bug: "PoisonPanel" },
    "MegaFolder5", { error_code: "SKFBM3UW", bug: "PoisonPanel" },
    "Reflect", { error_code: "SK13EO1M", bug: "Custom-1" },
    "ShadowShoes", { error_code: "GKHU1KHI", bug: "" },
    "Shield", { error_code: "EIR3BM3I", bug: "" },
    "SlowGauge", { error_code: "2BKD1UEW", bug: "" },
    "SneakRun", { error_code: "UIEU2NGO", bug: "" },
    "SuperArmor", { error_code: "KTEIUE2D", bug: "" },
    "UnderShirt", { error_code: "SKJGURN2", bug: "" },
)

error_code_map := Map(
    "A1", "GYU2OPZQ",
    "A2", "3GKQ2RSQ",
    "A3", "LO13ZXME",
    "B1", "JHGIUTOP",
    "B2", "ALSK3W2R",
    "B3", "Y2UOMNCB",
    "B4", "1LSKUTOB",
    "B5", "BM2KWIRA",
    "B6", "UTI3OMDH",
    "C1", "X2CD3KDA",
    "C2", "UTIXM1LA",
    "D2C", "WS1FS1AQ",
    "D2G", "OI1UWMAN",
    "D2S", "P3TOSIIS",
    "E1", "P213MSJL",
    "E2", "UTIR1SO2",
    "F1", "QSAO3C3L",
    "F2", "NC1FKSA2",
    "F3", "ITA2CRWQ",
    "G2C", "TIS1LAEJ",
    "G2G", "CVVDS2WR",
    "G2S", "TUIEO23T",
    "H1", "A3DJMNB1",
    "H2", "UTIW2SMF",
    "H3", "SK3LROT1",
    "S2C", "TU1AW2LL",
    "S2G", "AX1RTDS3",
    "S2S", "F2AAFETG",
)

ex_code_str := ""
for (key, value in ex_code_map) {
    error_code_map[key] := value.error_code
    ex_code_str .= key . (value.bug != "" ? ("; BUG: " . value.bug) : "") . "`n"
}

char_move_map := Map(
    "A", 1,
    "B", 2,
    "C", 3,
    "D", 4,
    "E", 5,
    "F", 6,
    "G", 7,
    "H", 8,
    "I", 9,
    "J", 10,
    "K", 11,
    "L", 12,
    "M", 13,
    "N", 14,
    "O", 15,
    "P", 16,
    "Q", 17,
    "R", 18,
    "S", 19,
    "T", 20,
    "U", 21,
    "V", 22,
    "W", 23,
    "X", 24,
    "Y", 25,
    "Z", 26,
    "1", 27,
    "2", 28,
    "3", 29,
)

WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

MaximizeAndFocusWindow(title_megaman_collection_1)
Sleep(500)
HoldKeyE("k", 50)

tool_tip.DisplayMsg(ex_code_str, w_win, h_win)

error_code_user_input := InputBox("PROMPT: Please enter error code:")

MaximizeAndFocusWindow(title_megaman_collection_1)
Sleep(500)
HoldKeyE("k", 50)
Sleep(3000)

if (error_code_user_input.Result = "OK") {
    error_code := StrUpper(error_code_user_input.Value)
    Loop Parse error_code_map[error_code] {
        RepeatKey("enter", 1)
        char_index := char_move_map[A_LoopField]
        if (char_index < 8) {
            RepeatKey("d", char_index)
            RepeatKey("w", 1)
            RepeatKey("j", 1)
        } else if (char_index < 16) {
            RepeatKey("a", 15 - char_index)
            RepeatKey("w", 1)
            RepeatKey("j", 1)
        } else if (char_index < 23) {
            RepeatKey("d", char_index - 15)
            RepeatKey("j", 1)
        } else if (char_index < 31) {
            RepeatKey("a", 30 - char_index)
            RepeatKey("j", 1)
        } else {
            MsgBox("ERROR: unexpexted char_index=" . char_index)
            ExitApp(1)
        }
    }
    RepeatKey("enter", 1)
    RepeatKey("j", 1)

} else {
    ExitApp(1)
}

tool_tip.DisplayMsg("", w_win, h_win)

$Esc:: {
    ClearHeldKeysE("w a s d j k q e enter")
    ExitApp
}
