#include "%A_ScriptDir%\mmbn-lib\mmbnx-ratio-rgbs.ahk"

#include <keypress-utils>
#include <window-utils>

Mmbn3InitiateChipOrder(w_win, h_win) {
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(400)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(200)
    HoldKeyE("s", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(1500)
    if (!mmbn3_ratio_rgbs_chip_order_menu.DoesWindowMatchRatioRgbs(w_win, h_win)) {
        MsgBox("ERROR: expected to be in chip order menu")
        ExitApp(1)
    }
}

Mmbn3ChipOrderFindAndOrderGuards(find_chip_start_index, chips_per_chip_orders) {
    static starting_index := 1
    static offset_for_chip_to_top := 4
    static chips_per_page_flip := 5
    static duration_chip_order_purchase := 3000

    index_increments_left := find_chip_start_index + offset_for_chip_to_top - starting_index
    while (true) {
        if (index_increments_left >= chips_per_page_flip + offset_for_chip_to_top) {
            HoldKeyE("e", 50)
            index_increments_left -= chips_per_page_flip
            Sleep(100)
        } else {
            break
        }
    }

    Loop index_increments_left {
        HoldKeyE("s", 50)
        Sleep(100)
    }
    Sleep(300)

    find_chip_actual_index := find_chip_start_index
    while (true) {
        if (mmbn3_ratio_rgbs_chip_order_entry_1_guard.DoesWindowMatchRatioRgbs(w_win, h_win)) {
            Loop offset_for_chip_to_top {
                HoldKeyE("w", 50)
                Sleep(100)
            }
            break
        }
        HoldKeyE("s", 50)
        find_chip_actual_index += 1
        Sleep(300)
    }

    RepeatHoldKeyForDurationE("j", 50, duration_chip_order_purchase * chips_per_chip_orders)
    RepeatHoldKeyForDurationE("k", 50, 5000)
    return Map(
        "find_chip_actual_index", find_chip_actual_index,
    )
}

Mmbn3ChipOrderGuards(w_win, h_win, find_chip_start_index, chips_per_chip_orders) {
    Mmbn3InitiateChipOrder(w_win, h_win)
    return Mmbn3ChipOrderFindAndOrderGuards(find_chip_start_index, chips_per_chip_orders)
}
