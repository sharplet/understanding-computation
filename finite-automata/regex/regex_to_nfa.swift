import Set

// MARK: NFAConvertible

protocol NFAConvertible {
  func toNFADesign() -> NFADesign<NFAState>
}


// MARK: Pattern types

extension Empty: NFAConvertible {
  func toNFADesign() -> NFADesign<NFAState> {
    let start = NFAState()
    let accept = start
    let rulebook = NFARulebook(Set<FARule<NFAState>>())
    return NFADesign(start: start, accept: [accept], rulebook: rulebook)
  }
}

extension Literal: NFAConvertible {
  func toNFADesign() -> NFADesign<NFAState> {
    let start = NFAState()
    let accept = NFAState()
    let rule = FARule(start, transition: (EventSource.Char(character), accept))
    let rulebook = NFARulebook([rule])
    return NFADesign(start: start, accept: [accept], rulebook: rulebook)
  }
}


// MARK: NFAState

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
