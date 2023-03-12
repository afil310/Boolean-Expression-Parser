//
//  main.swift
//  BooleanExpressionParser
//
//  Created by Andrey Filonov on 12/03/23.
//

import Foundation

let inputs = [
    "true",
    "false",
    "(true)",
    "(false)",
    "!true",
    "!false",
    "!!true",
    "!!false",
    "!(!true)",
    "!(!false)",
    "true & false",
    "true | false",
    "true & false | true",
    "true & false | true & false",
    "true | false & true & false",
    "!true & false",
    "!true | false",
    "!(true & false)",
    "!(true | false)",
    "(true & false) | (true | false)",
    "!(true & false) | !(true | false)",
    "!(!true & !(true | (false | true)))",
    "(!(!(true | (false | !(true & false)) | false)))",
    "(!(!(true & (false | !(true & false) & false))))",
    "(!(!(true & (true | !(true & false) & false))))",
    "true|true&false",
    "false&true|true",
    "true $",
    "& true",
    "true || false",
    "true ! false",
    "true)",
    "(true",
    "true &"
]

let evaluator = Evaluator()

for input in inputs {
    do {
        let result = try evaluator.evaluate(expression: input)
        print("\(input) = \(result)")
    } catch let error {
        print("Syntax error in '\(input)' - \(error.localizedDescription)")
    }
}
