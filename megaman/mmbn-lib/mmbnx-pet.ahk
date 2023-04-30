#include "%A_ScriptDir%\mmbn-lib\mmbnx-text.ahk"

#include <geometry-utils>
#include <keypress-utils>
#include <string-utils>

GetZenny(w_win, h_win) {
    HoldKeyE("enter", 50)
    Sleep(1000)
    zenny := Integer(Join(mmbn3_digits_pet_zenny.GetCharsRow(1, w_win, h_win)))
    HoldKeyE("k", 50)
    Sleep(500)
    return zenny
}

mmbn3_x_ratio_l_pet_zenny_digit_1_edge := 0.603646
mmbn3_x_ratio_r_pet_zenny_digit_1_edge := 0.621615
mmbn3_x_ratio_l_pet_zenny_digit_6_edge := 0.728646
;; mmbn3_x_ratio_r_pet_zenny_digit_6_edge := 0.746615
mmbn3_y_ratio_u_pet_zenny_digit_edge := 0.415741
mmbn3_y_ratio_d_pet_zenny_digit_edge := 0.469907

mmbn3_rgb_pet_digit := 0xfdffff
mmbn3_pet_zenny_num_rows := 1
mmbn3_pet_zenny_num_columns := 6

mmbn3_digits_pet_zenny := CharGridColorChecker(
    mmbn3_x_ratio_l_pet_zenny_digit_1_edge,
    mmbn3_y_ratio_u_pet_zenny_digit_edge,
    mmbn3_x_ratio_r_pet_zenny_digit_1_edge - mmbn3_x_ratio_l_pet_zenny_digit_1_edge,
    mmbn3_y_ratio_d_pet_zenny_digit_edge - mmbn3_y_ratio_u_pet_zenny_digit_edge,
    0.0,
    (mmbn3_x_ratio_l_pet_zenny_digit_6_edge - mmbn3_x_ratio_l_pet_zenny_digit_1_edge) / 5.0,
    mmbn3_pet_zenny_num_rows,
    mmbn3_pet_zenny_num_columns,
    mmbn3_digit_check_ratios,
    mmbn3_digit_check_map,
    mmbn3_rgb_pet_digit,
)