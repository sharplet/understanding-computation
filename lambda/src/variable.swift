struct Variable: Printable, DebugPrintable {
    let name: String

    init(_ name: String) {
        self.name = name
    }

    var description: String {
        return name
    }

    var debugDescription: String {
        return description
    }
}
