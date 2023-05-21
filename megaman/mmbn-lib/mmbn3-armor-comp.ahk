#include "%A_ScriptDir%\mmbn-lib\mmbn3-enemies.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"

#include <keypress-utils>
#include <timer-utils>

ExecuteArmorCompBattleIfDetected(start_battle_chip_state, grind_guard_chips := false) {
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
        StartBattle(start_battle_chip_state)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        Sleep(1630 - battle_delay)
        HoldKeyE("k", 50)
        Sleep(1700)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 130 && existing_mettaur2 = 0) {
        StartBattle(start_battle_chip_state)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        Sleep(830 - battle_delay)
        HoldKeyE("k", 50)
        Sleep(800)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 128 && existing_mettaur2 = 5) {
        StartBattle(start_battle_chip_state)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        if (grind_guard_chips) {
            MettaurStall(false)
            Sleep(780)
        } else {
            Sleep(780 - battle_delay)
        }
        HoldKeyE("k", 50)
        Sleep(1200)
        HoldKeyE("k", 50)
        Sleep(750)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 40 && existing_mettaur2 = 2) {
        StartBattle(start_battle_chip_state)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        if (grind_guard_chips) {
            MettaurStall(true)
            Sleep(380)
        } else {
            Sleep(380 - battle_delay)
        }
        HoldKeyE("k", 50)
        Sleep(1650)
        HoldKeyE("k", 50)
        Sleep(1650)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 84 && existing_mettaur2 = 0) {
        StartBattle(start_battle_chip_state)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        Sleep(1630 - battle_delay)
        HoldKeyE("k", 50)
        Sleep(900)
        HoldKeyE("k", 50)
        Sleep(1600)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 0 && existing_mettaur2 = 273) {
        StartBattle(start_battle_chip_state)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        if (grind_guard_chips) {
            MettaurStall(false)
            Sleep(730)
        }
        else {
            Sleep(730 - battle_delay)
        }
        HoldKeyE("k", 50)
        Sleep(800)
        HoldKeyE("k", 50)
        Sleep(1200)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 273 && existing_mettaur2 = 0) {
        StartBattle(start_battle_chip_state)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        Sleep(1630 - battle_delay)
        HoldKeyE("k", 50)
        Sleep(900)
        HoldKeyE("k", 50)
        Sleep(1600)
        HoldKeyE("k", 50)
    } else if (existing_mettaur = 0 && existing_mettaur2 = 84) {
        StartBattle(start_battle_chip_state)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        if (grind_guard_chips) {
            MettaurStall(false)
            Sleep(780)
        } else {
            Sleep(780 - battle_delay)
        }
        HoldKeyE("k", 50)
        Sleep(750)
        HoldKeyE("k", 50)
        Sleep(1150)
        HoldKeyE("k", 50)
    } else if (existing_fishy3 = 12 && existing_hard_head = 128) {
        StartBattle(start_battle_chip_state)
        Sleep(280)
        HoldKeyE("k", 50)
        Sleep(200)
        HoldKeyE("k", 50)
        Sleep(500)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        Sleep(7250 - battle_delay)
        HoldKeyE("k", 50)
    } else if (existing_fishy3 = 16 && existing_hard_head = 320) {
        StartBattle(start_battle_chip_state)
        HoldKeyE("k", 50)
        Sleep(550)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        HoldKeyE("s", 50)
        Sleep(6200 - battle_delay)
        HoldKeyE("k", 50)
        Sleep(550)
        HoldKeyE("w", 50)
        Sleep(400)
        HoldKeyE("w", 50)
        Sleep(300)
        HoldKeyE("k", 50)
    } else if (existing_fishy3 = 2 && existing_hard_head = 128) {
        StartBattle(start_battle_chip_state)
        HoldKeyE("k", 50)
        Sleep(500)
        battle_delay := TimedCall("mS", UseChips, start_battle_chip_state) - start_battle_chip_state.timestop_duration
        Sleep(6300 - battle_delay)
        HoldKeyE("k", 50)
    } else if (existing_japan_man = 16) {
        start_battle_chip_state_japan_man := { chip_slots_to_send: [1], num_chips_to_use: 1, post_chip_sleeps: [100] }
        StartBattleWUseChips(start_battle_chip_state_japan_man)
        RepeatHoldKeyForDurationE("k", 50, 15000)
    } else {
        return false
    }

    return true
}

ExecuteArmorCompBattleIfDetectedWMettaurStall(start_battle_chip_state) {
    return ExecuteArmorCompBattleIfDetected(start_battle_chip_state, true)
}
