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
