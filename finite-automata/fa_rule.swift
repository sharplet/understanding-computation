typealias State = protocol<Hashable, Printable>

struct FARule<S: State>: Printable, Hashable {
  typealias Transition = (char: Character, dest: S)

  let state: S
  let transition: Transition

  init(_ state: S, transition: Transition) {
    self.state = state
    self.transition = transition
  }

  func appliesTo(state: S, _ character: Character) -> Bool {
    return self.state == state && self.transition.char == character
  }

  func follow() -> S {
    return transition.dest
  }

  var description: String {
    return "<FARule \(state) --\(transition.char)--> \(transition.dest)>"
  }

  var hashValue: Int {
    return state.hashValue ^ transition.char.hashValue ^ transition.dest.hashValue
  }
}

func == <S: State> (lhs: FARule<S>, rhs: FARule<S>) -> Bool {
  return lhs.state == rhs.state
      && lhs.transition.char == rhs.transition.char
      && lhs.transition.dest == rhs.transition.dest
}
