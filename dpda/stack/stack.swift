/// Describes an interface for an immutable Stack type.
protocol StackType {
    /// The type of the elements in the stack.
    typealias Element

    /// Push an item onto the stack.
    mutating func push(value: Element)

    /// Pop an item off the stack.
    mutating func pop() -> Element?

    /// Inspect the top of the stack.
    var top: Element? { get }
}

public struct Stack<T>: StackType, Printable, ArrayLiteralConvertible {
    // MARK: Initialisers

    public init<S: SequenceType where S.Generator.Element == T>(_ sequence: S) {
        self.values = Array(sequence)
    }

    public init() {
        self.init([])
    }


    // MARK: StackType

    public mutating func push(value: T) {
        values.append(value)
    }

    public mutating func pop() -> T? {
        return count == 0 ? nil : values.removeAtIndex(0)
    }

    public mutating func pop(count: Int) -> [T] {
        if let tip = pop() {
            if count > 1 {
                return [tip] + pop(count - 1)
            }
            else {
                return [tip]
            }
        }
        else {
            return []
        }
    }

    public var top: T? {
        return values.first
    }


    // MARK: Properties

    public var count: Int {
        return values.count
    }


    // MARK: Private

    private var values: [T]

    private var tail: Slice<T> {
        let start = min(1, count)
        let end = max(start, count)
        return values[start..<end]
    }


    // MARK: Printable

    public var description: String {
        let front = (top.map { [$0] } ?? []).map { "(\($0))" }
        let back = tail.map(toString)
        return "".join(front + back)
    }


    // MARK: ArrayLiteralConvertible

    public init(arrayLiteral elements: T...) {
        self.init(elements)
    }
}
