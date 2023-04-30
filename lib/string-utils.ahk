GenerateDebugStr(var_names, delimiter_in := " ", delimiter_out := "`n") {
    local ret_val
    Loop Parse, var_names, delimiter_in {
        ret_val .= A_LoopField "=" %A_LoopField% delimiter_out
    }
    return ret_val
}

Join(arr, delimiter := "") {
    if (arr.Length = 0) {
        return ""
    }
    ret_val := arr[1]
    Loop arr.Length - 1 {
        ret_val .= delimiter . arr[A_Index + 1]
    }
    return ret_val
}

JoinN(arr, n, delimiters := []) {
    if (arr.Length = 0) {
        return ""
    }

    if (n = 1) {
        return Join(arr, delimiters[n])
    }

    ret_val := JoinN(arr[1], n - 1, delimiters)
    Loop arr.Length - 1 {
        ret_val .= delimiters[n] . JoinN(arr[A_Index + 1], n - 1, delimiters)
    }
    return ret_val
}

MapToStr(map, delimiter_key_val := "=", delimiter_between_entries := "`n") {
    ret_val := ""
    for (key, val in map) {
        ret_val .= key . delimiter_key_val . val . delimiter_between_entries
    }
    return ret_val
}
