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
 *   * can not be facing any object that can be interacted with by right-clicking
 *   * only known behavior is when in start menu, inventory menu, or no menu
 */

if (!A_IsAdmin) {
    try {
        Run('*RunAs "' A_AhkPath '" "' A_ScriptFullPath '"')
    } catch Error as e {
        MsgBox "ERROR: Failed to restart as admin.`n" e.Message
    }
    ExitApp
}

ShowTooltip(*) {
    if WinActive(title_minecraft) {
        elapsed_time_ms := A_TickCount - start_time_ms
        time_since_last_potion := Max(0, A_TickCount - time_of_last_potion_ms)
        WinGetPos(&x_win, &y_win, &w_win, &h_win, title_minecraft)
        tool_tip.DisplayMsg(
            "paused=" . (paused ? "yes" : "no") .
            "`npotions_drank=" . potions_drank .
            "`nelapsed_time=" . Floor(elapsed_time_ms / 1000) .
            "`ntime_since_last_potion=" . Floor(time_since_last_potion / 1000) .
            "`nraid_duration=" . Floor(raid_duration_ms / 1000) .
            "`nraid_duration_adjusted=" . Floor(raid_duration_adjusted_ms / 1000) .
            "`nright click may fix mouse" .
            "`nalt+u to inc raid duration" .
            "`nalt+i to dec raid duration" .
            "`nalt+p to pause/unpause"
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

DrinkPotion() {
    PressKeysWithDelay(["e"], menu_open_delay_ms) ; open menu

    ;; move mouse to position to remove item description
    MoveMouseWindowRatio(title_minecraft, ratios_hotbar[9].x, ratios_armor[4].y)
    Sleep(move_mouse_to_clear_item_description_delay_ms)

    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_minecraft)
    if (!ratio_rgbs_inventory_menu.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        MsgBox("ERROR: Failed to open inventory menu (or unexpected pixel colors, like window too small or wrong addon configuration)")
        ExitApp(1)
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

    PressKeysWithDelay(["e", "1"], post_key_sleep_duration_ms)
    PressKeysWithDelay(["{RButton down}"], potion_drink_duration_ms)
    PressKeysWithDelay(["{RButton up}"], post_key_sleep_duration_ms)
}

calculate_raid_duration_adjusted_ms := () => Max(0, raid_duration_ms - (post_key_sleep_duration_ms * 3) - menu_open_delay_ms - move_mouse_to_clear_item_description_delay_ms - potion_drink_duration_ms - esc_wait_duration_ms)

title_minecraft := "Minecraft"
tool_tip := ToolTipCfg("dr", 1)
start_time_ms := A_TickCount

startup_delay_ms := 4000
post_key_sleep_duration_ms := 200
menu_open_delay_ms := 500
potion_drink_duration_ms := 2300
esc_wait_duration_ms := 1000
raid_duration_ms := 220000
raid_duration_increment_ms := 5000
equip_potion_duration_ms := 1500
move_mouse_to_clear_item_description_delay_ms := 500

global potions_drank := 0
global time_of_last_potion_ms := 10000000000
global raid_duration_adjusted_ms := calculate_raid_duration_adjusted_ms()
global paused := false

Sleep(startup_delay_ms)
SetTimer(ShowTooltip, 1000)

Loop 100000 {
    BlockInput(true)

    prev_title := "DO_NOT_SWITCH_FOCUS"
    if (!WinActive(title_minecraft)) {
        try {
            prev_title := WinGetTitle("A")
        } catch {
            prev_title := "DO_NOT_SWITCH_FOCUS"
        }
    }

    MaximizeAndFocusWindow(title_minecraft)
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_minecraft)
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
        MsgBox("ERROR: Expected to not be in any type of menu, aborting")
        ExitApp(1)
    }

    DrinkPotion()
    time_of_last_potion_ms := A_TickCount
    potions_drank += 1

    if (prev_title != "DO_NOT_SWITCH_FOCUS") {
        FocusWindow(prev_title)
    }

    BlockInput(false)

    Sleep(raid_duration_adjusted_ms)
}

$!u:: {
    if (WinActive(title_minecraft)) {
        global raid_duration_ms
        global raid_duration_adjusted_ms
        raid_duration_ms += raid_duration_increment_ms
        raid_duration_adjusted_ms := calculate_raid_duration_adjusted_ms()
    }
}

$!i:: {
    if (WinActive(title_minecraft)) {
        global raid_duration_ms
        global raid_duration_adjusted_ms
        raid_duration_ms := Max(0, raid_duration_ms - raid_duration_increment_ms)
        raid_duration_adjusted_ms := calculate_raid_duration_adjusted_ms()
    }
}

$!p:: {
    if (WinActive(title_minecraft)) {
        global paused
        paused := !paused
        ShowTooltip()
        Pause(-1)
    }
}

$Esc:: ExitApp
