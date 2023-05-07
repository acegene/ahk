#Requires AutoHotkey v2.0-a
#SingleInstance Force
#include <optimizations-gaming>

#include <keypress-utils>
#include <window-utils>

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

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

RepeatKey(key, repetetitons) {
    Loop repetetitons {
        HoldKeyE(key, 50)
        Sleep(100)
    }
}


WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

MaximizeAndFocusWindow(title_megaman_collection_1)
Sleep(500)
HoldKeyE("k", 50)

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
            RepeatKey("d", char_index)
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

Esc:: {
    ClearHeldKeysE("w a s d j k e enter")
    ExitApp
}
