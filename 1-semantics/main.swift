var machine = Machine(
                statement: Add(
                  left: Multiply(left: Variable(name: "x"), right: Number(2)),
                  right: Multiply(left: Variable(name: "y"), right: Number(4))
                ),
                environment: [
                  "x": Number(5),
                  "y": Number(1),
                ]
              )

machine.run()

machine = Machine(
            statement: Assign(
              name: "x",
              expression: Add(
                left: Variable(name: "x"),
                right: Number(2)
              )
            ),
            environment: [
              "x": Number(1)
            ]
          )

machine.run()

machine = Machine(
            statement: If(
              condition: LessThan(left: Variable(name: "x"), right: Number(10)),
              consequence: Assign(name: "y", expression: Number(1)),
              alternative: Assign(name: "y", expression: Number(2))
            ),
            environment: [
              "x": Number(5)
            ]
          )

machine.run()

machine = Machine(
            statement: Sequence(
              first: Assign(name: "x", expression: Add(left: Number(1), right: Number(1))),
              second: Assign(name: "y", expression: Add(left: Variable(name: "x"), right: Number(3)))
            )
          )

machine.run()
