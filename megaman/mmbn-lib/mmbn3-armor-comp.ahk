#include "%A_ScriptDir%\mmbn-lib\mmbn3-battle.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-enemies.ahk"

#include <keypress-utils>

ExecuteArmorCompBattleIfDetected() {
    CoordMode("Mouse", "Client")
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_megaman_collection_1)

    existing_mettaur := FindMettaur(w_win, h_win)
    existing_mettaur2 := FindMettaur2(w_win, h_win)
    existing_fishy3 := FindFishy3(w_win, h_win)
    existing_hard_head := FindHardHead(w_win, h_win)
    existing_canodumb3 := FindCanodumb3(w_win, h_win)
    existing_nailer := FindNailer(w_win, h_win)
    existing_japan_man := FindJapanMan(w_win, h_win)

    if (existing_mettaur = 40 && existing_mettaur2 = 0) {
        StartBattle()
        Sleep(1650)
        HoldKeyE("k", 50)
        Sleep(1750)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 130 && existing_mettaur2 = 0) {
        StartBattle()
        Sleep(850)
        HoldKeyE("k", 50)
        Sleep(800)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 128 && existing_mettaur2 = 5) {
        StartBattle()
        Sleep(800)
        HoldKeyE("k", 50)
        Sleep(1200)
        HoldKeyE("k", 50)
        Sleep(750)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 40 && existing_mettaur2 = 2) {
        StartBattle()
        Sleep(400)
        HoldKeyE("k", 50)
        Sleep(1650)
        HoldKeyE("k", 50)
        Sleep(1650)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 84 && existing_mettaur2 = 0) {
        StartBattle()
        Sleep(1650)
        HoldKeyE("k", 50)
        Sleep(900)
        HoldKeyE("k", 50)
        Sleep(1600)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 0 && existing_mettaur2 = 273) {
        StartBattle()
        Sleep(750)
        HoldKeyE("k", 50)
        Sleep(800)
        HoldKeyE("k", 50)
        Sleep(1200)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 273 && existing_mettaur2 = 0) {
        StartBattle()
        Sleep(1650)
        HoldKeyE("k", 50)
        Sleep(900)
        HoldKeyE("k", 50)
        Sleep(1600)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 0 && existing_mettaur2 = 84) {
        StartBattle()
        Sleep(800)
        HoldKeyE("k", 50)
        Sleep(750)
        HoldKeyE("k", 50)
        Sleep(1150)
        HoldKeyE("k", 50)
    } else if (existing_fishy3 = 12 && existing_hard_head = 128) {
        StartBattle()
        Sleep(300)
        HoldKeyE("k", 50)
        Sleep(200)
        HoldKeyE("k", 50)
        Sleep(7750)
        HoldKeyE("k", 50)
    } else if (existing_fishy3 = 16 && existing_hard_head = 320) {
        StartBattle()
        HoldKeyE("k", 50)
        Sleep(50)
        HoldKeyE("s", 50)
        Sleep(6750)
        HoldKeyE("k", 50)
        Sleep(500)
        HoldKeyE("w", 50)
        Sleep(400)
        HoldKeyE("w", 50)
        Sleep(300)
        HoldKeyE("k", 50)
    } else if (existing_fishy3 = 2 && existing_hard_head = 128) {
        StartBattle()
        HoldKeyE("k", 50)
        Sleep(6800)
        HoldKeyE("k", 50)
    } else if (existing_japan_man = 16) {
        HoldKeyE("Enter", 50)
        Sleep(200)
        HoldKeyE("d", 50)
        HoldKeyE("j", 50)
        StartBattle()
        Sleep(25)
        HoldKeyE("j", 50)
        RepeatHoldKeyForDurationE("k", 50, 15000)
    } else {
        return False
    }

    return True
}
