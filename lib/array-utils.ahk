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

class CircularBuffer {
    __New(size) {
        this._size := size
        this._data := []
        this._start := 0
        this._count := 0
    }

    __Enum(mode := 1) {
        i := 0

        if (mode = 3) {
            return (&k, &v) => (
                ++i <= this.Length
                    ? (k := i, v := this[i], true)
                : false
            )
        }
        if (mode = 2) {
            return (&k, &v) => (
                ++i <= this.Length
                    ? (k := i, v := this[i], true)
                : false
            )
        }

        return (&v) => (
            ++i <= this.Length
                ? (v := this[i], true)
            : false
        )
    }

    __Item[i] {
        get {
            if (i < 1 || i > this.Length) {
                throw Error("Index out of bounds")
            }
            actualIndex := Mod(this._start + i - 1, this._size)
            return this._data[actualIndex + 1]
        }
        set {
            if (i < 1 || i > this.Length) {
                throw Error("Index out of bounds")
            }
            actualIndex := Mod(this._start + i - 1, this._size)
            this._data[actualIndex + 1] := value
        }
    }


    Push(value) {
        if (this._count < this._size) {
            this._data.Push(value)
            this._count += 1
        } else {
            insertIndex := Mod(this._start + this._count, this._size)
            this._data[insertIndex + 1] := value
            this._start := Mod(this._start + 1, this._size)
        }
    }

    Length {
        get => this._count
    }
}
