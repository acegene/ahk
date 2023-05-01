SleepRandom(duration_sleep_base, min := 1.0, max := 1.1) {
    duration_sleep := Random(min * duration_sleep_base, max * duration_sleep_base)
    Sleep(duration_sleep)
}
