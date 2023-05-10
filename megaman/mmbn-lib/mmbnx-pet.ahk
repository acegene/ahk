#include "%A_ScriptDir%\mmbn-lib\mmbnx-ratio-rgbs.ahk"
#include "%A_ScriptDir%\mmbn-lib\mmbnx-text.ahk"

#include <geometry-utils>
#include <keypress-utils>
#include <string-utils>

Mmbn3GetPetText(w_win, h_win, text_list) {
    HoldKeyE("enter", 50)
    Sleep(1000)
    ret_dict := Map()
    for (text in text_list) {
        if (text = "bugfrags") {
            ret_dict["bugfrags"] := Integer(Join(mmbn3_digits_pet_bugfrags.GetCharsRow(1, w_win, h_win)))
        } else if (text = "health_current") {
            ret_dict["health_current"] := Integer(Join(mmbn3_digits_pet_health_current.GetCharsRow(1, w_win, h_win)))
        } else if (text = "health_total") {
            ret_dict["health_total"] := Integer(Join(mmbn3_digits_pet_health_total.GetCharsRow(1, w_win, h_win)))
        } else if (text = "zenny") {
            ret_dict["zenny"] := Integer(Join(mmbn3_digits_pet_zenny.GetCharsRow(1, w_win, h_win)))
        } else {
            MsgBox("FATAL: unexpected text=" . text)
            ExitApp(1)
        }
    }
    HoldKeyE("k", 50)
    Sleep(500)
    return ret_dict
}

Mmbn3GetLargestLibraryChipCount(w_win, h_win) {
    HoldKeyE("enter", 50)
    Sleep(1000)
    HoldKeyE("j", 50)
    Sleep(300)
    HoldKeyE("j", 50)
    Sleep(300)
    HoldKeyE("j", 50)
    Sleep(300)
    HoldKeyE("j", 50)
    Sleep(700)
    HoldKeyE("d", 50)
    Sleep(300)
    HoldKeyE("enter", 50)
    Sleep(200)
    HoldKeyE("w", 50)
    Sleep(100)
    HoldKeyE("w", 50)
    Sleep(100)
    HoldKeyE("j", 50)
    Sleep(300)
    ret_val := Join(mmbn3_digits_chip_count.GetCharsRow(1, w_win, h_win), "")
    RepeatHoldKeyForDurationE("k", 50, 2500)
    return ret_val
}

mmbn3_x_ratio_l_pet_zenny_digit_1_edge := 0.603646
mmbn3_x_ratio_r_pet_zenny_digit_1_edge := 0.621615
mmbn3_x_ratio_l_pet_zenny_digit_6_edge := 0.728646
;; mmbn3_x_ratio_r_pet_zenny_digit_6_edge := 0.746615
mmbn3_y_ratio_u_pet_zenny_digit_edge := 0.415741
mmbn3_y_ratio_d_pet_zenny_digit_edge := 0.469907

mmbn3_digit_width := mmbn3_x_ratio_r_pet_zenny_digit_1_edge - mmbn3_x_ratio_l_pet_zenny_digit_1_edge
mmbn3_digit_height := mmbn3_y_ratio_d_pet_zenny_digit_edge - mmbn3_y_ratio_u_pet_zenny_digit_edge
mmbn3_digit_x_displacement := (mmbn3_x_ratio_l_pet_zenny_digit_6_edge - mmbn3_x_ratio_l_pet_zenny_digit_1_edge) / 5.0
mmbn3_rgbs_pet_backgrounds := [mmbn3_rgb_pet_background_blue, mmbn3_rgb_pet_background_white]
mmbn3_pet_zenny_num_rows := 1
mmbn3_pet_zenny_num_columns := 6

mmbn3_digits_pet_zenny := CharGridColorChecker(
    mmbn3_x_ratio_l_pet_zenny_digit_1_edge,
    mmbn3_y_ratio_u_pet_zenny_digit_edge,
    mmbn3_digit_width,
    mmbn3_digit_height,
    0.0,
    mmbn3_digit_x_displacement,
    mmbn3_pet_zenny_num_rows,
    mmbn3_pet_zenny_num_columns,
    mmbn3_digit_check_ratios,
    mmbn3_digit_check_map,
    mmbn3_rgbs_pet_backgrounds,
)

mmbn3_x_ratio_l_pet_bugfrag_digit_1_edge := 0.6 * (mmbn3_x_ratio_l_pet_zenny_digit_6_edge - mmbn3_x_ratio_l_pet_zenny_digit_1_edge) + mmbn3_x_ratio_l_pet_zenny_digit_1_edge
mmbn3_x_ratio_l_pet_bugfrag_digit_4_edge := mmbn3_x_ratio_l_pet_zenny_digit_6_edge + mmbn3_digit_width
mmbn3_y_ratio_u_pet_bugfrag_digit_edge := 0.592592

mmbn3_pet_bugfrag_num_rows := 1
mmbn3_pet_bugfrag_num_columns := 4

mmbn3_digits_pet_bugfrags := CharGridColorChecker(
    mmbn3_x_ratio_l_pet_bugfrag_digit_1_edge,
    mmbn3_y_ratio_u_pet_bugfrag_digit_edge,
    mmbn3_digit_width,
    mmbn3_digit_height,
    0.0,
    mmbn3_digit_x_displacement,
    mmbn3_pet_bugfrag_num_rows,
    mmbn3_pet_bugfrag_num_columns,
    mmbn3_digit_check_ratios,
    mmbn3_digit_check_map,
    mmbn3_rgbs_pet_backgrounds,
)

mmbn3_x_ratio_l_pet_health_current_digit_1_edge := mmbn3_x_ratio_l_pet_zenny_digit_1_edge - (0.4 * (mmbn3_x_ratio_l_pet_zenny_digit_6_edge - mmbn3_x_ratio_l_pet_zenny_digit_1_edge))
mmbn3_y_ratio_u_pet_health_current_digit_edge := 0.237500

mmbn3_pet_health_current_num_rows := 1
mmbn3_pet_health_current_num_columns := 4

mmbn3_digits_pet_health_current := CharGridColorChecker(
    mmbn3_x_ratio_l_pet_health_current_digit_1_edge,
    mmbn3_y_ratio_u_pet_health_current_digit_edge,
    mmbn3_digit_width,
    mmbn3_digit_height,
    0.0,
    mmbn3_digit_x_displacement,
    mmbn3_pet_health_current_num_rows,
    mmbn3_pet_health_current_num_columns,
    mmbn3_digit_check_ratios,
    mmbn3_digit_check_map,
    mmbn3_rgbs_pet_backgrounds,
)

mmbn3_x_ratio_l_pet_health_total_digit_1_edge := mmbn3_x_ratio_l_pet_bugfrag_digit_1_edge
mmbn3_y_ratio_u_pet_health_total_digit_edge := mmbn3_y_ratio_u_pet_health_current_digit_edge

mmbn3_pet_health_total_num_rows := 1
mmbn3_pet_health_total_num_columns := 4

mmbn3_digits_pet_health_total := CharGridColorChecker(
    mmbn3_x_ratio_l_pet_health_total_digit_1_edge,
    mmbn3_y_ratio_u_pet_health_total_digit_edge,
    mmbn3_digit_width,
    mmbn3_digit_height,
    0.0,
    mmbn3_digit_x_displacement,
    mmbn3_pet_health_total_num_rows,
    mmbn3_pet_health_total_num_columns,
    mmbn3_digit_check_ratios,
    mmbn3_digit_check_map,
    mmbn3_rgbs_pet_backgrounds,
)
