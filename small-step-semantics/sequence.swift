struct Sequence: Statement {
  let first: Statement
  let second: Statement

  var description: String {
    return "\(first.description); \(second.description)"
  }

  var reducible: Bool {
    return true
  }

  func reduce(environment: [String: Expression]) -> (Statement, [String: Expression]) {
    if first is DoNothing {
      return (second, environment)
    }
    else {
      let (reduced, newenv) = first.reduce(environment)
      let newseq = Sequence(first: reduced, second: second)
      return (newseq, newenv)
    }
  }
}
