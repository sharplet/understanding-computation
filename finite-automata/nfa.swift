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
