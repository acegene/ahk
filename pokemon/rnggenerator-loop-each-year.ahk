#Requires AutoHotkey v2.0
#SingleInstance Force

MaximizeWindow(window_title) {
    style := WinGetStyle(window_title)
    ; 0x1000000 is the WS_MAXIMIZE style
    if !(style & 0x1000000) {
        WinMaximize window_title
    }
}

FocusWindow(window_title) {
    if not WinActive(window_title) {
        WinActivate window_title
    }
}

ClickMouseWindowRatio(window_title, x_ratio, y_ratio, which_button := "L") {
    CoordMode("Mouse", "Client")
    WinGetPos &x, &y, &w, &h, window_title
    x := w * x_ratio
    y := h * y_ratio
    MouseClick which_button, x, y
}

MoveMouseWindowRatio(window_title, x_ratio, y_ratio) {
    CoordMode("Mouse", "Client")
    WinGetPos &x, &y, &w, &h, window_title
    x := w * x_ratio
    y := h * y_ratio
    MouseMove x, y
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

StrReplaceNonAlpha(str, replace_str) {
    return RegExReplace(str, "[^A-Za-z]+", replace_str)
}

GetCleanedWindowFieldText(window_title, field_name) {
    field_text := ControlGetText(field_name, window_title)
    cleaned_field_text := StrLower(field_text)
    cleaned_field_text := RegExReplace(cleaned_field_text, "[^A-Za-z0-9]+", "")
    ; cleaned_field_text := StrTrim(cleaned_field_text, "-", "B")
    return cleaned_field_text
}

ManuallyFill5thGenTimeFinderYear(window_title, year) {
    MaximizeWindow(window_title)
    Sleep 100
    FocusWindow(window_title)
    Sleep 100
    ;; CoordMode Window
    ; ClickMouseWindowRatio(window_title, 0.089423, 0.201592)
    ; ClickMouseWindowRatio(window_title, 0.089423, 0.201592)
    ;; CoordMode Client
    ClickMouseWindowRatio(window_title, 0.082692, 0.157825)
    ClickMouseWindowRatio(window_title, 0.082692, 0.157825)
    Sleep 50

    ; input year
    SendInput("{Blind}" . year)
    Sleep 200
}

ManuallyClick5thGenTimeFinderGenerate(window_title) {
    MaximizeWindow(window_title)
    Sleep 100
    FocusWindow(window_title)
    Sleep 100
    ; ClickMouseWindowRatio(window_title, 0.066346, 0.377984) ; CoordMode Window
    ClickMouseWindowRatio(window_title, 0.057692, 0.338196) ; CoordMode Client
}

ManuallySave(window_title, dir, filename) {
    MaximizeWindow(title_save_output_to_txt)
    Sleep 100
    FocusWindow(title_save_output_to_txt)
    Sleep 100
    ClickMouseWindowRatio(window_title, 0.683594, 0.065041, "L")
    Sleep 500
    SendInput("{Blind}" . dir)
    Sleep 50
    SendInput("{Blind}{Enter}")
    Sleep 1500
    ClickMouseWindowRatio(window_title, 0.517578, 0.857724, "L")
    Sleep 50
    SendInput("{Blind}" . filename)
    Sleep 50
    SendInput("{Blind}{Enter}")
    Sleep 3000
}

ManuallyOutputResultsToTXT(window_title) {
    MaximizeWindow(window_title)
    Sleep 100
    FocusWindow(window_title)
    Sleep 100
    ; ClickMouseWindowRatio(window_title, 0.627885, 0.441645, "R")
    ClickMouseWindowRatio(window_title, 0.541346, 0.407162, "R")
    Sleep 50
    ; ClickMouseWindowRatio(window_title, 0.746154, 0.539788, "L")
    ClickMouseWindowRatio(window_title, 0.623077, 0.498674, "L")
    Sleep 5000
}

AutoSave(window_name, field_name_dir, field_name_filename, dir, filename) {
    MaximizeWindow(window_name)
    Sleep 100
    FocusWindow(window_name)
    Sleep 100
    ControlSetText(dir, field_name_dir, window_name)
    Sleep 1000
    ControlSetText(filename, field_name_filename, window_name)
    Sleep 1000
    ; ControlClick(button_save_output_to_text_save, window_name) ; seemed janky
    MaximizeWindow(window_name)
    Sleep 100
    FocusWindow(window_name)
    Sleep 100
    SendInput("{Blind}{Enter}")
    Sleep 1000
}

GetMostRecentFile(dir) {
    ; Initialize variables to store the file name and creation time
    most_recent_file := ""
    most_recent_time := 0

    Loop Files, dir "\*" {
        ; Get the file's creation time
        time_created := FileGetTime(A_LoopFilePath, "C")

        ; If the file's creation time is more recent than the current most recent time,
        ; update the most recent file and time
        if (time_created > most_recent_time)
        {
            most_recent_file := A_LoopFileName
            most_recent_time := time_created
        }
    }
    return most_recent_file
}

;; manually configured variables used to generate filename and readme (TODO) content
rng_reporter_version := "rngreporter_10_3_4"
os := "win10"
method := "ivsstandardseed"
month := "all"
encounter_type := "wildpokemon"

dir := "C:\Users\acegene\Desktop\pokemon"
dir_screenshots := "C:\Users\acegene\Pictures\Screenshots"

year := 2001
year_final := 2099

title_5th_gen_time_finder := "5th Generation Time Finder"
field_name_5th_gen_time_finder_year := "WindowsForms10.EDIT.app.0.141b42a_r6_ad18"
field_name_5th_gen_time_finder_method := "WindowsForms10.COMBOBOX.app.0.141b42a_r6_ad113"
field_name_5th_gen_time_finder_month := "WindowsForms10.COMBOBOX.app.0.141b42a_r6_ad110"
field_name_5th_gen_time_finder_encounter_type := "WindowsForms10.COMBOBOX.app.0.141b42a_r6_ad111"
button_5th_gen_time_finder_generate := "WindowsForms10.BUTTON.app.0.141b42a_r6_ad126"

title_time_finder_progress := "Time Finder Progress"
title_save_output_to_txt := "Save Output to TXT"
field_name_save_output_to_text_dir := "Edit2"
field_name_save_output_to_text_filename := "Edit1"
button_save_output_to_text_save := "Button2"

sleep 2000

while (true) {
    filename_base := rng_reporter_version . "-" . os . "-" . year "-" . method . "-" . encounter_type
    filename := filename_base . ".txt"
    filename_screenshot := filename_base . ".png"

    ;; fill year input field
    ; ControlSetText(year, field_name_5th_gen_time_finder_year, title_5th_gen_time_finder)
    ManuallyFill5thGenTimeFinderYear(title_5th_gen_time_finder, year)
    Sleep 200

    ;; click generate button
    ; ControlClick(button_5th_gen_time_finder_generate, title_5th_gen_time_finder)
    ManuallyClick5thGenTimeFinderGenerate(title_5th_gen_time_finder)
    Sleep 5000

    BlockUntilWindowDoesNotExist(title_time_finder_progress)

    ManuallyOutputResultsToTXT(title_5th_gen_time_finder)

    if (DoesWindowExist(title_save_output_to_txt)) {
        ; ManuallySave(title_save_output_to_txt, dir. filename)
        AutoSave(title_save_output_to_txt, field_name_save_output_to_text_dir, field_name_save_output_to_text_filename, dir, filename)
        BlockUntilWindowDoesNotExist(title_save_output_to_txt)
        Sleep 2000
        MaximizeWindow(title_5th_gen_time_finder)
        Sleep 100
        FocusWindow(title_5th_gen_time_finder)
        Sleep 100
        Sendinput("#{PrintScreen}")
        Sleep 2000
        filepath_orig := GetMostRecentFile(dir_screenshots)
        FileMove(dir_screenshots . "\" . filepath_orig, dir . "\" . filename_screenshot)
    }

    if (year = year_final) {
        break
    }
    year++
}

Esc:: ExitApp
