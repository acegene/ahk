#include "%A_ScriptDir%\mmbn-lib\mmbn3-misc.ahk"

FindEnemyFieldColorMatches(rgb, w_win, h_win, w_ratio_offset, h_ratio_offset) {
    x_l_color_check := (x_ratio_l + w_ratio_offset) * w_win
    x_m_color_check := (x_ratio_m + w_ratio_offset) * w_win
    x_r_color_check := (x_ratio_r + w_ratio_offset) * w_win
    y_u_color_check := (y_ratio_u + h_ratio_offset) * h_win
    y_m_color_check := (y_ratio_m + h_ratio_offset) * h_win
    y_d_color_check := (y_ratio_d + h_ratio_offset) * h_win

    CoordMode("Mouse", "Client")
    result := 0
    if (rgb = PixelGetColor(x_l_color_check, y_u_color_check, "RGB")) {
        result := result + 1
    }
    if (rgb = PixelGetColor(x_l_color_check, y_m_color_check, "RGB")) {
        result := result + 2
    }
    if (rgb = PixelGetColor(x_l_color_check, y_d_color_check, "RGB")) {
        result := result + 4
    }
    if (rgb = PixelGetColor(x_m_color_check, y_u_color_check, "RGB")) {
        result := result + 8
    }
    if (rgb = PixelGetColor(x_m_color_check, y_m_color_check, "RGB")) {
        result := result + 16
    }
    if (rgb = PixelGetColor(x_m_color_check, y_d_color_check, "RGB")) {
        result := result + 32
    }
    if (rgb = PixelGetColor(x_r_color_check, y_u_color_check, "RGB")) {
        result := result + 64
    }
    if (rgb = PixelGetColor(x_r_color_check, y_m_color_check, "RGB")) {
        result := result + 128
    }
    if (rgb = PixelGetColor(x_r_color_check, y_d_color_check, "RGB")) {
        result := result + 256
    }

    return result
}

FindMettaur(w_win, h_win) {
    return FindEnemyFieldColorMatches(rgb_mettaur, w_win, h_win, w_ratio_mettaur, h_ratio_mettaur)
}

FindMettaur2(w_win, h_win) {
    return FindEnemyFieldColorMatches(rgb_mettaur2, w_win, h_win, w_ratio_mettaur, h_ratio_mettaur)
}

FindFishy3(w_win, h_win) {
    return FindEnemyFieldColorMatches(rgb_fishy3, w_win, h_win, w_ratio_fishy, h_ratio_fishy)
}

FindHardHead(w_win, h_win) {
    return FindEnemyFieldColorMatches(rgb_hard_head, w_win, h_win, w_ratio_hard_head, h_ratio_hard_head)
}

FindNailer(w_win, h_win) {
    return FindEnemyFieldColorMatches(rgb_nailer, w_win, h_win, w_ratio_nailer, h_ratio_nailer)
}

FindCanodumb3(w_win, h_win) {
    return FindEnemyFieldColorMatches(rgb_canodumb3, w_win, h_win, w_ratio_canodumb, h_ratio_canodumb)
}

FindJapanMan(w_win, h_win) {
    return FindEnemyFieldColorMatches(rgb_japan_man, w_win, h_win, w_ratio_japan_man, h_ratio_japan_man)
}

rgb_mettaur := 0xffd400
rgb_mettaur2 := 0xff4862
x_ratio_m_mettaur := 0.695052
y_ratio_m_mettaur := 0.652315
w_ratio_mettaur := x_ratio_m_mettaur - x_ratio_m
h_ratio_mettaur := y_ratio_m_mettaur - y_ratio_m

rgb_fishy3 := 0xffb61b
x_ratio_l_fishy := 0.627083
y_ratio_d_fishy := 0.728704
w_ratio_fishy := x_ratio_l_fishy - x_ratio_l
h_ratio_fishy := y_ratio_d_fishy - y_ratio_d

rgb_hard_head := 0x3f2c48
x_ratio_l_hard_head := x_ratio_l
y_ratio_d_hard_head := y_ratio_d
w_ratio_hard_head := x_ratio_l_hard_head - x_ratio_l
h_ratio_hard_head := y_ratio_d_hard_head - y_ratio_d

rgb_nailer := 0x501b35
x_ratio_l_nailer := x_ratio_l
y_ratio_d_nailer := y_ratio_d
w_ratio_nailer := x_ratio_l_nailer - x_ratio_l
h_ratio_nailer := y_ratio_d_nailer - y_ratio_d

rgb_canodumb3 := 0xff2c3f
x_ratio_l_canodumb := x_ratio_l
y_ratio_d_canodumb := y_ratio_d
w_ratio_canodumb := x_ratio_l_canodumb - x_ratio_l
h_ratio_canodumb := y_ratio_d_canodumb - y_ratio_d

rgb_japan_man := 0x59fbfb
x_ratio_m_japan_man := 0.627083
y_ratio_m_japan_man := 0.333333
w_ratio_japan_man := x_ratio_m_japan_man - x_ratio_m
h_ratio_japan_man := y_ratio_m_japan_man - y_ratio_m
