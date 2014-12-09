struct DFARulebook<S: State>: DebugPrintable {
  typealias Rules = [FARule<S>]

  let rules: Rules

  init(_ rules: Rules) {
    self.rules = rules
  }

  func next(state: S, _ character: Character) -> S? {
    return ruleFor(state, character)?.follow()
  }

  func ruleFor(state: S, _ character: Character) -> FARule<S>? {
    return rules.detect { rule in
      rule.appliesTo(state, character)
    }
  }

  var debugDescription: String {
    let ruleDescription = ",\n  ".join(rules.map { r in r.description })
    return "<DFARuleBook rules:(\n  \(ruleDescription)\n)>"
  }
}

struct DFA<S: State> {
  var current: S?
  let accept: [S]
  let rulebook: DFARulebook<S>

  mutating func read(#character: Character) {
    current = current.flatmap { current in
      self.rulebook.next(current, character)
    }
  }

  mutating func read(#string: String) {
    for char in string {
      read(character: char)
    }
  }

  var accepting: Bool? {
    return current.map { current in contains(self.accept, current) }
  }
}

struct DFADesign<S: State> {
  let start: S
  let accept: [S]
  let rulebook: DFARulebook<S>

  func accepts(string: String) -> Bool? {
    var dfa = DFA(current: start, accept: accept, rulebook: rulebook)
    dfa.read(string: string)
    return dfa.accepting
  }

  func test(string: String) -> String {
    if let result = accepts(string) {
      return "Accepts \"\(string)\"? \(result)"
    }
    else {
      return "Failed when testing \"\(string)\""
    }
  }

  func test(strings: String...) -> [String] {
    return strings.map { string in self.test(string) }
  }
}
