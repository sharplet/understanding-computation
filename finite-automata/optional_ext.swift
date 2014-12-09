extension Optional {
  func flatmap <U> (f: T -> U?) -> U? {
    switch self {
      case .Some(let s): return f(s)
      case .None:        return nil
    }
  }
}
