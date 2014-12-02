let machines = [
  "simple": Machine(
    statement: Add(
      left: Multiply(left: Variable(name: "x"), right: Number(2)),
      right: Multiply(left: Variable(name: "y"), right: Number(4))
    ),
    environment: [
      "x": Number(5),
      "y": Number(1),
    ]
  ),
  "assignment": Machine(
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
  ),
  "conditional": Machine(
    statement: If(
      condition: LessThan(left: Variable(name: "x"), right: Number(10)),
      consequence: Assign(name: "y", expression: Number(1)),
      alternative: Assign(name: "y", expression: Number(2))
    ),
    environment: [
      "x": Number(5)
    ]
  ),
  "sequence": Machine(
    statement: Sequence(
      first: Assign(name: "x", expression: Add(left: Number(1), right: Number(1))),
      second: Assign(name: "y", expression: Add(left: Variable(name: "x"), right: Number(3)))
    )
  ),
]

for (name, var machine) in machines {
  println()
  println("Running \"\(name)\"...")
  machine.run()
}
