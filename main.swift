var machine = Machine(
                statement: Add(
                  left: Multiply(left: Variable(name: "x"), right: Number(value: 2)),
                  right: Multiply(left: Variable(name: "y"), right: Number(value: 4))
                ),
                environment: [
                  "x": Number(value: 5),
                  "y": Number(value: 1),
                ]
              )

machine.run()

machine = Machine(
            statement: Assign(
              name: "x",
              expression: Add(
                left: Variable(name: "x"),
                right: Number(value: 2)
              )
            ),
            environment: [
              "x": Number(value: 1)
            ]
          )

machine.run()
