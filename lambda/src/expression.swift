protocol ExpressionType: Printable, DebugPrintable {
    func replace(name: String, _ replacement: ExpressionType) -> ExpressionType
    func call(argument: ExpressionType) -> ExpressionType
    func reduce() -> ExpressionType
    var callable: Bool { get }
    var reducible: Bool { get }
}
