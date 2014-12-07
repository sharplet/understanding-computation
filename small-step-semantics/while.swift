struct While: Statement {
  let condition: Expression
  let body: Statement

  var description: String {
    return "while (\(condition.description)) { \(body.description) }"
  }

  var reducible: Bool {
    return true
  }

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    let next = Sequence(first: body, second: self)
    let this = If(condition: condition, consequence: next, alternative: DoNothing())
    return (this, environment)
  }
}
