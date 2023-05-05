#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"

#include <keypress-utils>
#include <string-utils>
#include <tool-tip-utils>
#include <window-utils>

ShootAndContinueUntilBattleOver(w_win, h_win) {
    while (true) {
        if (mmbn3_ratio_rgbs_megaman_side_foot.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            break
        }
        HoldKeyE("k", 50)
        Sleep(100)
        HoldKeyE("j", 50)
        Sleep(100)
    }
}

StartBattle(start_battle_chip_state) {
    HoldKeyE("enter", 50)
    Sleep(100)
    if (start_battle_chip_state.num_chips_to_use != 0) {
        Loop 5 {
            HoldKeyE("d", 50)
            Sleep(100)
            HoldKeyE("k", 50)
            Sleep(100)
        }
    }
    for chip_slot in start_battle_chip_state.chip_slots_to_send {
        HoldKeyE("enter", 50)
        Sleep(100)
        Loop chip_slot {
            HoldKeyE("d", 50)
            Sleep(100)
            HoldKeyE("j", 50)
            Sleep(100)
        }
    }
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1320)
    Loop start_battle_chip_state.num_chips_to_use {
        HoldKeyE("j", 50)
        Sleep(start_battle_chip_state.post_chip_sleeps[A_Index])
    }
}


ChooseStartBattleChipState(start_battle_chip_state_str) {
    if (start_battle_chip_state_str = "custom") {
        return { chip_slots_to_send: [1, 2, 3, 4, 5], num_chips_to_use: 0, post_chip_sleeps: [] }
    } else if (start_battle_chip_state_str = "none") {
        return { chip_slots_to_send: [], num_chips_to_use: 0, post_chip_sleeps: [] }
    } else if (start_battle_chip_state_str = "team") {
        return { chip_slots_to_send: [1], num_chips_to_use: 0, post_chip_sleeps: [] }
    }

    MsgBox("FATAL: unexpected start_battle_chip_state_str=" . start_battle_chip_state_str)
    ExitApp(1)
}

PrintBattleDebug(w_win, h_win) {
    CoordMode("Mouse", "Client")
    global lu := PixelGetColor(x_ratio_l * w_win, y_ratio_u * h_win, "RGB")
    global lm := PixelGetColor(x_ratio_l * w_win, y_ratio_m * h_win, "RGB")
    global ld := PixelGetColor(x_ratio_l * w_win, y_ratio_d * h_win, "RGB")
    global mu := PixelGetColor(x_ratio_m * w_win, y_ratio_u * h_win, "RGB")
    global mm := PixelGetColor(x_ratio_m * w_win, y_ratio_m * h_win, "RGB")
    global md := PixelGetColor(x_ratio_m * w_win, y_ratio_d * h_win, "RGB")
    global ru := PixelGetColor(x_ratio_r * w_win, y_ratio_u * h_win, "RGB")
    global rm := PixelGetColor(x_ratio_r * w_win, y_ratio_m * h_win, "RGB")
    global rd := PixelGetColor(x_ratio_r * w_win, y_ratio_d * h_win, "RGB")
    MsgBox(GenerateDebugStr("lu lm ld mu mm md ru rm rd x_ratio_l x_ratio_m x_ratio_r y_ratio_u y_ratio_m y_ratio_d"))
}

BattleLoop(w_win, h_win, fight_func, fight_func_param, num_battles_until_save := 100, num_battles_max := "", num_battles_check_text := "", bugfrags_stop := "", zenny_stop := "", tool_tip_cfg := ToolTipCfg()) {
    battles := 0

    pet_text_initial := GetPetText(w_win, h_win, ["bugfrags", "zenny"])
    bugfrags_initial := pet_text_initial["bugfrags"]
    zenny_initial := pet_text_initial["zenny"]
    Loop {
        WalkUntilBattle(w_win, h_win)

        battle_executed := fight_func(fight_func_param)

        if (!battle_executed) {
            PrintBattleDebug(w_win, h_win)
        }

        ShootAndContinueUntilBattleOver(w_win, h_win)

        battles += 1

        if (num_battles_until_save != "" && Mod(A_Index, num_battles_until_save) = 0) {
            SaveProgressOrStartGame(w_win, h_win)
            JackOutThenIn()
        }

        battle_summary := Map(
            "battles", battles,
            "bugfrags_initial", bugfrags_initial,
            "bugfrags_stop", bugfrags_stop,
            "num_battles_check_text", num_battles_check_text,
            "num_battles_max", num_battles_max,
            "num_battles_until_save", num_battles_until_save,
            "zenny_initial", zenny_initial,
            "zenny_stop", zenny_stop,
        )

        if (num_battles_check_text != "" && Mod(A_Index, num_battles_check_text) = 0) {
            pet_text := GetPetText(w_win, h_win, ["bugfrags", "zenny"])
            battle_summary["bugfrags"] := pet_text["bugfrags"]
            battle_summary["bugfrags_gained"] := pet_text["bugfrags"] - bugfrags_initial
            battle_summary["zenny"] := pet_text["zenny"]
            battle_summary["zenny_gained"] := pet_text["zenny"] - zenny_initial

            if (bugfrags_stop != "" && pet_text["bugfrags"] >= bugfrags_stop) {
                break
            }
            if (zenny_stop != "" && pet_text["zenny"] >= zenny_stop) {
                break
            }
        }

        if (num_battles_max != "" && battles >= num_battles_max) {
            pet_text := GetPetText(w_win, h_win, ["bugfrags", "zenny"])
            battle_summary["bugfrags"] := pet_text["bugfrags"]
            battle_summary["bugfrags_gained"] := pet_text["bugfrags"] - bugfrags_initial
            battle_summary["zenny"] := pet_text["zenny"]
            battle_summary["zenny_gained"] := pet_text["zenny"] - zenny_initial
            break
        }

        tool_tip_cfg.DisplayMsg(MapToStr(battle_summary), w_win, h_win)
    }

    return battle_summary
}
