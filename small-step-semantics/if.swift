struct If: Statement {
  let condition: Expression
  let consequence: Statement
  let alternative: Statement

  var description: String {
    return "if (\(condition.description)) { \(consequence.description) }\nelse { \(alternative.description) }"
  }

  var reducible: Bool {
    return true
  }

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    if condition.reducible {
      return ( If(condition: condition.reduce(environment), consequence: consequence, alternative: alternative)
             , environment
             )
    }
    else {
      let decision = condition as? Boolean
      if decision!.value {
        return (consequence, environment)
      }
      else {
        return (alternative, environment)
      }
    }
  }
}
