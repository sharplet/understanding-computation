struct Call: ExpressionType {
    let left: ExpressionType
    let right: ExpressionType

    init(_ left: ExpressionType, _ right: ExpressionType) {
        self.left = left
        self.right = right
    }

    func replace(name: String, _ replacement: ExpressionType) -> ExpressionType {
        return Call(left.replace(name, replacement), right.replace(name, replacement))
    }

    func call(argument: ExpressionType) -> ExpressionType {
        assert(false)
    }

    func reduce() -> ExpressionType {
        switch (left.reducible, right.reducible) {
        case (true, _):
            return Call(left.reduce(), right)
        case (_, true):
            return Call(left, right.reduce())
        default:
            return left.call(right)
        }
    }

    var callable: Bool {
        return false
    }

    var reducible: Bool {
        return left.reducible || right.reducible || left.callable
    }

    var description: String {
        return "\(left)[\(right)]"
    }

    var debugDescription: String {
        return description
    }
}
