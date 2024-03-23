ClickMouseWindowRatio(window_title, x_ratio, y_ratio, which_button := "L", speed := 2) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x, &y, &w, &h, window_title)
    x := w * x_ratio
    y := h * y_ratio
    MouseClick(which_button, x, y, 1, speed)
}

ClickMouseWindowRatioRngRange(window_title, x_ratio, y_ratio, one_sided_rng_range, which_button := "L", speed := 2) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x, &y, &w, &h, window_title)
    x := w * (x_ratio + (one_sided_rng_range * Random() * (Random() > 0.5 ? 1 : -1)))
    y := h * (y_ratio + (one_sided_rng_range * Random() * (Random() > 0.5 ? 1 : -1)))
    MouseClick(which_button, x, y, 1, speed)
}

ClickMouseWindowRatioRngRangeXY(window_title, x_ratio, y_ratio, one_sided_rng_range_x, one_sided_rng_range_y, which_button := "L", speed := 2) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x, &y, &w, &h, window_title)
    x := w * (x_ratio + (one_sided_rng_range_x * Random() * (Random() > 0.5 ? 1 : -1)))
    y := h * (y_ratio + (one_sided_rng_range_y * Random() * (Random() > 0.5 ? 1 : -1)))
    MouseClick(which_button, x, y, 1, speed)
}

MoveMouseWindowRatio(window_title, x_ratio, y_ratio, speed := 2) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x, &y, &w, &h, window_title)
    x := w * x_ratio
    y := h * y_ratio
    MouseMove(x, y, speed)
}

MoveMouseWindowRatioRngRange(window_title, x_ratio, y_ratio, one_sided_rng_range, speed := 2) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x, &y, &w, &h, window_title)
    x := w * (x_ratio + (one_sided_rng_range * Random() * (Random() > 0.5 ? 1 : -1)))
    y := h * (y_ratio + (one_sided_rng_range * Random() * (Random() > 0.5 ? 1 : -1)))
    MouseMove(x, y, speed)
}

MoveMouseWindowRatioRngRangeXY(window_title, x_ratio, y_ratio, one_sided_rng_range_x, one_sided_rng_range_y, speed := 2) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x, &y, &w, &h, window_title)
    x := w * (x_ratio + (one_sided_rng_range_x * Random() * (Random() > 0.5 ? 1 : -1)))
    y := h * (y_ratio + (one_sided_rng_range_y * Random() * (Random() > 0.5 ? 1 : -1)))
    MouseMove(x, y, speed)
}
