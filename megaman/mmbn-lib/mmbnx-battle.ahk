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

StartBattleSendChip1() {
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("d", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1300)
}

StartBattleUseTimestopChip1(timestop_duration) {
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("d", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1320)
    HoldKeyE("j", 50)
    Sleep(timestop_duration)
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

BattleLoop(w_win, h_win, fight_func, fight_func_param, num_battles_until_save := 100, num_battles_max := "", num_battles_check_zenny := "", zenny_battle_stop_thresh := "", tool_tip_cfg := ToolTipCfg()) {
    battles := 0
    zenny := "NULL"
    zenny_gained := 0

    zenny_initial := GetZenny(w_win, h_win)
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
            "num_battles_check_zenny", num_battles_check_zenny,
            "num_battles_max", num_battles_max,
            "num_battles_until_save", num_battles_until_save,
            "zenny", zenny,
            "zenny_battle_stop_thresh", zenny_battle_stop_thresh,
            "zenny_gained", zenny_gained,
        )

        if (num_battles_check_zenny != "" && Mod(A_Index, num_battles_check_zenny) = 0) {
            zenny := GetZenny(w_win, h_win)
            if (zenny_battle_stop_thresh != "" && zenny >= zenny_battle_stop_thresh) {
                battle_summary["zenny_gained"] := zenny - zenny_initial
                break
            }
        }

        if (num_battles_max != "" && battles >= num_battles_max) {
            battle_summary["zenny_gained"] := GetZenny(w_win, h_win) - zenny_initial
            break
        }

        tool_tip_cfg.DisplayMsg(MapToStr(battle_summary), w_win, h_win)
    }

    return battle_summary
}
