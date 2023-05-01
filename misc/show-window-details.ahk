#SingleInstance Force
#NoEnv

#Persistent
SetTimer, ShowWindowRatio, 500

; Boolean variable to toggle ToolTip freeze
ToolTipFrozen := false
originalToolTipText := ""

ShowWindowRatio:
    CoordMode, Mouse, Relative

    tool_tip_x := A_ToolTipX
    tool_tip_y := A_ToolTipY

    if (frozen) {
        ToolTip, %originalToolTipText%, %tool_tip_x%, %tool_tip_y%, 1
        return
    }

    ; Check if the mouse is hovering over the ToolTip
    tool_tip_width := A_ToolTipWidth
    tool_tip_height := A_ToolTipHeight
    tool_tip_mouse_over := (mouse_x >= tool_tip_x && mouse_x <= tool_tip_x + tool_tip_width && mouse_y >= tool_tip_y && mouse_y <= tool_tip_y + tool_tip_height)


    WinGetPos, win_origin_x, win_origin_y, win_width, win_height, A
    WinGetTitle, win_title, A
    WinGetClass, win_class, A
    WinGet, win_pid, PID, A
    MouseGetPos, mouse_x, mouse_y
    win_ratio_x := mouse_x / win_width
    win_ratio_y := mouse_y / win_height

    CoordMode, Mouse, Client
    MouseGetPos, mouse_x_client, mouse_y_client
    WinGetPos, win_origin_x_client, win_origin_y_client, win_width_client, win_height_client, A
    win_ratio_x_client := mouse_x_client / win_width_client
    win_ratio_y_client := mouse_y_client / win_height_client

    ; Update the ToolTip position if the mouse is hovering over it
    if (tool_tip_mouse_over) {
        tool_tip_x := mouse_x + 20
        tool_tip_y := mouse_y + 20
    }

    PixelGetColor, color, mouse_x, mouse_y, RGB

    ; Show the ToolTip with the updated position
    originalToolTipText := "win_ratio_x:" . win_ratio_x . "`nwin_ratio_y:" . win_ratio_y . "`nwin_origin_x:" . win_origin_x . "`nwin_origin_y:" . win_origin_y . "`nmouse_x:" . mouse_x . "`nmouse_y:" . mouse_y . "`nwin_width:" . win_width . "`nwin_height:" . win_height . "`nwin_ratio_x_client:" . win_ratio_x_client . "`nwin_ratio_y_client:" . win_ratio_y_client . "`nwin_origin_x_client:" . win_origin_x_client . "`nwin_origin_y_client:" . win_origin_y_client . "`nmouse_x_client:" . mouse_x_client . "`nmouse_y_client:" . mouse_y_client . "`nwin_width_client:" . win_width_client . "`nwin_height_client:" . win_height_client . "`nwin_title:" . win_title . "`nwin_class:" . win_class . "`nwin_pid:" . win_pid . "`ncolor:" . color
    ToolTip, %originalToolTipText%, %tool_tip_x%, %tool_tip_y%, 1
    return

    ~^Space::
    frozen := !frozen
    return

    Esc:: ExitApp
