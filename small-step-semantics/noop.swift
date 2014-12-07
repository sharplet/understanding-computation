import Darwin

struct DoNothing: Expression {
  var description: String {
    return "do-nothing"
  }

  var reducible: Bool {
    return false
  }

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    abort()
  }

  func reduce(environment: [String: Expression]) -> Expression {
    abort()
  }
}
