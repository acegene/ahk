GenerateDebugStr(var_names, delimiter_in := " ", delimiter_out := "`n") {
    local ret_val
    Loop Parse, var_names, delimiter_in {
        ret_val .= A_LoopField "=" %A_LoopField% delimiter_out
    }
    return ret_val
}
