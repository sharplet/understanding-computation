import Set

struct NFARulebook<S: State>: Printable {
  typealias Rules = Set<FARule<S>>

  let rules: Rules

  init(_ rules: Rules) {
    self.rules = rules
  }

  func next(state: S, _ event: EventSource) -> Set<S> {
    return rulesFor(state, event).map { $0.follow() }
  }

  func freeMovesFor(states: Set<S>) -> Set<S> {
    let more = states.flatMap { self.next($0, nil) }
    return more.subset(states) ? states : freeMovesFor(states + more)
  }

  func rulesFor(state: S, _ event: EventSource) -> Rules {
    return rules.filter { rule in
      rule.appliesTo(state, event)
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
    let event = EventSource.Char(character)
    current = freeMovesFor(current).flatMap { state in
      self.rulebook.next(state, event)
    }
  }

  mutating func read(#string: String) {
    for char in string {
      read(character: char)
    }
  }

  func freeMovesFor(states: Set<S>) -> Set<S> {
    return rulebook.freeMovesFor(states)
  }

  var accepting: Bool? {
    if current.count == 0 {
      return nil
    }
    return (current & accept).count > 0
  }
}

struct NFADesign<S: State> {
  let start: S
  let accept: [S]
  let rulebook: NFARulebook<S>

  func accepts(string: String) -> Bool? {
    var nfa = NFA(current: Set([start]), accept: Set(accept), rulebook: rulebook)
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
