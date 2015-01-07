/// An immutable stack with operations in the State monad.
public struct Stack<T>: Printable, ArrayLiteralConvertible {
    // MARK: Initialisers

    public init<S: SequenceType where S.Generator.Element == T>(_ sequence: S) {
        self.values = Array(sequence)
    }

    public init() {
        self.init([])
    }


    // MARK: ArrayLiteralConvertible

    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }


    // MARK: Properties

    public var top: T? {
        return values.first
    }

    public var count: Int {
        return values.count
    }


    // MARK: Printable

    public var description: String {
        let front = top.map { ["(\($0))"] }
        let back = tail.map(toString)
        let full = front.map { front in "".join(front + back) }
        let contents = full ?? "empty"
        return "<Stack:\(contents)>"
    }


    // MARK: Private

    private let values: [T]

    private var tail: Slice<T> {
        let start = min(1, count)
        let end = max(start, count)
        return values[start..<end]
    }
}


// MARK: Operations

/// Stateful operation to produce a new stack with `value` pushed onto it.
func push<T>(value: T) -> State<Stack<T>, ()> {
    return State { s in ((),Stack([value] + s.values)) }
}

/// Stateful operation to pop the top element of a stack. If the stack has no elements, the result of this operation will be `nil` and the stack unchanged.
func pop<T>() -> State<Stack<T>, T?> {
    return State { s in
        if let head = s.top {
            return (head, Stack(dropFirst(s.values)))
        }
        else {
            return (nil, s)
        }
    }
}

/// Stateful operation to pop up to `count` elements from the stack and collect them as an array.
func pop<T>(count: Int) -> State<Stack<T>, [T]> {
    precondition(count >= 0, "can't pop a negative number of times! (\(count))")
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
