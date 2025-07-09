#include <window-utils>

CreateRatiosInventory() {
    ratios_inventory := []
    Loop 3 { ; loop over rows
        row_index := A_Index
        ratios_inventory.Push([])
        Loop 9 { ; loop over cols
            col_index := A_Index
            x := (col_index - 1) * inventory_col_width + inventory_col_1_x
            y := (row_index - 1) * inventory_row_height + inventory_row_1_y
            ratios_inventory[row_index].Push({ x: x, y: y })
        }
    }
    return ratios_inventory
}

CreateRatiosHotbar() {
    hotbar_col_1_x := inventory_col_1_x
    hotbar_col_9_x := inventory_col_9_x  ; unused
    hotbar_row_y := 0.774882

    hotbar_col_width := inventory_col_width

    ratios_hotbar := []
    Loop 9 { ; loop over cols
        col_index := A_Index
        x := (col_index - 1) * hotbar_col_width + hotbar_col_1_x
        y := hotbar_row_y
        ratios_hotbar.Push({ x: x, y: y })
    }
    return ratios_hotbar
}

CreateRatiosArmor() {
    armor_col_x := inventory_col_1_x
    armor_row_1_y := 0.250711
    armor_row_4_y := 0.461137

    armor_row_height := inventory_row_height

    ratios_armor := []
    Loop 4 { ; loop over rows
        col_index := A_Index
        x := armor_col_x
        y := (A_Index - 1) * armor_row_height + armor_row_1_y
        ratios_armor.Push({ x: x, y: y })
    }
    return ratios_armor
}

CreateRatiosChestInventory() {
    chest_inventory_row_1_y := 0.557820
    chest_inventory_col_1_x := 0.558294

    chest_inventory_row_height := inventory_row_height
    chest_inventory_col_width := inventory_col_width

    ratios_chest_inventory := []
    Loop 3 { ; loop over rows
        row_index := A_Index
        ratios_chest_inventory.Push([])
        Loop 9 { ; loop over cols
            col_index := A_Index
            x := (col_index - 1) * chest_inventory_col_width + chest_inventory_col_1_x
            y := (row_index - 1) * chest_inventory_row_height + chest_inventory_row_1_y
            ratios_chest_inventory[row_index].Push({ x: x, y: y })
        }
    }
    return ratios_chest_inventory
}

CreateRatiosChestStorage() {
    chest_storage_row_1_y := 0.557820
    chest_storage_col_1_x := 0.558294

    chest_storage_row_height := inventory_row_height
    chest_storage_col_width := inventory_col_width

    ratios_chest_storage := []
    Loop 3 { ; loop over rows
        row_index := A_Index
        ratios_chest_storage.Push([])
        Loop 9 { ; loop over cols
            col_index := A_Index
            x := (col_index - 1) * chest_storage_col_width + chest_storage_col_1_x
            y := (row_index - 1) * chest_storage_row_height + chest_storage_row_1_y
            ratios_chest_storage[row_index].Push({ x: x, y: y })
        }
    }
    return ratios_chest_storage
}

CreateRatioRGBsInventoryMenu() {
    ratio_x_inventory_menu_crafting_page_left_edge := 0.168566
    ratio_rgb_inventory_menu_crafting_page_left_edge := 0x535353
    ratios_x_inventory_menu := [ratio_x_inventory_menu_crafting_page_left_edge]
    ratios_y_inventory_menu := [ratios_hotbar[1].y]
    ratios_rgb_inventory_menu := [ratio_rgb_inventory_menu_crafting_page_left_edge]
    for (_, row in ratios_inventory) {
        ratios_x_inventory_menu.Push(ratio_x_inventory_menu_crafting_page_left_edge)
        ratios_y_inventory_menu.Push(row[1].y)
        ratios_rgb_inventory_menu.Push(ratio_rgb_inventory_menu_crafting_page_left_edge)
    }
    for (_, ratio in ratios_armor) {
        ratios_x_inventory_menu.Push(ratio_x_inventory_menu_crafting_page_left_edge)
        ratios_y_inventory_menu.Push(ratio.y)
        ratios_rgb_inventory_menu.Push(ratio_rgb_inventory_menu_crafting_page_left_edge)
    }
    return RatioRgbs(ratios_x_inventory_menu, ratios_y_inventory_menu, ratios_rgb_inventory_menu)
}

CreateRatioRGBsChestOrUnknownMenu() {
    ratio_x_chest_or_unknown_menu := 0.325738
    ratio_rgb_chest_or_unknown_menu := 0x535353

    ratios_x_chest_or_unknown_menu := []
    ratios_y_chest_or_unknown_menu := []
    ratios_rgbs_chest_or_unknown_menu := []
    for (_, row in ratios_chest_inventory) {
        ratios_x_chest_or_unknown_menu.Push(ratio_x_chest_or_unknown_menu)
        ratios_y_chest_or_unknown_menu.Push(row[1].y)
        ratios_rgbs_chest_or_unknown_menu.Push(ratio_rgb_chest_or_unknown_menu)
    }
    for (_, row in ratios_chest_storage) {
        ratios_x_chest_or_unknown_menu.Push(ratio_x_chest_or_unknown_menu)
        ratios_y_chest_or_unknown_menu.Push(row[1].y)
        ratios_rgbs_chest_or_unknown_menu.Push(ratio_rgb_chest_or_unknown_menu)
    }
    return RatioRgbs(ratios_x_chest_or_unknown_menu, ratios_y_chest_or_unknown_menu, ratios_rgbs_chest_or_unknown_menu)
}

CreateRatioRGBsPotions() {
    rgb_ominous_potion_center_purple := 0xa26298
    rgb_ominous_potion_center_cork_bottom := 0x7e453c
    rgb_ominous_potion_center_cork_top := 0xd09476

    ominous_potion_center_cork_bottom_y_offset := 0.543128 - ratios_inventory[1][1].y
    ominous_potion_center_cork_top_y_offset := 0.535545 - ratios_inventory[1][1].y

    ratio_rgbs_potions := []
    for (_, ratio in ratios_hotbar) {
        ratio_rgbs_potions.Push(RatioRgbs([ratio.x, ratio.x, ratio.x], [ratio.y, ratio.y + ominous_potion_center_cork_bottom_y_offset, ratio.y + ominous_potion_center_cork_top_y_offset], [rgb_ominous_potion_center_purple, rgb_ominous_potion_center_cork_bottom, rgb_ominous_potion_center_cork_top]))
    }
    for (_, row in ratios_inventory) {
        for (_, ratio in row) {
            ratio_rgbs_potions.Push(RatioRgbs([ratio.x, ratio.x, ratio.x], [ratio.y, ratio.y + ominous_potion_center_cork_bottom_y_offset, ratio.y + ominous_potion_center_cork_top_y_offset], [rgb_ominous_potion_center_purple, rgb_ominous_potion_center_cork_bottom, rgb_ominous_potion_center_cork_top]))
        }
    }
    return ratio_rgbs_potions
}

inventory_row_1_y := 0.557820
inventory_row_3_y := 0.694313
inventory_col_1_x := 0.503366
inventory_col_9_x := 0.801657

inventory_row_height := (inventory_row_3_y - inventory_row_1_y) / 2
inventory_col_width := (inventory_col_9_x - inventory_col_1_x) / 8

ratios_inventory := CreateRatiosInventory()
ratios_hotbar := CreateRatiosHotbar()
ratios_armor := CreateRatiosArmor()
ratios_chest_inventory := CreateRatiosChestInventory()
ratios_chest_storage := CreateRatiosChestStorage()

ratio_left_hand_equip_slot := { x: ratios_inventory[1][5].x, y: ratios_armor[4].y }

;; maybe dependent on dark mode addon
ratio_rgbs_inventory_menu := CreateRatioRGBsInventoryMenu()
ratio_rgbs_chest_or_unknown_menu := CreateRatioRGBsChestOrUnknownMenu()
ratio_rgbs_start_menu := RatioRgbs([0.715432, 0.753755, 0.800621, 0.854997, 0.899016, 0.952615], [0.040758, 0.040758, 0.040758, 0.040758, 0.040758, 0.040758], [0x6b6b6b, 0x6b6b6b, 0x6b6b6b, 0x6b6b6b, 0x6b6b6b, 0x6b6b6b]) ; topright corner of screen

ratio_rgbs_potions := CreateRatioRGBsPotions()
