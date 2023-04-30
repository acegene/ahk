IsArrEq(lhs, rhs) {
    if (lhs.Length != rhs.Length) {
        return False
    }

    Loop lhs.Length {
        if (lhs[A_index] != rhs[A_index]) {
            return False
        }
    }

    return True
}
