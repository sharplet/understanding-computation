/// Describes an interface for an immutable Stack type.
protocol StackType {
    /// The type of the elements in the stack.
    typealias Element

    /// Push an item onto the stack. Returns a new stack.
    func push(value: Element) -> Self

    /// Pop an item off the stack. Returns a tuple containing the item and a new stack of the remaining elements.
    func pop() -> (Element, Self)?

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

    public func push(value: T) -> Stack {
        return Stack([value] + values)
    }

    public func pop() -> (T, Stack)? {
        return top.map { ($0, Stack(self.tail)) }
    }

    public func pop(count: Int) -> ([T], Stack) {
        if let (tip, tail) = pop() {
            if count > 1 {
                let popped = tail.pop(count - 1)
                return ([tip] + popped.0, popped.1)
            }
            else {
                return ([tip], tail)
            }
        }
        else {
            return ([], self)
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

    private let values: [T]

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
