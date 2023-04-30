#include <keypress-utils>
#include <window-utils>

x_ratios_chip_order_entry_1_guard := [0.177865, 0.194271, 0.412240, 0.537240, 0.537240, 0.537240, 0.190365, 0.531771, 0.541927]
y_ratios_chip_order_entry_1_guard := [0.144444, 0.129167, 0.144444, 0.123611, 0.141667, 0.161111, 0.147222, 0.161111, 0.161111]
rgbs_chip_order_entry_1_guard := [0x242c2c, 0x242c2c, 0x242c2c, 0x242c2c, 0x242c2c, 0x242c2c, 0xbab697, 0xbab697, 0xbab697]

duration_chip_order_purchase := 3100

Mmbn3IsChipOrderEntry1Guard(w_win, h_win) {
    return AreRatioColorsEqualToColors(w_win, h_win, x_ratios_chip_order_entry_1_guard, y_ratios_chip_order_entry_1_guard, rgbs_chip_order_entry_1_guard)
}

Mmbn3InitiateChipOrder() {
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
}

Mmbn3FindAndOrderChipOrderGuard(find_chip_start_index, chips_per_chip_orders) {
    find_chip_actual_index := find_chip_start_index - 1
    Loop find_chip_start_index - 1 + 4 {
        HoldKeyE("s", 50)
        Sleep(100)
    }
    Sleep(300)
    while (true) {
        if (Mmbn3IsChipOrderEntry1Guard(w_win, h_win)) {
            Loop 4 {
                HoldKeyE("w", 50)
                Sleep(100)
            }
            break
        }
        HoldKeyE("s", 50)
        find_chip_actual_index := find_chip_actual_index + 1
        Sleep(300)
    }

    RepeatHoldKeyForDurationE("j", 50, duration_chip_order_purchase * chips_per_chip_orders)
    RepeatHoldKeyForDurationE("k", 50, 5000)
    return {
        find_chip_actual_index: find_chip_actual_index,
    }
}

Mmbn3ChipOrderGuardLoop(find_chip_start_index, chips_per_chip_orders) {
    Mmbn3InitiateChipOrder()
    return Mmbn3FindAndOrderChipOrderGuard(find_chip_start_index, chips_per_chip_orders)
}
