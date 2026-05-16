#Requires AutoHotkey v2.0

#include "%A_ScriptDir%\..\array-utils.ahk"

AssertEqual(actual, expected, label := "") {
    if (actual != expected) {
        MsgBox "❌ Test failed: " label "`nExpected: " expected "`nGot: " actual
        ExitApp 1
    }
}

TestCircularBuffer() {
    buffer_size := 5

    buf := CircularBuffer(buffer_size)

    Loop buffer_size {
        buf.Push(A_Index)
    }

    AssertEqual(buf.Length, buffer_size, "Buffer should hold " . buffer_size . " items")
    AssertEqual(Max(buf*), buffer_size, "Buffer max value should be " . buffer_size)
    AssertEqual(Min(buf*), 1, "Buffer max value should be " . 1)

    Loop buffer_size {
        AssertEqual(buf[A_Index], A_Index, "Initial insert check " A_Index)
    }

    ; Push 2 more items — val1 and val2 should be overwritten
    buf.Push(6)
    buf.Push(7)

    expected := [3, 4, 5, 6, 7]

    AssertEqual(buf.Length, buffer_size, "Buffer should still have " . buffer_size . " items after overwrite")
    AssertEqual(Max(buf*), expected[expected.Length], "Buffer max value should be " . expected[expected.Length])
    AssertEqual(Min(buf*), expected[1], "Buffer max value should be " . expected[1])

    i := 0
    for (val in buf) {
        i += 1
        AssertEqual(val, expected[i], "Overwrite check " i)
    }

    i := 0
    for (_, val in buf) {
        i += 1
        AssertEqual(val, expected[i], "Overwrite check " i)
    }

    for (i, val in buf) {
        AssertEqual(val, expected[i], "Overwrite check " i)
    }

    MsgBox "✅ All CircularBuffer tests passed!"
}

TestCircularBuffer()
