/// Push an item onto the stack. Returns a new stack.
func push<T>(value: T) -> State<Stack<T>, ()> {
    return State { s in ((),Stack([value] + s.values)) }
}

/// Pop an item off the stack. Returns a tuple containing the item and a new stack of the remaining elements.
func pop<T>() -> State<Stack<T>, T?> {
    return State { s in (s.top, (s.top.map { _ in Stack(dropFirst(s.values)) } ?? s)) }
}

func pop<T>(count: Int) -> State<Stack<T>, [T]> {
    switch count {
    case 0:
        return yield([])
    default:
        return
            pop().map(Array.fromOptional) >>- { head in
            pop(count - 1) >>- { tail in
                yield(head + tail)
            }}
    }
}

public struct Stack<T>: Printable, ArrayLiteralConvertible {
    // MARK: Initialisers

    public init<S: SequenceType where S.Generator.Element == T>(_ sequence: S) {
        self.values = Array(sequence)
    }

    public init() {
        self.init([])
    }

    public var top: T? {
        return values.first
    }


    // MARK: Properties

    public var count: Int {
        return values.count
    }


    // MARK: Private

    private let values: [T]

    private var tail: Slice<T> {
        let start = min(1, count)
        let end = max(start, count)
        return values[start..<end]
    }


    // MARK: Printable

    public var description: String {
        let front = top.map { ["(\($0))"] }
        let back = tail.map(toString)
        let full = front.map { front in "".join(front + back) }
        let contents = full ?? "empty"
        return "<Stack:\(contents)>"
    }


    // MARK: ArrayLiteralConvertible

    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}
