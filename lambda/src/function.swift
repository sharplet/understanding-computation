struct Function<T: Printable>: Printable, DebugPrintable {
    let parameter: String
    let body: T

    init(_ parameter: String, _ body: T) {
        self.parameter = parameter
        self.body = body
    }

    var description: String {
        return "-> \(parameter) { \(body) }"
    }

    var debugDescription: String {
        return description
    }
}
