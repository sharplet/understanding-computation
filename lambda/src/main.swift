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
