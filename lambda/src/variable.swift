struct Variable: ExpressionType {
    let name: String

    init(_ name: String) {
        self.name = name
    }

    func replace(name: String, _ replacement: ExpressionType) -> ExpressionType {
        if self.name == name {
            return replacement
        }
        else {
            return self
        }
    }

    func call(argument: ExpressionType) -> ExpressionType {
        assert(false)
    }

    func reduce() -> ExpressionType {
        assert(false)
    }

    var callable: Bool {
        return false
    }

    var reducible: Bool {
        return false
    }

    var description: String {
        return name
    }

    var debugDescription: String {
        return description
    }
}
