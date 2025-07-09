#Requires AutoHotkey v2.0
#SingleInstance Force
Persistent(true)

#include <optimizations>

#include <string-utils>
#include <tool-tip-utils>

MoveMouse(direction) {
    global tool_tip_cfg
    if (direction = "~!Down") {
        MouseMove(0, 1, 10, "R")
    } else if (direction = "~!Up") {
        MouseMove(0, -1, 10, "R")
    } else if (direction = "~!Right") {
        MouseMove(1, 0, 10, "R")
    } else if (direction = "~!Left") {
        MouseMove(-1, 0, 10, "R")
    } else {
        MsgBox("FATAL: unexpected MoveMouse() direction=" . direction)
        ExitApp(1)
    }
}

MoveToolTip(direction) {
    global tool_tip_cfg
    if (direction = "~+Down") {
        if (tool_tip_cfg.location = "ur") {
            tool_tip_cfg.location := "dr"
        } else if (tool_tip_cfg.location = "ul") {
            tool_tip_cfg.location := "dl"
        }
    } else if (direction = "~+Up") {
        if (tool_tip_cfg.location = "dr") {
            tool_tip_cfg.location := "ur"
        } else if (tool_tip_cfg.location = "dl") {
            tool_tip_cfg.location := "ul"
        }
    } else if (direction = "~+Right") {
        if (tool_tip_cfg.location = "ul") {
            tool_tip_cfg.location := "ur"
        } else if (tool_tip_cfg.location = "dl") {
            tool_tip_cfg.location := "dr"
        }
    } else if (direction = "~+Left") {
        if (tool_tip_cfg.location = "ur") {
            tool_tip_cfg.location := "ul"
        } else if (tool_tip_cfg.location = "dr") {
            tool_tip_cfg.location := "dl"
        }
    } else {
        MsgBox("FATAL: unexpected MoveToolTip() direction=" . direction)
        ExitApp(1)
    }
}

tool_tip_cfg := ToolTipCfg()
frozen := false
msg_map := Map()
clipboard_cleared := false
num_clipboard_decimals := 6

SetTimer(ShowWindowRatio, 500)

ShowWindowRatio() {
    global msg_map
    if (frozen) {
        return
    }

    try {
        win_class := WinGetClass("A")
        win_pid := WinGetPID("A")
        win_title := WinGetTitle("A")
    } catch TargetError {
        return
    }

    CoordMode("Mouse", "Client")
    MouseGetPos(&mouse_cli_x, &mouse_cli_y)
    WinGetPos(&x_win_cli, &y_win_cli, &win_cli_w, &win_cli_h, "A")
    mouse_cli_x_ratio := mouse_cli_x / win_cli_w
    mouse_cli_y_ratio := mouse_cli_y / win_cli_h

    CoordMode("Mouse", "Window")
    MouseGetPos(&mouse_win_x, &mouse_win_y)
    WinGetPos(&x_win_win, &y_win_win, &win_win_w, &win_win_h, "A")
    mouse_win_x_ratio := mouse_win_x / win_win_w
    mouse_win_y_ratio := mouse_win_y / win_win_h

    CoordMode("Pixel", "Client")
    rgb := PixelGetColor(mouse_cli_x, mouse_cli_y, "RGB")

    msg_map := Map(
        "frozen", frozen,
        "win_cli_h", win_cli_h,
        "win_win_h", win_win_h,
        "rgb", rgb,
        "win_cli_w", win_cli_w,
        "win_win_w", win_win_w,
        "win_class", win_class,
        "win_pid", win_pid,
        "win_title", win_title,
        "mouse_cli_x", mouse_cli_x,
        "mouse_cli_x_ratio", mouse_cli_x_ratio,
        "mouse_win_x", mouse_win_x,
        "mouse_win_x_ratio", mouse_win_x_ratio,
        "mouse_cli_y", mouse_cli_y,
        "mouse_cli_y_ratio", mouse_cli_y_ratio,
        "mouse_win_y", mouse_win_y,
        "mouse_win_y_ratio", mouse_win_y_ratio,
        "tool_tip_cfg.location", tool_tip_cfg.location,
    )

    CoordMode("ToolTip", "Client")
    tool_tip_cfg.DisplayMsg(MapToStr(msg_map), win_cli_w, win_cli_h)
}

$^c:: {
    global clipboard_cleared
    global num_clipboard_decimals
    if (!clipboard_cleared) {
        A_Clipboard := ""
        clipboard_cleared := true
    }
    A_Clipboard := A_Clipboard . Round(msg_map["mouse_cli_x_ratio"], num_clipboard_decimals) . ", " . Round(msg_map["mouse_cli_y_ratio"], num_clipboard_decimals) . ", " . StrLower(msg_map["rgb"]) . "`n"
}

$^+c:: {
    global clipboard_cleared
    clipboard_cleared := true
    A_Clipboard := ""
}

~!Down::
~!Left::
~!Right::
~!Up:: {
    MoveMouse(A_ThisHotkey)
}

~+Down::
~+Left::
~+Right::
~+Up:: {
    MoveToolTip(A_ThisHotkey)
}

~^Space:: {
    global frozen
    frozen := !frozen
}

$Esc:: {
    ExitApp
}
