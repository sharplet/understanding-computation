struct Call<T: Printable, U: Printable>: Printable, DebugPrintable {
    let left: T
    let right: U

    init(_ left: T, _ right: U) {
        self.left = left
        self.right = right
    }

    var description: String {
        return "\(left)[\(right)]"
    }

    var debugDescription: String {
        return description
    }
}
