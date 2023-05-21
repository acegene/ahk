IsArrEq(lhs, rhs) {
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
