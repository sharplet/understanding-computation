struct Set<T: protocol<Hashable, Printable>>: Printable {
  private typealias Store = [T: Void]

  private var _store: Store

  init(_ ts: [T]) {
    var store = Store()
    for t in ts {
      store[t] = ()
    }
    _store = store
  }

  init(_ ts: T...) {
    self.init(ts)
  }

  private init(_ store: Store) {
    _store = store
  }

  var description: String {
    let contents = ",".join(_store.keys.map { $0.description })
    return "<Set:{\(contents)}>"
  }

  var count: Int {
    return _store.count
  }

  // Operations

  func contains(t: T) -> Bool {
    return _store[t] != nil
  }

  func union(otherSet: Set<T>) -> Set<T> {
    return Set(merge(_store, otherSet._store))
  }

  func intersection(otherSet: Set<T>) -> Set<T> {
    return Set(subset(_store, otherSet._store.keys))
  }

  mutating func insert(t: T) {
    _store[t] = ()
  }

  func map<U>(f: T -> U) -> Set<U> {
    var result = Set<U>()
    for (t, _) in _store {
      result.insert(f(t))
    }
    return result
  }

  func mapm<U>(f: T -> () -> U) -> Set<U> {
    return Set<U>(main.mapm(self, f))
  }

  func flatmap<U>(f: T -> Set<U>) -> Set<U> {
    var result = Set<U>()
    for (t, _) in _store {
      result = result.union(f(t))
    }
    return result
  }
}

extension Set: SequenceType {
  func generate() -> GeneratorOf<T> {
    var generator = _store.keys.generate()
    return GeneratorOf {
      generator.next()
    }
  }
}

private func merge<K, V>(var a: [K:V], b: [K:V]) -> [K: V] {
  for (k, v) in b {
    a[k] = v
  }
  return a
}

private func subset<K, V, Keys: SequenceType where Keys.Generator.Element == K>(dict: [K:V], keys: Keys) -> [K:V] {
  var result = [K:V]()
  for key in keys {
    if let value = dict[key] {
      result[key] = value
    }
  }
  return result
}
