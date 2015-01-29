let one = Function("p", Function("x", Call(Variable("p"), Variable("x"))))
println(one)

let increment =
    Function("n",
        Function("p",
            Function("x",
                Call(
                    Variable("p"),
                    Call(
                        Call(Variable("n"), Variable("p")),
                        Variable("x")
                    )
                )
            )
        )
    )
println(increment)

let add =
    Function("m",
        Function("n",
            Call(Call(Variable("n"), increment), Variable("m"))
        )
    )
println(add)

let addTwo = Call(Call(add, one), one)

let inc = Variable("inc")
let zero = Variable("zero")
var expression: ExpressionType = Call(Call(addTwo, inc), zero)
while expression.reducible {
    println(expression)
    expression = expression.reduce()
}
println(expression)
