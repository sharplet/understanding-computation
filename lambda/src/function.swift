struct Function: ExpressionType {
    let parameter: String
    let body: ExpressionType

    init(_ parameter: String, _ body: ExpressionType) {
        self.parameter = parameter
        self.body = body
    }

    func replace(name: String, _ replacement: ExpressionType) -> ExpressionType {
        if parameter == name {
            return self
        }
        else {
            return Function(parameter, body.replace(name, replacement))
        }
    }

    func call(argument: ExpressionType) -> ExpressionType {
        return body.replace(parameter, argument)
    }

    func reduce() -> ExpressionType {
        assert(false)
    }

    var callable: Bool {
        return true
    }

    var reducible: Bool {
        return false
    }

    var description: String {
        return "-> \(parameter) { \(body) }"
    }

    var debugDescription: String {
        return description
    }
}
