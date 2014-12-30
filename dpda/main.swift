println(Stack<Int>())
println(Stack([1]))
println(Stack([1,2,3,4]))
println(Stack(1...10))

func pop<T>(count: Int, var stack: Stack<T>) -> [T] {
    return stack.pop(count)
}

var stack = Stack<Int>()
stack.push(1)
stack.push(2)
stack.push(3)

println(pop(1, Stack(1...10)))
println(pop(5, Stack(1...10)))
println(pop(2, stack))
println(pop(3, stack))
