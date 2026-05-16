#Requires AutoHotkey v2.0
#SingleInstance Force
#include <optimizations-gaming>

#include "%A_ScriptDir%\minecraft-lib\minecraft-ratios.ahk"

#include <array-utils>
#include <keypress-utils>
#include <mouse-utils>
#include <tool-tip-utils>
#include <window-utils>

/**
 * Drinks potions as needed for raid farm
 *
 * prereqs
 *   * looking directly up from the afk spot does not face an object that is interacted with by right-clicking while holding an ominous potion
 *   * place in hotbar slot 2 item to hold during afk (e.g. looting sword or item to heal with mending)
 */

if (!A_IsAdmin) {
    try {
        Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"')
    } catch Error as e {
        MsgBox "ERROR: Failed to restart as admin.`n" e.Message
    }
    ExitApp
}

BlockInputWithOverrideDbg(block_input) {
    if (block_input_override_dbg) {
        BlockInput(false) ; necessary if stuck on blocked after setting block_input_override_dbg:=true
    } else {
        BlockInput(block_input)
    }
}

MsgBoxDetectedPotionsDbg(w_win, h_win) {
    potions := ""
    Loop ratio_rgbs_potions.Length {
        if (ratio_rgbs_potions[A_Index].DoesWindowMatchRatioRgbs(w_win, h_win)) {
            potions .= A_Index . ", "
        }
    }
    MsgBox(potions)
}

ShowTooltip(*) {
    if (WinActive(title_minecraft)) {
        total_run_time_ms := A_TickCount - start_time_ms
        time_since_last_potion := (time_of_last_potion_ms == "") ? -1 : A_TickCount - time_of_last_potion_ms
        waits_until_raid_done_ms_str := ""
        for (index, duration in waits_until_raid_done_ms) {
            if (Mod(index - 1, 5) == 0) {
                waits_until_raid_done_ms_str .= "`n "
            }
            waits_until_raid_done_ms_str .= " " . Floor(duration / 1000)
        }
        WinGetPos(&x_win, &y_win, &w_win, &h_win, title_minecraft)
        tool_tip.DisplayMsg(
            "paused=" . (paused ? "true" : "false") .
            "`nblocked_input=" . (blocked_input ? "true" : "false") .
            "`nblocked_input_while_focused=" . (blocked_input_while_focused ? "true" : "false") .
            "`npotions_drank=" . potions_drank .
            "`ntotal_run_time=" . Floor(total_run_time_ms / 1000) .
            "`ntotal_paused=" . Floor(total_paused_ms / 1000) .
            "`ntime_since_last_potion=" . Floor(time_since_last_potion / 1000) .
            "`nraid_duration_initial=" . Floor(raid_duration_initial_ms / 1000) .
            "`nraid_duration_initial_adjusted=" . Floor(raid_duration_initial_adjusted_ms / 1000) .
            "`nwaits_until_raid_done=" . waits_until_raid_done_ms_str .
            "`nwait_until_raid_done_worstcase_ms=" . Floor(wait_until_raid_done_worstcase_ms / 1000) .
            "`nsleep_until_check_raid_done_multiplier=" . RegExReplace(Format("{:.2f}", sleep_until_check_raid_done_multiplier), "^0", "") .
            "`nsleep_until_check_raid_done_initial=" . Floor(sleep_until_check_raid_done_initial_ms / 1000) .
            "`nsleep_until_check_raid_done=" . Floor(sleep_until_check_raid_done_ms / 1000) .
            "`nblock_input_override_dbg=" . (block_input_override_dbg ? "true" : "false") .
            "`ndetected_potion_dbg=" . (detected_potion_dbg ? "true" : "false") .
            "`nright click may fix mouse" .
            "`nalt+u to inc raid duration" .
            "`nalt+i to dec raid duration" .
            "`nalt+b toggle block_input_override_dbg" .
            "`nalt+p toggle pause" .
            "`nesc to quit",
            w_win,
            h_win,
        )
    } else {
        tool_tip.Clear()
    }

}

PressKeysWithDelay(keys, post_key_sleep_duration_ms := 200) {
    for (_, key in keys) {
        Send(key)
        Sleep(post_key_sleep_duration_ms)
    }
}

CurrentTick() {
    return A_TickCount - total_paused_ms
}

;; @pre window is focused (probably needs to be maximized too)
;; @pre not in any menu
;; @pre input is blocked
IsRaidOngoing(w_win, h_win) {
    ratio_raid_health_near_0_percent := ratios_raid_health[1]
    rgb_raid_health_near_0_percent := GetRatioColor(w_win, h_win, ratio_raid_health_near_0_percent.x, ratio_raid_health_near_0_percent.y)
    if (rgb_raid_health_near_0_percent == rgb_raid_health_empty) {
        return true
    } else if (rgb_raid_health_near_0_percent == rgb_raid_health_full) {
        return true
    } else {
        return false
    }
}

;; @note side effect: function returns with inputs still blocked by BlockInputWithOverrideDbg(true)
WaitUntilRaidDoneThenReadyMinecraftForInputs() {
    global blocked_input
    global blocked_input_while_focused
    global sleep_until_check_raid_done_ms
    global wait_until_raid_done_worstcase_ms
    global waits_until_raid_done_ms

    prev_title := "DO_NOT_SWITCH_FOCUS"
    wait_until_raid_done_worstcase_ms := (waits_until_raid_done_ms.Length > 0) ? Max(waits_until_raid_done_ms*) : wait_until_raid_done_worstcase_ms
    last_loop_iteration_was_raid_known_to_be_ongoing := false
    start_time_wait_until_raid_done := A_TickCount
    start_time_wait_until_raid_done_toal_pause_ms := total_paused_ms
    sleep_until_check_raid_done_ms := (waits_until_raid_done_ms.Length > 0) ? (Min(waits_until_raid_done_ms*) * sleep_until_check_raid_done_multiplier) : sleep_until_check_raid_done_ms
    if (potions_drank != 0) {
        Sleep(sleep_until_check_raid_done_ms)
    }

    blocked_input_while_focused := true
    while ((A_TickCount - start_time_wait_until_raid_done) < wait_until_raid_done_worstcase_ms) {
        if (WinActive(title_minecraft)) {
            BlockInputWithOverrideDbg(true)
            MaximizeAndFocusWindow(title_minecraft) ; if minecraft became inactive just override the new window
            WinGetPos(&x_win, &y_win, &w_win, &h_win, title_minecraft)
            CloseMenus(w_win, h_win)
            if (!IsRaidOngoing(w_win, h_win)) {
                if (last_loop_iteration_was_raid_known_to_be_ongoing && (potions_drank != 0) && (start_time_wait_until_raid_done_toal_pause_ms == total_paused_ms)) {
                    waits_until_raid_done_ms.Push(A_TickCount - start_time_wait_until_raid_done)
                }
                blocked_input := true
                blocked_input_while_focused := false
                return prev_title
            }
            last_loop_iteration_was_raid_known_to_be_ongoing := true
            BlockInputWithOverrideDbg(false)
        } else {
            last_loop_iteration_was_raid_known_to_be_ongoing := false
        }
        Sleep(sleep_between_blocking_raid_completion_checks)
    }

    BlockInputWithOverrideDbg(true)
    blocked_input := true
    blocked_input_while_focused := false

    if (!WinActive(title_minecraft)) {
        try {
            prev_title := WinGetTitle("A")
        } catch {
            prev_title := "DO_NOT_SWITCH_FOCUS"
        }
    }

    MaximizeAndFocusWindow(title_minecraft)
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_minecraft)
    CloseMenus(w_win, h_win)

    time_since_last_depleted_raid_health_ms := CurrentTick()
    ratio_raid_health_near_0_percent := ratios_raid_health[1]
    last_loop_iteration_was_raid_known_to_be_ongoing := false
    loop {
        if ((CurrentTick() - time_since_last_depleted_raid_health_ms) > time_since_last_depleted_raid_health_timeout_ms) {
            MsgBox("ERROR: Raid health bar seems stuck, is the raid killer working?")
            ExitApp(1)
        }
        Sleep(200)

        rgb_raid_health_near_0_percent := GetRatioColor(w_win, h_win, ratio_raid_health_near_0_percent.x, ratio_raid_health_near_0_percent.y)
        if (rgb_raid_health_near_0_percent == rgb_raid_health_empty) {
            time_since_last_depleted_raid_health_ms := CurrentTick()
            last_loop_iteration_was_raid_known_to_be_ongoing := true
        } else if (rgb_raid_health_near_0_percent == rgb_raid_health_full) {
            last_loop_iteration_was_raid_known_to_be_ongoing := true
        } else {
            if (last_loop_iteration_was_raid_known_to_be_ongoing && (potions_drank != 0) && (start_time_wait_until_raid_done_toal_pause_ms == total_paused_ms)) {
                waits_until_raid_done_ms.Push(A_TickCount - start_time_wait_until_raid_done)
            }
            return prev_title
        }
    }
}

;; @pre window is focused (probably needs to be maximized too)
;; @pre not in any menu
;; @pre right click would drink potion rather than open menu or interact with object (e.g. lever)
DrinkPotion(w_win, h_win) {
    PressKeysWithDelay(["e"], menu_open_delay_ms) ; open menu

    ;; move mouse to position to remove item description
    MoveMouseWindowRatio(title_minecraft, ratios_hotbar[9].x, ratios_armor[4].y)
    Sleep(post_key_sleep_duration_ms)
    MoveMouseWindowRatio(title_minecraft, ratios_hotbar[9].x, ratios_armor[4].y - 0.000010) ; move up to trigger description disappearing
    Sleep(move_mouse_to_clear_item_description_delay_ms)

    if (!ratio_rgbs_inventory_menu.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        MsgBox("ERROR: Failed to open inventory menu (or unexpected pixel colors, like window too small or wrong addon configuration)")
        ExitApp(1)
    }

    if (detected_potion_dbg) {
        MsgBoxDetectedPotionsDbg(w_win, h_win)
    }

    ;; equip potion into hotbar slot 1
    potion_found := false
    if (ratio_rgbs_potions[1].DoesWindowMatchRatioRgbs(w_win, h_win)) {
        potion_found := true
        Sleep(equip_potion_duration_ms)
    } else {
        Loop ratio_rgbs_potions.Length - 1 {
            rgb_ratio := ratio_rgbs_potions[A_Index + 1]
            if (rgb_ratio.DoesWindowMatchRatioRgbs(w_win, h_win)) {
                potion_found := true
                ClickMouseWindowRatio(title_minecraft, rgb_ratio.x_ratios[1], rgb_ratio.y_ratios[1])
                Sleep(500) ; prevent accumulating same type item
                ClickMouseWindowRatio(title_minecraft, ratios_hotbar[1].x, ratios_hotbar[1].y)
                Sleep(500) ; prevent accumulating same type item
                ClickMouseWindowRatio(title_minecraft, rgb_ratio.x_ratios[1], rgb_ratio.y_ratios[1])
                Sleep(post_key_sleep_duration_ms)
                break
            }
        }
    }

    if (!potion_found) {
        MsgBox("INFO: player has no potions (or unexpected pixel colors, like window too small or wrong addon configuration)")
        ExitApp(0)
    }

    PressKeysWithDelay(["e", "1"], post_key_sleep_duration_ms) ; close menu then switch to hotbar slot 1

    if (!ratio_rgbs_not_in_menu_position_word.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        MsgBox("ERROR: Attempt to close menu seems to have failed (Position keyword should be on top left), aborting")
        ExitApp(1)
    }

    PressKeysWithDelay(["{RButton down}"], potion_drink_duration_ms)
    PressKeysWithDelay(["{RButton up}"], post_key_sleep_duration_ms)

    if (!ratio_rgbs_not_in_menu_position_word.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        MsgBox("ERROR: Attempt to drink potion seems to have opened a menu (Position keyword should be on top left), aborting")
        ExitApp(1)
    }
}

CloseMenus(w_win, h_win) {
    Sleep(300) ; maybe esc is more robust with this wait?
    if (ratio_rgbs_start_menu.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        PressKeysWithDelay(["{Esc}"], esc_wait_duration_ms)
    } else {
        Sleep(esc_wait_duration_ms)
    }
    if (ratio_rgbs_inventory_menu.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        PressKeysWithDelay(["e"], post_key_sleep_duration_ms)
    } else {
        Sleep(post_key_sleep_duration_ms)
    }
    if (ratio_rgbs_chest_or_unknown_menu.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        PressKeysWithDelay(["e"], post_key_sleep_duration_ms)
    } else {
        Sleep(post_key_sleep_duration_ms)
    }
    if (!ratio_rgbs_not_in_menu_position_word.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        MsgBox("ERROR: Expected to not be in any type of menu (Position keyword should be on top left), aborting")
        ExitApp(1)
    }
}

block_input_override_dbg := false
detected_potion_dbg := false

calculate_raid_duration_initial_adjusted_ms := () => Max(0, raid_duration_initial_ms - (post_key_sleep_duration_ms * 7) - time_to_look_fully_up_ms - menu_open_delay_ms - move_mouse_to_clear_item_description_delay_ms - equip_potion_duration_ms - potion_drink_duration_ms - esc_wait_duration_ms)

title_minecraft := "Minecraft"
tool_tip := ToolTipCfg("dr", 1)
start_time_ms := A_TickCount

startup_delay_ms := 4000
post_key_sleep_duration_ms := 200
menu_open_delay_ms := 500
potion_drink_duration_ms := 2300
esc_wait_duration_ms := 1000
raid_duration_initial_ms := 300000
raid_duration_min_increment_ms := 5000
equip_potion_duration_ms := 1500
move_mouse_to_clear_item_description_delay_ms := 1000
sleep_between_blocking_raid_completion_checks := 1000
sleep_until_check_raid_done_initial_ms := 180000
sleep_until_check_raid_done_multiplier := 0.9
time_since_last_depleted_raid_health_timeout_ms := 300000
time_to_look_fully_up_ms := 1500
time_since_last_potion_min_ms := 100000

;; global variables that can be written to by functions
potions_drank := 0
time_of_last_potion_ms := ""
raid_duration_initial_adjusted_ms := calculate_raid_duration_initial_adjusted_ms()
wait_until_raid_done_worstcase_ms := raid_duration_initial_adjusted_ms
waits_until_raid_done_ms := CircularBuffer(10)
sleep_until_check_raid_done_ms := sleep_until_check_raid_done_initial_ms
paused := false
blocked_input := false
blocked_input_while_focused := false
total_paused_ms := 0
current_paused_ms := 0

Sleep(startup_delay_ms)
SetTimer(ShowTooltip, 1000)

Loop 100000 {
    prev_title := WaitUntilRaidDoneThenReadyMinecraftForInputs()

    ;; look up in minecraft, inputs need to be sent this way for more consistency
    start_lookup_time_ms := CurrentTick()
    while ((CurrentTick() - start_lookup_time_ms) < time_to_look_fully_up_ms) {
        Loop 30 {
            DllCall("mouse_event", "UInt", 0x0001, "Int", 0, "Int", -100, "UInt", 0, "UPtr", 0) ; move up
            Sleep 50
        }
    }

    if ((potions_drank != 0) && ((A_TickCount - time_of_last_potion_ms) < time_since_last_potion_min_ms)) {
        MsgBox("ERROR: time_since_last_potion=" . (A_TickCount - time_of_last_potion_ms) . " not less than time_since_last_potion_min_ms=" . time_since_last_potion_min_ms)
        ExitApp(1)
    }

    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_minecraft)
    DrinkPotion(w_win, h_win)
    time_of_last_potion_ms := A_TickCount
    potions_drank += 1

    PressKeysWithDelay(["2"], post_key_sleep_duration_ms) ; switch to hotbar 2 for looting sword or item to heal with mending

    if (prev_title != "DO_NOT_SWITCH_FOCUS") {
        FocusWindow(prev_title)
    }

    BlockInputWithOverrideDbg(false)
    blocked_input := false
    blocked_input_while_focused := false
}

$!u:: {
    if (WinActive(title_minecraft)) {
        global raid_duration_initial_ms
        global raid_duration_initial_adjusted_ms
        raid_duration_initial_ms += raid_duration_min_increment_ms
        raid_duration_initial_adjusted_ms := calculate_raid_duration_initial_adjusted_ms()
    }
}

$!i:: {
    if (WinActive(title_minecraft)) {
        global raid_duration_initial_ms
        global raid_duration_initial_adjusted_ms
        raid_duration_initial_ms := Max(0, raid_duration_initial_ms - raid_duration_min_increment_ms)
        raid_duration_initial_adjusted_ms := calculate_raid_duration_initial_adjusted_ms()
    }
}

$!b:: {
    global block_input_override_dbg
    block_input_override_dbg := !block_input_override_dbg
}

$!p:: {
    global paused
    global current_paused_ms
    global total_paused_ms

    if (paused) {
        total_paused_ms += A_TickCount - current_paused_ms
        current_paused_ms := 0
    } else {
        current_paused_ms := A_TickCount
    }

    paused := !paused
    ShowTooltip()
    Pause(-1)
}

$Esc:: ExitApp
