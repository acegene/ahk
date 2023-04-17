#SingleInstance Force
#NoEnv

GetType(data){
    if (data is Integer) {
        return "integer"
    } else if (data is Float) {
        return "float"
    } else if (data is String) {
        return "string"
    } else if (data is Object) {
        return "object"
    } else if (data is Array) {
        return "array"
    } else if (data is Function) {
        return "function"
    } else if (data is Bool) {
        return "boolean"
    } else {
        return "unknown"
    }
}

IsNear(expected, actual, tolerance){
    if(actual >= expected - tolerance && actual <= expected + tolerance){
        return True
    }
    return False
}

IsPixelColorWithinTolerances(expected_pixel, actual_pixel, r_tol, g_tol, b_tol){
    expected_red := expected_pixel >> 16 & 0xFF
    expected_green := expected_pixel >> 8 & 0xFF
    expected_blue := expected_pixel & 0xFF
    actual_red := actual_pixel >> 16 & 0xFF
    actual_green := actual_pixel >> 8 & 0xFF
    actual_blue := actual_pixel & 0xFF

    ; Msgbox e=(%expected_red%,%expected_green%,%expected_blue%) a=(%actual_red%,%actual_green%,%actual_blue%)

    if(!IsNear(expected_red, actual_red, r_tol)){
        return False
    }
    if(!IsNear(expected_green, actual_green, g_tol)){
        return False
    }
    if(!IsNear(expected_blue, actual_blue, b_tol)){
        return False
    }
    return True
}

IsPixelColorWithinTolerance(expected_pixel, actual_pixel, tol){
    return IsPixelColorWithinTolerances(expected_pixel, actual_pixel, tol, tol, tol)
}

MaximizeWindow(window_title){
    WinGet, style, Style, %window_title%
    ; 0x1000000 is the WS_MAXIMIZE style
    if !(style & 0x1000000){
        WinMaximize, %window_title%
    }
}

FocusWindow(window_title){
    if not WinActive(window_title){
        WinActivate, %window_title%
    }
}

ClickMouseWindowRatio(window_title, x_ratio, y_ratio, which_button = "L"){
    CoordMode, Mouse, Relative
    WinGetPos, x, y, w, h, %window_title%
    x := w * x_ratio
    y := h * y_ratio
    MouseClick, %which_button%, %x%, %y%
}

MoveMouseWindowRatio(window_title, x_ratio, y_ratio){
    CoordMode, Mouse, Relative
    WinGetPos, x, y, w, h, %window_title%
    x := w * x_ratio
    y := h * y_ratio
    MouseMove %x%, %y%
}

BlockUntilWindowDoesNotExist(window_title, sleep_duration = 1000){
    SetTitleMatchMode, 3 ; absolute matching
    while(true){
        if (!WinExist(window_title)){
            break
        }
        Sleep, %sleep_duration%
    }
}

DoesWindowExist(window_title){
    SetTitleMatchMode, 3 ; absolute matching
    return WinExist(window_title)
}

GetWindowText(window_title, field_name){
    ; Get the handle of the window.
    WinGet, hWnd, ID, %window_title%

    ; Get the text from field_name in window_title.
    ControlGetText, field_text, %field_name%, ahk_id %hWnd%

    return field_text
}

year := 2000
year_final := 2099
title_5th_gen_time_finder := "5th Generation Time Finder"
5th_gen_time_finder_method_field_name := "WindowsForms10.COMBOBOX.app.0.141b42a_r6_ad113"
title_time_finder_progress := "Time Finder Progress"
title_save_output_to_txt := "Save Output to TXT"

sleep 2000

while(true){
    MaximizeWindow(title_5th_gen_time_finder)
    Sleep 100
    FocusWindow(title_5th_gen_time_finder)
    Sleep 100

    MsgBox % StrLower(GetWindowText(title_5th_gen_time_finder, 5th_gen_time_finder_method_field_name))
    break

    ; double click year input field
    ClickMouseWindowRatio(title_5th_gen_time_finder, 0.089423, 0.201592)
    ClickMouseWindowRatio(title_5th_gen_time_finder, 0.089423, 0.201592)
    Sleep, 50

    ; input year
    Send, {Blind}%year%
    Sleep 200

    ; click generate button
    ClickMouseWindowRatio(title_5th_gen_time_finder, 0.066346, 0.377984)
    Sleep 5000

    BlockUntilWindowDoesNotExist(title_time_finder_progress)

    MaximizeWindow(title_5th_gen_time_finder)
    Sleep 100
    FocusWindow(title_5th_gen_time_finder)
    Sleep 100

    ClickMouseWindowRatio(title_5th_gen_time_finder, 0.627885, 0.441645, "R")
    Sleep 50
    ClickMouseWindowRatio(title_5th_gen_time_finder, 0.746154, 0.539788, "L")
    Sleep 2000
    ; WindowsForms10.COMBOBOX.app.0.141b42a_r6_ad113
    if(DoesWindowExist(title_save_output_to_txt)){
        MaximizeWindow(title_save_output_to_txt)
        Sleep 100
        FocusWindow(title_save_output_to_txt)
        Sleep 100
        ClickMouseWindowRatio(title_save_output_to_txt, 0.683594, 0.065041, "L")
        Sleep 500
        Send, {Blind}Desktop/pokemon
        Sleep 50
        Send, {Blind}{Enter}
        Sleep 1500
        ClickMouseWindowRatio(title_save_output_to_txt, 0.517578, 0.857724, "L")
        Sleep 50
        Send, {Blind}rngreporter-%year%.txt
        Sleep 50
        Send, {Blind}{Enter}
        Sleep 3000
    }


    ; coordinates to check for match 790, 330
    PixelGetColor, bgr_color_at_pixel, %x%, %y%
    if(False && !IsPixelColorWithinTolerance(expected_bgr_color_at_pixel, bgr_color_at_pixel, 5)){
        expected_bgr_color_at_pixel := 0xABABAB
        tolerance := 10 ; color tolerance for approximate match
        prev_color := 0 ; initialize the previous color variable
        x:= 790
        y:= 330


        ; MsgBox, The color has changed! rgb_color=%rgb_color_at_pixel% bgr_color=%bgr_color_at_pixel% hex_color=%hex_color%
        MaximizeWindow(title_5th_gen_time_finder)
        Sleep 100
        FocusWindow(title_5th_gen_time_finder)
        Sleep 100
        ClickMouseWindowRatio(title_5th_gen_time_finder, 0.627885, 0.441645, "R")
        Sleep 50
        MaximizeWindow(title_save_output_to_txt)
        Sleep 100
        FocusWindow(title_save_output_to_txt)
        Sleep 100
        ClickMouseWindowRatio(title_save_output_to_txt, 0.746154, 0.539788, "L")
        ClickMouseWindowRatio(title_save_output_to_txt, 0.683594, 0.065041, "L")
        Sleep 1000
        ClickMouseWindowRatio(title_save_output_to_txt, 0.517578, 0.857724, "L")
        Sleep 50
        Send, {Blind}Desktop/pokemon
        Sleep 50
        Send, {Blind}{Enter}
        Sleep 1500
        MouseClick, L, 406, 406
        Sleep 50
        Send, {Blind}rngreporter-%year%.txt
        Sleep 50
        Send, {Blind}{Enter}
        Sleep 1000
    }

    ; MsgBox, The color has changed! New color: % Format("{:06X}", rgb_color_at_pixel)%
    if(year = year_final){
        break
    }
    year++
}

; for f in ~/Desktop/pokemon/*.txt; do cat "${f}" | head -n 1 | sed -e 's/\s\+/,/g' >> ~/Desktop/pokemon/rngreporter.csv; break; done; for f in ~/Desktop/pokemon/*.txt; do cat "${f}" | tail -n +2 | sed -e 's/\s\+/,/g' >> ~/Desktop/pokemon/rngreporter.csv; done

Esc::ExitApp
