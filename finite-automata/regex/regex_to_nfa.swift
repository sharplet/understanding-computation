import Foundation

struct NFAState: Hashable, Printable {
  init() {}
  var hashValue: Int {
    return identity.hashValue
  }
  var description: String {
    return identity.description
  }
  private let identity = NSObject()
}

func ==(lhs: NFAState, rhs: NFAState) -> Bool {
  return lhs.identity == rhs.identity
}
