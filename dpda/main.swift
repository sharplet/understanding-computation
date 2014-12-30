println(Stack<Int>())
println(Stack([1]))
println(Stack([1,2,3,4]))
println(Stack(1...10))

let stack = Stack().push(3).push(2).push(1)
println(stack.pop(1))
println(stack.pop(2))
println(stack.pop(3))
