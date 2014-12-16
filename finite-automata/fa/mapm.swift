func mapm<S : SequenceType, T>(source: S, transform: (S.Generator.Element) -> () -> T) -> [T] {
  var result = [T]()
  for t in source {
    result.append(transform(t)())
  }
  return result
}
