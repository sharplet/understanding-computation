// Variables

struct Variable: Expression {
  let name: String

  var description: String {
    return name
  }

  var reducible: Bool {
    return true
  }

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    return (reduce(environment), environment)
  }

  func reduce(environment: [String: Expression]) -> Expression {
    return environment[name]!
  }
}


// Assignment

struct Assign: Statement {
  let name: String
  let expression: Expression

  var description: String {
    return "\(name) = \(expression.description)"
  }

  var reducible: Bool {
    return true
  }

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    if expression.reducible {
      return ( Assign(name: name, expression: expression.reduce(environment))
             , environment
             )
    }
    else {
      return ( DoNothing()
             , environment.merge([name: expression])
             )
    }
  }
}

private extension Dictionary {
  func merge(other: [Key: Value]) -> [Key: Value] {
    var merged = self
    for (key, value) in other {
      merged[key] = value
    }
    return merged
  }
}
