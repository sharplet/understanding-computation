typealias State = protocol<Hashable, Printable>

struct FARule<S: State>: Printable, Hashable {
  typealias Transition = (source: EventSource, destination: S)

  let state: S
  let transition: Transition

  init(_ state: S, transition: Transition) {
    self.state = state
    self.transition = transition
  }

  func appliesTo(state: S, _ event: EventSource) -> Bool {
    switch (transition.source, event) {
    case (.Char(let char), .Char(let other)):
      return self.state == state && char == other
    case (.Free, .Free):
      return self.state == state
    default:
      return false
    }
  }

  func follow() -> S {
    return transition.destination
  }

  var description: String {
    return "<FARule \(state) --\(transition.source)--> \(transition.destination)>"
  }

  var hashValue: Int {
    return state.hashValue ^ transition.source.hashValue ^ transition.destination.hashValue
  }
}

func == <S: State> (lhs: FARule<S>, rhs: FARule<S>) -> Bool {
  return lhs.state == rhs.state
      && lhs.transition.source == rhs.transition.source
      && lhs.transition.destination == rhs.transition.destination
}
