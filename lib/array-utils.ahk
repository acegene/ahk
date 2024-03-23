AreArrsEq(lhs, rhs) {
    if (lhs.Length != rhs.Length) {
        return false
    }

    Loop lhs.Length {
        if (lhs[A_index] != rhs[A_index]) {
            return false
        }
    }

    return true
}

ArrHasVal(arr, val) {
    for (index, arr_val in arr) {
        if (val == arr_val) {
            return true
        }
    }
    return false
}
