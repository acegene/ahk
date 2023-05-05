#include <array-utils>
#include <geometry-utils>
#include <string-utils>
#include <window-utils>

class CharGrid {
    class CharBounds {
        __new(x_l, x_r, y_u, y_d) {
            this.x_l := x_l
            this.x_r := x_r
            this.y_u := y_u
            this.y_d := y_d
        }
    }

    __new(x_l_char_1_edge, y_u_char_1_edge, w_char, h_char, row_displacement, column_displacement, num_rows, num_columns) {
        this.w_char := w_char
        this.h_char := h_char
        this.row_displacement := row_displacement
        this.column_displacement := column_displacement
        this.num_rows := num_rows
        this.num_columns := num_columns

        this.char_bounds_2d := []
        loop this.num_rows {
            row_index := A_Index
            row := []
            y_displacement := this.row_displacement * (A_Index - 1)
            loop this.num_columns {
                x_displacement := this.column_displacement * (A_Index - 1)
                char_bounds := row.Push(
                    CharGrid.CharBounds(
                        x_l_char_1_edge + x_displacement,
                        x_l_char_1_edge + x_displacement + this.w_char,
                        y_u_char_1_edge + y_displacement,
                        y_u_char_1_edge + y_displacement + this.h_char
                    )
                )
            }
            this.char_bounds_2d.Push(row)
        }
    }
}

class CharGridColorChecker extends CharGrid {
    __new(x_l_char_1_edge, y_u_char_1_edge, w_char, h_char, row_displacement, column_displacement, num_rows, num_columns, char_check_ratios, char_check_map, rgbs_check) {
        super.__new(x_l_char_1_edge, y_u_char_1_edge, w_char, h_char, row_displacement, column_displacement, num_rows, num_columns)

        this.char_check_map := char_check_map
        this.rgbs_check := rgbs_check

        this.char_check_locations_2d := []
        for (char_bounds_row in this.char_bounds_2d) {
            char_check_locations := []
            for (char_bound in char_bounds_row) {
                check_locations := []
                for (check_ratio_2d in char_check_ratios) {
                    check_locations.Push(Point2D(
                        char_bound.x_l + (check_ratio_2d.x * w_char),
                        char_bound.y_u + (check_ratio_2d.y * h_char)))
                }
                char_check_locations.Push(check_locations)
            }
            this.char_check_locations_2d.Push(char_check_locations)
        }
    }

    __IsRatioColorEqualToAnyColor__(w_win, h_win, char_check_location) {
        for (rgb in this.rgbs_check) {
            if (IsRatioColorEqualToColor(w_win, h_win, char_check_location.x, char_check_location.y, rgb)) {
                return true
            }
        }
        return false
    }

    GetChar(row, column, w_win, h_win, null_str := "0") {
        char_locations_found := []
        for (char_check_location in this.char_check_locations_2d[row][column]) {
            char_locations_found.Push(this.__IsRatioColorEqualToAnyColor__(w_win, h_win, char_check_location))
        }
        for (key, val in this.char_check_map) {
            if (IsArrEq(val, char_locations_found)) {
                if (key = "NULL") {
                    return Integer(null_str)
                } else {
                    return Integer(key)
                }
            }
        }

        char_check_location_str := "char_check_location:`n"
        for (char_check_location in this.char_check_locations_2d[row][column]) {
            char_check_location_str .= "    x=" .
                char_check_location.x ", y=" .
                char_check_location.y . "; rgb=" .
                GetRatioColor(w_win, h_win, char_check_location.x, char_check_location.y) . "`n"
        }
        MsgBox("ERROR: for (row=" . row . ", column=" .
            column . "); could not match any char to char_locations_found=" .
            Join(char_locations_found, ",") . "`n" . char_check_location_str)
        ExitApp(1)
    }

    GetCharsRow(row, w_win, h_win, null_str := "0") {
        chars_row := []
        loop this.num_columns {
            chars_row.Push(this.GetChar(row, A_index, w_win, h_win, null_str))
        }
        return chars_row
    }

    GetChars2D(w_win, h_win, null_str := "0") {
        chars_2d := []
        loop this.num_rows {
            chars_2d.Push(this.GetCharsRow(A_Index, w_win, h_win, null_str))
        }
        return chars_2d
    }
}

;; chip trader chip count, zenny, bugfrags, hp
mmbn3_digit_check_ratios := [
    Point2D(1.0 / 6.0, 0.1), ;; no 1, 4
    Point2D(1.0 / 6.0, 0.3), ;; no 1, 2, 3, 4?
    ; Point2D(1.0 / 6.0, 0.5), ;; no 1, 3?, 8?, 7
    Point2D(1.2 / 6.0, 0.5), ;; no 1, 3?, 8?, 7
    Point2D(1.0 / 6.0, 0.7), ;; no 1, 3, 5, 7, 9
    Point2D(5.0 / 6.0, 0.3), ;; no 1, 5, 6
    Point2D(3.0 / 6.0, 0.1), ;; no 4
]

;; chip trader chip count, zenny, bugfrags, hp
mmbn3_digit_check_map := Map(
    "0", [true, true, true, true, true, true],
    "1", [false, false, false, false, false, true],
    "2", [true, false, true, true, true, true],
    "3", [true, false, false, false, true, true],
    "4", [false, false, true, true, true, false],
    "5", [true, true, true, false, false, true],
    "6", [true, true, true, true, false, true],
    "7", [true, true, false, false, true, true],
    "8", [true, true, false, true, true, true],
    "9", [true, true, true, false, true, true],
    "NULL", [false, false, false, false, false, false]
)
