protocol Term: Printable {
  var reducible: Bool { get }
}

protocol Statement: Term {
  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression])
}

protocol Expression: Statement {
  func reduce(environment: [String: Expression]) -> Expression
}
