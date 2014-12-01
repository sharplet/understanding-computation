import Darwin


protocol Expression: Printable {
  var reducible: Bool { get }
  func reduce(environment: [String: Expression]) -> Expression
}


// Numberber

struct Number {
  let value: Int
}

extension Number: Expression {
  var description: String {
    return "\(value)"
  }

  var reducible: Bool {
    return false
  }

  func reduce(environment: [String: Expression]) -> Expression {
    abort()
  }
}


// Addition

struct Add {
  let left: Expression
  let right: Expression
}

extension Add: Expression {
  var description: String {
    return "\(left.description) + \(right.description)"
  }

  var reducible: Bool {
    return true
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
      return Number(value: l!.value + r!.value)
    }
  }
}


// Multiply

struct Multiply {
  let left: Expression
  let right: Expression
}

extension Multiply: Expression {
  var description: String {
    return "\(left.description) * \(right.description)"
  }

  var reducible: Bool {
    return true
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
      return Number(value: l!.value * r!.value)
    }
  }
}


// Machine

struct Machine {
  var expression: Expression

  mutating func step() {
    expression = expression.reduce([:])
  }

  mutating func run() {
    while expression.reducible {
      print()
      step()
    }
    print()
  }

  func print() {
    println("‹\(expression.description)›")
  }
}


// main

var machine = Machine(expression:
                Add(
                  left: Multiply(left: Number(value: 1), right: Number(value: 2)),
                  right: Multiply(left: Number(value: 3), right: Number(value: 4))
                )
              )

machine.run()
