#Requires AutoHotkey v2.0-a
#SingleInstance Force

#include "%A_ScriptDir%\mmbn-lib\mmbnx-chip-trader.ahk"

#include <keypress-utils>
#include <tool-tip-utils>
#include <window-utils>

;; support:
;; * mmbn3: higsby_3 hospital_10, dnn_10, number

TradeBugfrags() {
    MaximizeAndFocusWindow(title_megaman_collection_1)
    RepeatHoldKeyForDurationE("k", 50, 2500)
    while (true) {
        HoldKeyE("j", 50)
    }
}

TradeChips(chips_per_trade) {
    MaximizeAndFocusWindow(title_megaman_collection_1)
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)
    RepeatHoldKeyForDurationE("k", 50, 2500)

    chip_min_thresh := 10

    Mmbn3TradeUntilMinChipThresh(w_win, h_win, chip_min_thresh, chips_per_trade)
}

TradeNumber() {
    lotto_codes_mmbn3 := [
        ;; Key Item
        "90690648", ;; Famous’ WrstBand
        "11002540", ;; SpinBlue
        "28274283", ;; SpinGrn
        "72563938", ;; SpinRed
        "77955025", ;; SpinWhit
        ;; NaviCust Part
        "23415891", ;; AirShoes (White)
        "67918452", ;; FstGauge (Pink)
        "19878934", ;; SetSand (Green)
        "41465278", ;; WeapLV+1 (White)
        ;; Battle Chip
        "15789208", ;; AirShot3 *
        "54390805", ;; Bolt *
        "01697824", ;; CopyDmg *
        "88543997", ;; Fountain *
        "33157825", ;; GaiaBlad *
        "95913876", ;; GutStrgt S
        "03284579", ;; HeroSwrd P
        "21247895", ;; HiCannon *
        "50098263", ;; Muramasa M
        "65497812", ;; Salamndr *
        "31549798", ;; Spreader *
        "76889120", ;; StepCros S
        "63997824", ;; VarSwrd F
        ;; Sub Chip
        "56892168", ;; FullEnrg
        "99826471", ;; FullEnrg
        "09234782", ;; LocEnemy
        "87824510", ;; LocEnemy
        "57789423", ;; MiniEnrg
        "86508964", ;; MiniEnrg
        "24586483", ;; SneakRun
        "35331089", ;; Unlocker
        "05088930", ;; Untrap
        "46823480", ;; Untrap
    ]

    MaximizeAndFocusWindow(title_megaman_collection_1)
    RepeatHoldKeyForDurationE("k", 50, 2500)

    for (lotto_code in lotto_codes_mmbn3) {
        RepeatHoldKeyForDurationE("j", 50, 2500)
        loop Parse lotto_code {
            Loop Integer(A_LoopField) {
                HoldKeyE("w", 50)
                Sleep(100)
            }
            HoldKeyE("d", 50)
            Sleep(100)
        }
        RepeatHoldKeyForDurationE("j", 50, 2500)
    }
}

TradeSelection(btn, info) {
    trader_selection := LB.Value
    gui_trader_selection.Destroy()

    if (trader_selection = 1) {
        TradeChips(3)
    } else if (trader_selection = 2) {
        TradeChips(10)
    } else if (trader_selection = 3) {
        TradeBugfrags()
    } else if (trader_selection = 4) {
        TradeNumber()
    } else {
        MsgBox("ERROR: unexpected selection value trader_selection=" . trader_selection)
        ExitApp(1)
    }
}

title_megaman_collection_1 := "MegaMan_BattleNetwork_LegacyCollection_Vol1"

gui_trader_selection := Gui(, 'Which Trader are you using?'), gui_trader_selection.SetFont('s10')
LB := gui_trader_selection.AddListBox('w230', ['3 Chip', '10 Chip', 'Bugfrag', 'Number'])
gui_trader_selection.AddButton('wp Default', 'OK').OnEvent('Click', TradeSelection)
gui_trader_selection.Show

Esc:: {
    ClearHeldKeysE("j k")
    ExitApp
}
