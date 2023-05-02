class Timer {
    static get_system_time_as_file_time_addr := DllCall(
        "GetProcAddress",
        "Ptr",
        DllCall("GetModuleHandle", "Str", "kernel32", "Ptr"),
        "AStr",
        "GetSystemTimeAsFileTime",
        "Ptr"
    )

    __new() {
        start := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &start)
        this.start := start
    }

    Reset() {
        static start := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &start)
        this.start := start
    }

    ElapsedNanoSec() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) * 100
    }

    Elapsed100NanoSec() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return current - this.start
    }

    ElapsedMicroSec() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) / 10
    }

    ElapsedMicroSecTruncated() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) // 10
    }

    ElapsedMilliSec() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) / 10000
    }

    ElapsedMilliSecTruncated() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) // 10000
    }

    ElapsedSec() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) / 10000000
    }

    ElapsedSecTruncated() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) // 10000000
    }

    ElapsedMin() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) / 600000000
    }

    ElapsedMinTruncated() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) // 600000000
    }

    ElapsedHour() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) / 3600000000
    }

    ElapsedHourTruncated() {
        static current := 0
        DllCall(Timer.get_system_time_as_file_time_addr, "Int64*", &current)
        return (current - this.start) // 3600000000
    }
}

ConvertDuration(duration, from, to) {
    ;; H=hour; M=minute; S=second mS=millisecond
    ;; uS=microsecond; 100nS=100*nanosecond; nS=nanosecond
    static duration_multipliers_wrt_ns := Map(
        "nS", 1,
        "100nS", 100,
        "uS", 1000,
        "mS", 1000000,
        "S", 1000000000,
        "M", 60000000000,
        "H", 3600000000000,
    )

    return duration * duration_multipliers_wrt_ns[from] / duration_multipliers_wrt_ns[to]
}

ConvertDurationTruncated(duration, from, to) {
    ;; H=hour; M=minute; S=second mS=millisecond
    ;; uS=microsecond; 100nS=100*nanosecond; nS=nanosecond
    static duration_multipliers_wrt_ns := Map(
        "nS", 1,
        "100nS", 100,
        "uS", 1000,
        "mS", 1000000,
        "S", 1000000000,
        "M", 60000000000,
        "H", 3600000000000,
    )

    return duration * duration_multipliers_wrt_ns[from] // duration_multipliers_wrt_ns[to]
}

;; https://www.autohotkey.com/boards/viewtopic.php?t=3401
HundredNanoSecondsSinceUT() {
    static GetSystemTimeAsFileTime := DllCall(
        "GetProcAddress",
        "Ptr",
        DllCall("GetModuleHandle", "Str", "kernel32", "Ptr"),
        "AStr",
        "GetSystemTimeAsFileTime",
        "Ptr"
    )
    static t1601 := 0
    DllCall(GetSystemTimeAsFileTime, "Int64P", &t1601)
    Return t1601
}

TimedCall(unit, fun, params*) {
    static start := 0
    start := HundredNanoSecondsSinceUT()
    fun(params*)
    return ConvertDuration(HundredNanoSecondsSinceUT() - start, "100nS", unit)
}

TimedCallTruncated(unit, fun, params*) {
    static start := 0
    start := HundredNanoSecondsSinceUT()
    fun(params*)
    return ConvertDurationTruncated(HundredNanoSecondsSinceUT() - start, "100nS", unit)
}

TimedCallWReturn(unit, fun, params*) {
    static start := 0
    start := HundredNanoSecondsSinceUT()
    ret_val := fun(params*)
    return Map(
        "duration", ConvertDuration(HundredNanoSecondsSinceUT() - start, "100nS", unit),
        "ret_val", ret_val,
    )
}

TimedCallTruncatedWReturn(unit, fun, params*) {
    static start := 0
    start := HundredNanoSecondsSinceUT()
    ret_val := fun(params*)
    return Map(
        "duration", ConvertDurationTruncated(HundredNanoSecondsSinceUT() - start, "100nS", unit),
        "ret_val", ret_val,
    )
}
