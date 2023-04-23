#include <keypress-utils>

x_ratio_l_field_edge := 0.499740
y_ratio_u_field_edge := 0.538889
x_ratio_r_field_edge := 0.873958
y_ratio_d_field_edge := 0.942593

w_square := (x_ratio_r_field_edge - x_ratio_l_field_edge) / 3.0
h_square := (y_ratio_d_field_edge - y_ratio_u_field_edge) / 3.0

x_ratio_m := 0.5 * (x_ratio_l_field_edge + x_ratio_r_field_edge)
x_ratio_l := x_ratio_m - w_square
x_ratio_r := x_ratio_m + w_square
y_ratio_m := 0.5 * (y_ratio_u_field_edge + y_ratio_d_field_edge)
y_ratio_u := y_ratio_m - h_square
y_ratio_d := y_ratio_m + h_square

rgb_health_bar := 0x3f5975
x_ratio_health_bar_battle := 0.631250
y_ratio_health_bar_battle := 0.098148

StartBattle() {
    HoldKeyE("Enter", 50)
    Sleep(200)
    HoldKeyE("j", 50)
    Sleep(1300)
}

DoReflect() {
    SendEvent("{k down}")
    Sleep(30)
    SendEvent("{a down}")
    Sleep(30)
    SendEvent("{k up}")
    Sleep(50)
    SendEvent("{a up}")
    Sleep(400)
}
