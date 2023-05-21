class ToolTipCfg {
    __new(location := "ul", index := 1, w_win := "", h_win := "") {
        this.location := location
        this.index := index
        this.w_win := w_win
        this.h_win := h_win
    }

    DisplayMsg(msg, w_win := "", h_win := "") {
        w_win_local := w_win != "" ? w_win : this.w_win
        h_win_local := h_win != "" ? h_win : this.h_win

        CoordMode("ToolTip", "Client")
        if (this.location = "ur") {
            ToolTip(msg, w_win_local * 0.9999, h_win_local * 0.0001, this.index)
        } else if (this.location = "ul") {
            ToolTip(msg, w_win_local * 0.005, h_win_local * 0.0001, this.index)
        } else if (this.location = "dr") {
            ToolTip(msg, w_win_local * 0.9999, h_win_local * 0.9999, this.index)
        } else if (this.location = "dl") {
            ToolTip(msg, w_win_local * 0.005, h_win_local * 0.9999, this.index)
        } else {
            MsgBox("FATAL: unexpected this.location=" . this.location)
            ExitApp(1)
        }
    }

    Clear() {
        ToolTip("", 0, 0, this.index)
    }
}
