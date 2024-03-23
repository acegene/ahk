#include <array-utils>
#include <misc-utils>
#include <mouse-utils>
#include <window-utils>

GetAbilityX(index) {
    switch index {
        case 1: return 0.397177
        case 2: return 0.495565
        case 3: return 0.597177
        case 4: return 0.697177
        default: MsgBox("ERROR: GetAbilityX(): unexpected input: index=" . index)
    }
}

GetAbilityXTolerance() {
    return 0.01
}

GetAbilityYTolerance() {
    return 0.01
}

GetAbilityY() {
    return 0.425000
}

GetHandX(size, index) {
    switch size {
        case 1: GetHandX(5, index + 2)
        case 2: GetHandX(4, index + 1)
        case 3: GetHandX(5, index + 1)
        case 4:
            switch index {
                case 1: return 0.396635
                case 2: return 0.468349
                case 3: return 0.542869
                case 4: return 0.608173
            }
        case 5:
            switch index {
                case 1: return 0.387097
                case 2: return 0.440323
                case 3: return 0.488710
                case 4: return 0.542339
                case 5: return 0.608871
                default: MsgBox("ERROR: GetHandX(): unexpected input: index=" . index)
            }
        case 6:
            switch index {
                case 1: return 0.389516
                case 2: return 0.431452
                case 3: return 0.465726
                case 4: return 0.518145
                case 5: return 0.553226
                case 6: return 0.610887
                default: MsgBox("ERROR: GetHandX(): unexpected input: index=" . index)
            }
        default: MsgBox("ERROR: GetHandX(): unexpected input: size=" . size)
    }
}

GetHandY() {
    return 0.912775
}

GetMinionX(size, index) {
    switch size {
        case 1: return GetMinionX(5, index + 2)
        case 2: return GetMinionX(6, index + 2)
        case 3: return GetMinionX(5, index + 1)
        case 4: return GetMinionX(6, index + 1)
        case 5:
            switch index {
                case 1: return 0.340000
                case 2: return 0.410000
                case 3: return 0.500000
                case 4: return 0.584000
                case 5: return 0.677000
                default: MsgBox("ERROR: GetMinionX(): unexpected input: index=" . index)
            }
        case 6:
            switch index {
                case 1: return 0.287904
                case 2: return 0.373290
                case 3: return 0.457581
                case 4: return 0.544609
                case 5: return 0.627805
                case 6: return 0.712644
                default: MsgBox("ERROR: GetMinionX(): unexpected input: index=" . index)
            }
        default: MsgBox("ERROR: GetMinionX(): unexpected input: size=" . size)
    }
}

GetMinionXTolerance() {
    return 0.001
}

GetMinionYTolerance() {
    return 0.02
}

GetFriendlyX(size, index) {
    return GetMinionX(size, index)
}

GetFriendlyXTolerance() {
    return GetMinionXTolerance()
}

GetFriendlyY() {
    return 0.633424
}

GetFriendlyYTolerance() {
    return GetMinionYTolerance()
}

GetEnemyX(size, index) {
    return GetMinionX(size, index) + 0.02 ; TODO: offset to handle when between minions
}

GetEnemyXTolerance() {
    return GetMinionXTolerance()
}

GetEnemyY() {
    return 0.265938
}

GetEnemyYTolerance() {
    return GetMinionYTolerance()
}

GetChoiceX(index) {
    switch index {
        case 1: return 0.42
        case 2: return 0.58
        default: MsgBox("ERROR: GetChoiceX(): unexpected input: index=" . index)
    }
}

GetChoiceY() {
    return 0.451658
}

GetChoiceXTolerance() {
    return 0.01
}

GetChoiceYTolerance() {
    return 0.01
}

ClickFriendlyTarget(index, size) {
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, GetFriendlyX(size, index), GetFriendlyY(), GetFriendlyXTolerance(), GetFriendlyYTolerance(), "L", 100)
}

ClickEnemyTarget(index, size) {
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, GetEnemyX(size, index), GetEnemyY(), GetEnemyXTolerance(), GetEnemyYTolerance(), "L", 100)
}

ClickChoice(index) {
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, GetChoiceX(index), GetChoiceY(), GetChoiceXTolerance(), GetChoiceYTolerance(), "L", 100)
}


UseUntargetingAbility(index) {
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, GetAbilityX(index), GetAbilityY(), GetAbilityXTolerance(), GetAbilityYTolerance(), "L", 100)
    SleepRandom(1500)
}

UseEnemyTargetingAbility(index_ability, index_enemy, size := 3) {
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, GetAbilityX(index_ability), GetAbilityY(), GetAbilityXTolerance(), GetAbilityYTolerance(), "L", 100)
    SleepRandom(500)
    ClickEnemyTarget(index_enemy, size)
    SleepRandom(1000)
}

UseFriendlyTargetingAbility(index_ability, IndexFriendly, size := 3) {
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, GetAbilityX(index_ability), GetAbilityY(), GetAbilityXTolerance(), GetAbilityYTolerance(), "L", 100)
    SleepRandom(500)
    ClickFriendlyTarget(IndexFriendly, size)
    SleepRandom(1000)
}

UseChooseOneAbility(index_ability, IndexChoice) {
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, GetAbilityX(index_ability), GetAbilityY(), GetAbilityXTolerance(), GetAbilityYTolerance(), "L", 100)
    SleepRandom(500)
    ClickChoice(IndexChoice)
    SleepRandom(1000)
}

PressReady() {
    static x_ratio_ready := 0.817318
    static y_ratio_ready := 0.438069
    static x_ratio_ready_tolerance := 0.01
    static y_ratio_ready_tolerance := 0.02
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, x_ratio_ready, y_ratio_ready, x_ratio_ready_tolerance, y_ratio_ready_tolerance, "L", 100)
    SleepRandom(500)
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, x_ratio_ready, y_ratio_ready, x_ratio_ready_tolerance, y_ratio_ready_tolerance, "L", 100)
}

PlayFromHand(Index, Size) {
    ;; TODO: handle position > Size
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, GetHandX(Size, Index), GetHandY(), 0.01, 0.05, "L", 100)
    SleepRandom(300)
    ClickMouseWindowRatioRngRangeXY(title_hearthstone, 0.217949, 0.364011, 0.1, 0.1) ; play on board to left of minion, "L", 100s
    SleepRandom(300)
}

PlayFromHandPhase(index1, index2, index3, size := 6) {
    ;; TODO: handle throw if inputs equal
    index2_adjusted := index3 < index2 ? index2 - 1 : index2
    if (index3 < index1) {
        index1_adjusted := index2 < index1 ? index1 - 2 : index1 - 1
    } else {
        index1_adjusted := index2 < index1 ? index1 - 1 : index1
    }
    PlayFromHand(index3, size)
    PlayFromHand(index2_adjusted, size - 1)
    PlayFromHand(index1_adjusted, size - 2)
    SleepRandom(1000)
    PressReady()
    SleepRandom(10000)
}

GetActionlessFriendlies(size := "") {
    ;; assumption: distance between minions is constant no matter size of party
    static rgb_actionless_dot := 0x000000
    ; static y_ratio_actionless_dot := 0.561931 ;; 6 mins
    ; static y_ratio_actionless_dot := 0.561020 ;; 101100
    static y_ratio_actionless_dot := 0.562386 ;; 6 mins

    static x_ratio_minion_1_of_6_dot_1_of_3 := 0.301574
    static x_ratio_minion_1_of_6_dot_2_of_3 := 0.307003
    static x_ratio_minion_6_of_6_dot_1_of_3 := 0.729642

    static x_ratio_dot_offset := x_ratio_minion_1_of_6_dot_2_of_3 - x_ratio_minion_1_of_6_dot_1_of_3
    static x_ratio_minion_offset := (x_ratio_minion_6_of_6_dot_1_of_3 - x_ratio_minion_1_of_6_dot_1_of_3) / 5.0
    static x_ratio_minion_offset_odd_vs_even := 0.041803

    static x_ratio_minion_1_of_5_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_minion_offset_odd_vs_even
    static x_ratio_minion_1_of_5_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + x_ratio_minion_offset_odd_vs_even
    static x_ratio_minion_1_of_5_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + x_ratio_minion_offset_odd_vs_even
    static ratio_rgb_minion_1_of_5_actionless := RatioRgbs([x_ratio_minion_1_of_5_dot_1_of_3, x_ratio_minion_1_of_5_dot_2_of_3, x_ratio_minion_1_of_5_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    static x_ratio_minion_2_of_5_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_minion_offset_odd_vs_even + x_ratio_minion_offset
    static x_ratio_minion_2_of_5_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + x_ratio_minion_offset_odd_vs_even + x_ratio_minion_offset
    static x_ratio_minion_2_of_5_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + x_ratio_minion_offset_odd_vs_even + x_ratio_minion_offset
    static ratio_rgb_minion_2_of_5_actionless := RatioRgbs([x_ratio_minion_2_of_5_dot_1_of_3, x_ratio_minion_2_of_5_dot_2_of_3, x_ratio_minion_2_of_5_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    static x_ratio_minion_3_of_5_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_minion_offset_odd_vs_even + (2 * x_ratio_minion_offset)
    static x_ratio_minion_3_of_5_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + x_ratio_minion_offset_odd_vs_even + (2 * x_ratio_minion_offset)
    static x_ratio_minion_3_of_5_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + x_ratio_minion_offset_odd_vs_even + (2 * x_ratio_minion_offset)
    static ratio_rgb_minion_3_of_5_actionless := RatioRgbs([x_ratio_minion_3_of_5_dot_1_of_3, x_ratio_minion_3_of_5_dot_2_of_3, x_ratio_minion_3_of_5_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    static x_ratio_minion_4_of_5_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_minion_offset_odd_vs_even + (3 * x_ratio_minion_offset)
    static x_ratio_minion_4_of_5_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + x_ratio_minion_offset_odd_vs_even + (3 * x_ratio_minion_offset)
    static x_ratio_minion_4_of_5_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + x_ratio_minion_offset_odd_vs_even + (3 * x_ratio_minion_offset)
    static ratio_rgb_minion_4_of_5_actionless := RatioRgbs([x_ratio_minion_4_of_5_dot_1_of_3, x_ratio_minion_4_of_5_dot_2_of_3, x_ratio_minion_4_of_5_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    static x_ratio_minion_5_of_5_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_minion_offset_odd_vs_even + (4 * x_ratio_minion_offset)
    static x_ratio_minion_5_of_5_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + x_ratio_minion_offset_odd_vs_even + (4 * x_ratio_minion_offset)
    static x_ratio_minion_5_of_5_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + x_ratio_minion_offset_odd_vs_even + (4 * x_ratio_minion_offset)
    static ratio_rgb_minion_5_of_5_actionless := RatioRgbs([x_ratio_minion_5_of_5_dot_1_of_3, x_ratio_minion_5_of_5_dot_2_of_3, x_ratio_minion_5_of_5_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    ; static x_ratio_minion_1_of_6_dot_1_of_3 ; see above
    ; static x_ratio_minion_1_of_6_dot_2_of_3 ; see above
    static x_ratio_minion_1_of_6_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset)
    static ratio_rgb_minion_1_of_6_actionless := RatioRgbs([x_ratio_minion_1_of_6_dot_1_of_3, x_ratio_minion_1_of_6_dot_2_of_3, x_ratio_minion_1_of_6_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    static x_ratio_minion_2_of_6_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_minion_offset
    static x_ratio_minion_2_of_6_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + x_ratio_minion_offset
    static x_ratio_minion_2_of_6_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + x_ratio_minion_offset
    static ratio_rgb_minion_2_of_6_actionless := RatioRgbs([x_ratio_minion_2_of_6_dot_1_of_3, x_ratio_minion_2_of_6_dot_2_of_3, x_ratio_minion_2_of_6_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    static x_ratio_minion_3_of_6_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_minion_offset)
    static x_ratio_minion_3_of_6_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + (2 * x_ratio_minion_offset)
    static x_ratio_minion_3_of_6_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + (2 * x_ratio_minion_offset)
    static ratio_rgb_minion_3_of_6_actionless := RatioRgbs([x_ratio_minion_3_of_6_dot_1_of_3, x_ratio_minion_3_of_6_dot_2_of_3, x_ratio_minion_3_of_6_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    static x_ratio_minion_4_of_6_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (3 * x_ratio_minion_offset)
    static x_ratio_minion_4_of_6_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + (3 * x_ratio_minion_offset)
    static x_ratio_minion_4_of_6_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + (3 * x_ratio_minion_offset)
    static ratio_rgb_minion_4_of_6_actionless := RatioRgbs([x_ratio_minion_4_of_6_dot_1_of_3, x_ratio_minion_4_of_6_dot_2_of_3, x_ratio_minion_4_of_6_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    static x_ratio_minion_5_of_6_dot_1_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (4 * x_ratio_minion_offset)
    static x_ratio_minion_5_of_6_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + (4 * x_ratio_minion_offset)
    static x_ratio_minion_5_of_6_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + (4 * x_ratio_minion_offset)
    static ratio_rgb_minion_5_of_6_actionless := RatioRgbs([x_ratio_minion_5_of_6_dot_1_of_3, x_ratio_minion_5_of_6_dot_2_of_3, x_ratio_minion_5_of_6_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    ; static x_ratio_minion_6_of_6_dot_1_of_3 ; see above
    static x_ratio_minion_6_of_6_dot_2_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + x_ratio_dot_offset + (5 * x_ratio_minion_offset)
    static x_ratio_minion_6_of_6_dot_3_of_3 := x_ratio_minion_1_of_6_dot_1_of_3 + (2 * x_ratio_dot_offset) + (5 * x_ratio_minion_offset)
    static ratio_rgb_minion_6_of_6_actionless := RatioRgbs([x_ratio_minion_6_of_6_dot_1_of_3, x_ratio_minion_6_of_6_dot_2_of_3, x_ratio_minion_6_of_6_dot_3_of_3], [y_ratio_actionless_dot, y_ratio_actionless_dot, y_ratio_actionless_dot], [rgb_actionless_dot, rgb_actionless_dot, rgb_actionless_dot])

    SpeedupAnimations(100)
    Sleep(500)

    WinGetPos(&x_win, &y_win, &w_win, &h_win, title_hearthstone)
    if (size = "") {
        odd_offsets := [ratio_rgb_minion_1_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_2_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_3_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_4_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_5_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win)]
        even_offsets := [ratio_rgb_minion_1_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_2_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_3_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_4_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_5_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_6_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win)]

        odd_offsets_actionless_found := ArrHasVal(odd_offsets, true)
        even_offsets_actionless_found := ArrHasVal(even_offsets, true)

        if (odd_offsets_actionless_found == true and even_offsets_actionless_found == true) {
            MsgBox("ERROR: GetActionlessFriendlies(): actionless found for both odd_offsets and even_offsets`n    odd_offsets=[" . Join(odd_offsets, ", ") . "]`n    even_offsets=[" . Join(even_offsets, ", ") . "]")
            ExitApp(1)
        }
        ; MsgBox("even_offsets=" . Join(even_offsets, ", ") . "`nodd_offsets=" . Join(odd_offsets, ", "))
        if (odd_offsets_actionless_found == true) {
            return odd_offsets
        }
        if (even_offsets_actionless_found == true) {
            return even_offsets
        }
        return []
    } else {
        switch size {
            case 1: return [ratio_rgb_minion_3_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win)]
            case 2: return [ratio_rgb_minion_3_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_4_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win)]
            case 3: return [ratio_rgb_minion_2_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_3_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_4_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win)]
            case 4: return [ratio_rgb_minion_2_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_3_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_4_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_5_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win)]
            case 5: return [ratio_rgb_minion_1_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_2_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_3_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_4_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_5_of_5_actionless.DoesWindowMatchRatioRgbs(w_win, h_win)]
            case 6: return [ratio_rgb_minion_1_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_2_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_3_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_4_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_5_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win), ratio_rgb_minion_6_of_6_actionless.DoesWindowMatchRatioRgbs(w_win, h_win)]
            default: MsgBox("ERROR: GetActionlessFriendlies(): unexpected size=" . size)
        }
    }

    ExitApp(1)
}

GetNumFriendlyMinions() {
    return GetActionlessFriendlies().Length
}

;; @arg comp concat str saying order of members
FarmFire(comp := "rgbs") {
    ;; r=rag g=geddon b=balinda s=summoned-minion
    ClickFriendlyTarget(1, StrLen(comp))
    Sleep(500)
    for (char in StrSplit(comp)) {
        switch char {
            case "r": UseUntargetingAbility(2)
            case "g": UseUntargetingAbility(2)
            case "b": UseEnemyTargetingAbility(1, 2, 3)
            case "s": UseEnemyTargetingAbility(1, 2, 3)
            default: MsgBox("ERROR: FarmFire(): unexpected char=" . char)
        }
    }
    Sleep(1000)
}
