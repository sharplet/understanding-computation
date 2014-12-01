import Darwin

protocol Term: Printable {
  var reducible: Bool { get }
}

protocol Statement: Term {
  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression])
}

protocol Expression: Statement {
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

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    abort()
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
      return Number(value: l!.value * r!.value)
    }
  }
}


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

extension Dictionary {
  func merge(other: [Key: Value]) -> [Key: Value] {
    var merged = self
    for (key, value) in other {
      merged[key] = value
    }
    return merged
  }
}


// Machine

struct Machine {
  var statement: Statement
  var environment: [String: Expression]

  init(statement: Statement, environment: [String: Expression] = [:]) {
    self.statement = statement
    self.environment = environment
  }

  mutating func step() {
    (statement, environment) = statement.reduce(environment)
  }

  mutating func run() {
    while statement.reducible {
      print()
      step()
    }
    print()
  }

  func print() {
    let stmt = "‹\(statement.description)›"

    let env = reduce(environment, []) { (var out: [String], entry: (String, Expression)) in
      out.append("\(entry.0) = \(entry.1.description)")
      return out
    }

    let output: String = {
      if env.count > 0 {
        let joined = join(", ", env)
        return stmt + " (\(joined))"
      }
      else {
        return stmt
      }
    }()

    println(output)
  }
}


// main

var machine = Machine(
                statement: Add(
                  left: Multiply(left: Variable(name: "x"), right: Number(value: 2)),
                  right: Multiply(left: Variable(name: "y"), right: Number(value: 4))
                ),
                environment: [
                  "x": Number(value: 5),
                  "y": Number(value: 1),
                ]
              )

machine.run()

machine = Machine(
            statement: Assign(
              name: "x",
              expression: Add(
                left: Variable(name: "x"),
                right: Number(value: 2)
              )
            ),
            environment: [
              "x": Number(value: 1)
            ]
          )

machine.run()
