HoldKeyE(key, duration) {
    SendEvent("{" . key . " down}")
    Sleep(duration)
    SendEvent("{" . key . " up}")
}

HoldTwoKeyE(key_1, key_2, duration) {
    SendEvent("{" . key_1 . " down}{" . key_2 . " down}")
    Sleep(duration)
    SendEvent("{" . key_1 . " up}{" . key_2 . " up}")
}

RepeatHoldKeyForDurationE(key, duration_key_press, duration_repeat) {
    end_time := A_TickCount + duration_repeat
    while (A_TickCount < end_time) {
        HoldKeyE(key, duration_key_press)
    }
}

ClearHeldKeysE(keys_space_delimited) {
    Loop Parse, keys_space_delimited, " " {
        SendEvent("{" . A_LoopField . " up}")
    }
}
