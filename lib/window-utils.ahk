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
