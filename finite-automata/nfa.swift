struct NFARulebook<S: protocol<State, Hashable>>: Printable {
  typealias Rules = [FARule<S>]

  let rules: Rules

  init(_ rules: Rules) {
    self.rules = rules
  }

  func next(state: S, _ character: Character) -> Set<S> {
    return Set(rulesFor(state, character)).mapm(FARule.follow)
  }

  func rulesFor(state: S, _ character: Character) -> [FARule<S>] {
    return rules.select { rule in
      rule.appliesTo(state, character)
    }
  }

  var description: String {
    let ruleDescription = ",\n  ".join(rules.map { r in r.description })
    return "<NFARuleBook rules:(\n  \(ruleDescription)\n)>"
  }
}

struct NFA<S: State> {
  var current: Set<S>
  let accept: Set<S>
  let rulebook: NFARulebook<S>

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
    if current.count == 0 {
      return nil
    }
    return current.intersection(accept).count > 0
  }
}

struct NFADesign<S: State> {
  let start: S
  let accept: [S]
  let rulebook: NFARulebook<S>

  func accepts(string: String) -> Bool? {
    var nfa = NFA(current: Set(start), accept: Set(accept), rulebook: rulebook)
    nfa.read(string: string)
    return nfa.accepting
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
