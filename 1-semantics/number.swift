import Darwin

// Number

struct Number: Expression {
  let value: Int

  init(_ value: Int) {
    self.value = value
  }

  var description: String {
    return "\(value)"
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


// Addition

struct Add: Expression {
  let left: Expression
  let right: Expression

  var description: String {
    return "\(left.description) + \(right.description)"
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
      return Add(left: left.reduce(environment), right: right)
    case (_, true):
      return Add(left: left, right: right.reduce(environment))
    default:
      let l = left as? Number
      let r = right as? Number
      return Number(l!.value + r!.value)
    }
  }
}


// Multiply

struct Multiply: Expression {
  let left: Expression
  let right: Expression

  var description: String {
    return "\(left.description) * \(right.description)"
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
      return Add(left: left.reduce(environment), right: right)
    case (_, true):
      return Add(left: left, right: right.reduce(environment))
    default:
      let l = left as? Number
      let r = right as? Number
      return Number(l!.value * r!.value)
    }
  }
}
