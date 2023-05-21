#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-pet.ahk"

#include <keypress-utils>
#include <string-utils>
#include <timer-utils>
#include <tool-tip-utils>
#include <window-utils>

ShootAndContinueUntilBattleOver(w_win, h_win) {
    while (true) {
        if (mmbn3_ratio_rgbs_megaman_side_foot.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            return "battle_over"
        }
        if (mmbn3_ratio_rgbs_main_menu_tm.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            StartGame()
            return "main_menu"
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
        HoldKeyE("enter", 50)
        Sleep(100)
    }

    prev_chip_slot := 0
    for chip_slot in start_battle_chip_state.chip_slots_to_send {
        slots_differential := chip_slot - prev_chip_slot
        key_direction := slots_differential > 0 ? "d" : "a"

        Loop Abs(slots_differential) {
            HoldKeyE(key_direction, 50)
            Sleep(100)
        }

        HoldKeyE("j", 50)
        Sleep(100)
        prev_chip_slot := chip_slot
    }
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1320)
}

UseChips(start_battle_chip_state) {
    Loop start_battle_chip_state.num_chips_to_use {
        HoldKeyE("j", 50)
        Sleep(start_battle_chip_state.post_chip_sleeps[A_Index])
    }
}

StartBattleWUseChips(start_battle_chip_state) {
    StartBattle(start_battle_chip_state)
    UseChips(start_battle_chip_state)
}

RunFromBattle() {
    ;; timed at 4015 ms
    static battle_exit_duration := 1000
    static battle_run_confirm_duration := 2100

    HoldKeyE("q", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(battle_run_confirm_duration)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(battle_exit_duration)
}

/**
 * Return a start_battle_chip_state object to describe start of battle chip actions.
 * @param start_battle_chip_state_str String: determines which start_battle_chip_state to return.
 *   custom: sends all chips, but does not use them; progresses towards custom style
 *   invis:  uses preset invis chip; progresses towards shadow style (mmbn3-blue exclusive)
 *   none:   sends no chips; progresses towards guts style
 *   recov:  uses preset recov chip (only tested Recov120); progresses towards shield style
 *   stage:  uses preset stage chip (only tested IceStage and GrassStg); progresses towards ground style (mmbn3-white exclusive)
 *   team:   sends preset navi chip (recommended FlashMan); progresses towards team style
 * @param force_secondary_style String: determines secondary style to prioritize other than the style implied by start_battle_chip_state_str.
 *   custom: progresses custom style by sending all chips
 *   none:   no effect (NOTE: guts style is default secondary style, or shield style if already guts style)
 * @returns start_battle_chip_state object.
 */
Mmbn3ChooseStartBattleChipState(start_battle_chip_state_str, force_secondary_style := "none") {
    if (start_battle_chip_state_str = "custom") {
        start_battle_chip_state := { chip_slots_to_send: [1, 2, 3, 4, 5], num_chips_to_use: 0, post_chip_sleeps: [], timestop_duration: 0 }
    } else if (start_battle_chip_state_str = "invis") {
        start_battle_chip_state := { chip_slots_to_send: [1], num_chips_to_use: 1, post_chip_sleeps: [125], timestop_duration: 0 }
    } else if (start_battle_chip_state_str = "none") {
        start_battle_chip_state := { chip_slots_to_send: [], num_chips_to_use: 0, post_chip_sleeps: [], timestop_duration: 0 }
    } else if (start_battle_chip_state_str = "recov") {
        start_battle_chip_state := { chip_slots_to_send: [1], num_chips_to_use: 1, post_chip_sleeps: [150], timestop_duration: 0 }
    } else if (start_battle_chip_state_str = "stage") {
        start_battle_chip_state := { chip_slots_to_send: [1], num_chips_to_use: 1, post_chip_sleeps: [3020], timestop_duration: 3020 }
    } else if (start_battle_chip_state_str = "team") {
        start_battle_chip_state := { chip_slots_to_send: [1], num_chips_to_use: 0, post_chip_sleeps: [], timestop_duration: 0 }
    } else {
        MsgBox("FATAL: unexpected start_battle_chip_state_str=" . start_battle_chip_state_str)
        ExitApp(1)
    }

    if (force_secondary_style = "custom") {
        Loop 5 - start_battle_chip_state.chip_slots_to_send.Length {
            start_battle_chip_state.chip_slots_to_send.Push(start_battle_chip_state.chip_slots_to_send.Length + 1)
            start_battle_chip_state.post_chip_sleeps.Push(0)
        }
        return start_battle_chip_state
    } else if (force_secondary_style = "none") {
        return start_battle_chip_state
    } else {
        MsgBox("FATAL: unexpected force_secondary_style=" . force_secondary_style)
        ExitApp(1)
    }
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

BattleGrinder(w_win, h_win, fight_func, fight_func_param, num_battles_until_save := 100, health_heal_ratio := "", num_battles_max := "", num_battles_check_text := "", bugfrags_stop := "", zenny_stop := "", tool_tip_cfg := ToolTipCfg()) {
    timer_battles := Timer()

    break_loop := false
    deaths := 0

    pet_text_initial := Mmbn3GetPetText(w_win, h_win, ["bugfrags", "health_current", "health_total", "zenny"])
    battle_summary := Map(
        "battles", 0,
        "bugfrags_initial", pet_text_initial["bugfrags"],
        "bugfrags_stop", bugfrags_stop,
        "deaths", deaths,
        "duration_loop", 0,
        "duration_total", 0,
        "health_current", pet_text_initial["health_current"],
        "health_heal_ratio", Round(health_heal_ratio, 2),
        "health_total", pet_text_initial["health_total"],
        "num_battles_check_text", num_battles_check_text,
        "num_battles_max", num_battles_max,
        "num_battles_until_save", num_battles_until_save,
        "zenny_initial", pet_text_initial["zenny"],
        "zenny_stop", zenny_stop,
    )

    battle_summary["duration_total"] := timer_battles.ElapsedSecTruncated()
    Loop {
        timer_battles.Reset()

        WalkUntilBattle(w_win, h_win)

        battle_executed := fight_func(fight_func_param)

        if (!battle_executed) {
            PrintBattleDebug(w_win, h_win)
        }

        if (ShootAndContinueUntilBattleOver(w_win, h_win) = "main_menu") {
            deaths += 0
        }

        battle_summary["battles"] += 1
        battle_summary["duration_loop"] := timer_battles.ElapsedSecTruncated()
        battle_summary["duration_total"] += battle_summary["duration_loop"]

        if (num_battles_until_save != "" && Mod(A_Index, num_battles_until_save) = 0) {
            SaveProgressOrStartGame(w_win, h_win)
            JackOutThenIn()
        }

        if (num_battles_check_text != "" && Mod(A_Index, num_battles_check_text) = 0) {
            pet_text := Mmbn3GetPetText(w_win, h_win, ["bugfrags", "health_current", "health_total", "zenny"])
            battle_summary["bugfrags"] := pet_text["bugfrags"]
            battle_summary["bugfrags_gained"] := pet_text["bugfrags"] - battle_summary["bugfrags_initial"]
            battle_summary["bugfrags_per_sec"] := Round(battle_summary["bugfrags_gained"] / battle_summary["duration_total"], 2)
            battle_summary["zenny"] := pet_text["zenny"]
            battle_summary["zenny_gained"] := pet_text["zenny"] - battle_summary["zenny_initial"]
            battle_summary["zenny_per_sec"] := Round(battle_summary["zenny_gained"] / battle_summary["duration_total"], 2)

            if (bugfrags_stop != "" && pet_text["bugfrags"] >= bugfrags_stop) {
                break_loop := true
            }
            if (zenny_stop != "" && pet_text["zenny"] >= zenny_stop) {
                break_loop := true
            }
            if (health_heal_ratio != "" && (pet_text["health_current"] / pet_text["health_total"]) < health_heal_ratio) {
                JackOutThenIn()
            }
        }

        if (num_battles_max != "" && battle_summary["battles"] >= num_battles_max) {
            pet_text := Mmbn3GetPetText(w_win, h_win, ["bugfrags", "zenny"])
            battle_summary["bugfrags"] := pet_text["bugfrags"]
            battle_summary["bugfrags_gained"] := pet_text["bugfrags"] - battle_summary["bugfrags_initial"]
            battle_summary["bugfrags_per_sec"] := Round(battle_summary["bugfrags_gained"] / battle_summary["duration_total"], 2)
            battle_summary["zenny"] := pet_text["zenny"]
            battle_summary["zenny_gained"] := pet_text["zenny"] - battle_summary["zenny_initial"]
            battle_summary["zenny_per_sec"] := Round(battle_summary["zenny_gained"] / battle_summary["duration_total"], 2)
            break_loop := true
        }

        tool_tip_cfg.DisplayMsg(MapToStr(battle_summary), w_win, h_win)

        if (break_loop) {
            break
        }
    }

    return battle_summary
}
