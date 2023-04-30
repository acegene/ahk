MaximizeWindow(window_title) {
    style := WinGetStyle(window_title)
    ; 0x1000000 is the WS_MAXIMIZE style
    if !(style & 0x1000000) {
        WinMaximize(window_title)
    }
}

FocusWindow(window_title) {
    if not WinActive(window_title) {
        WinActivate(window_title)
    }
}

MaximizeAndFocusWindow(window_title) {
    MaximizeWindow(window_title)
    FocusWindow(window_title)
    Sleep(50)
}

BlockUntilWindowDoesNotExist(window_title, sleep_duration := 1000) {
    SetTitleMatchMode 3 ; exact matching
    while (true) {
        if (!WinExist(window_title)) {
            break
        }
        Sleep sleep_duration
    }
}

DoesWindowExist(window_title) {
    SetTitleMatchMode 3 ; exact matching
    return WinExist(window_title)
}

class RatioRgbs {
    __new(x_ratios, y_ratios, rgbs) {
        this.x_ratios := x_ratios
        this.y_ratios := y_ratios
        this.rgbs := rgbs
    }

    DoesWindowMatchRatioRgbs(w_win, h_win) {
        Loop this.rgbs.Length {
            if (this.rgbs[A_Index] != PixelGetColor(this.x_ratios[A_Index] * w_win, this.y_ratios[A_Index] * h_win, "RGB")) {
                return false
            }
        }
        return true
    }
}

GetRatioColor(w_win, h_win, x_ratio, y_ratio) {
    return PixelGetColor(x_ratio * w_win, y_ratio * h_win, "RGB")
}

IsRatioColorEqualToColor(w_win, h_win, x_ratio, y_ratio, rgb_color) {
    return rgb_color = PixelGetColor(x_ratio * w_win, y_ratio * h_win, "RGB")
}

IsWindowRatioColorEqualToColor(title, x_ratio, y_ratio, rgb_color) {
    CoordMode("Mouse", "Client")
    MaximizeAndFocusWindow(title)
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title)
    return IsRatioColorEqualToColor(w_win, h_win, x_ratio, y_ratio, rgb_color)
}

AreRatioColorsEqualToColors(w_win, h_win, x_ratios, y_ratios, rgb_colors) {
    Loop rgb_colors.Length {
        if (!IsRatioColorEqualToColor(w_win, h_win, x_ratios[A_Index], y_ratios[A_Index], rgb_colors[A_Index])) {
            return False
        }
    }
    return True
}

AreWindowRatioColorsEqualToColors(title, x_ratios, y_ratios, rgb_colors) {
    CoordMode("Mouse", "Client")
    MaximizeAndFocusWindow(title)
    WinGetPos(&x_win, &y_win, &w_win, &h_win, title)
    return AreRatioColorsEqualToColors(w_win, h_win, x_ratios, y_ratios, rgb_colors)
}
