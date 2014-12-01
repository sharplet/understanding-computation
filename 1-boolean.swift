import Darwin

struct Boolean: Expression {
  let value: Bool

  var description: String {
    return value.description
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

struct LessThan: Expression {
  let left: Expression
  let right: Expression

  var description: String {
    return "\(left.description) < \(right.description)"
  }

  var reducible: Bool {
    return true
  }

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    return (reduce(environment), environment)
  }

  func reduce(environment: [String: Expression]) -> Expression {
    switch (left.reducible, right.reducible) {
    case (true, _):
      return LessThan(left: left.reduce(environment), right: right)
    case (_, true):
      return LessThan(left: left, right: right.reduce(environment))
    default:
      let l = left as? Number
      let r = right as? Number
      return Boolean(value: l!.value < r!.value)
    }
  }
}

struct GreaterThan: Expression {
  let left: Expression
  let right: Expression

  var description: String {
    return "\(left.description) > \(right.description)"
  }

  var reducible: Bool {
    return true
  }

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    return (reduce(environment), environment)
  }

  func reduce(environment: [String: Expression]) -> Expression {
    switch (left.reducible, right.reducible) {
    case (true, _):
      return LessThan(left: left.reduce(environment), right: right)
    case (_, true):
      return LessThan(left: left, right: right.reduce(environment))
    default:
      let l = left as? Number
      let r = right as? Number
      return Boolean(value: l!.value > r!.value)
    }
  }
}
