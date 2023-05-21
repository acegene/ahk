HoldKeyE(key, duration) {
    SendEvent("{" . key . " down}")
    Sleep(duration)
    SendEvent("{" . key . " up}")
}

Hold2KeyE(key_1, key_2, duration) {
    SendEvent("{" . key_1 . " down}{" . key_2 . " down}")
    Sleep(duration)
    SendEvent("{" . key_1 . " up}{" . key_2 . " up}")
}

Hold3KeyE(key_1, key_2, key_3, duration) {
    SendEvent("{" . key_1 . " down}{" . key_2 . " down}{" . key_3 . " down}")
    Sleep(duration)
    SendEvent("{" . key_1 . " up}{" . key_2 . " up}{" . key_3 . " up}")
}

HoldKeysE(keys, duration) {
    keys_down_str := ""
    keys_up_str := ""
    for (key in keys) {
        keys_down_str .= "{" . key . " down}"
        keys_up_str .= "{" . key . " up}"
    }
    SendEvent(keys_down_str)
    Sleep(duration)
    SendEvent(keys_up_str)
}

KeysDownE(keys) {
    keys_down_str := ""
    for (key in keys) {
        keys_down_str .= "{" . key . " down}"
    }
    SendEvent(keys_down_str)
}

KeysUpE(keys) {
    keys_up_str := ""
    for (key in keys) {
        keys_up_str .= "{" . key . " up}"
    }
    SendEvent(keys_up_str)
}

RepeatHoldKeyForDurationE(key, duration_key_press, duration_repeat) {
    end_time := A_TickCount + duration_repeat
    while (A_TickCount < end_time) {
        HoldKeyE(key, duration_key_press)
    }
}

RepeatHoldKeysForDurationE(keys, duration_key_press, duration_repeat) {
    end_time := A_TickCount + duration_repeat
    while (A_TickCount < end_time) {
        HoldKeysE(keys, duration_key_press)
    }
}

ClearHeldKeysE(keys_space_delimited) {
    Loop Parse, keys_space_delimited, " " {
        SendEvent("{" . A_LoopField . " up}")
    }
}
