ClickMouseWindowRatio(window_title, x_ratio, y_ratio, which_button := "L") {
    CoordMode("Mouse", "Client")
    WinGetPos(&x, &y, &w, &h, window_title)
    x := w * x_ratio
    y := h * y_ratio
    MouseClick(which_button, x, y)
}

MoveMouseWindowRatio(window_title, x_ratio, y_ratio) {
    CoordMode("Mouse", "Client")
    WinGetPos(&x, &y, &w, &h, window_title)
    x := w * x_ratio
    y := h * y_ratio
    MouseMove(x, y)
}
