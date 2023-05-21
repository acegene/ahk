HasVal(arr, val) {
    if !(IsObject(arr)) || (arr.Length() = 0)
        return 0
    for index, value in arr
        if (value = val)
            return index
    return 0
}

SleepRandom(sleep_duration, min := 1.0, max := 1.1) {
    Random(duration_secs, min * sleep_duration, max * sleep_duration)
    Sleep(duration_secs)
}
