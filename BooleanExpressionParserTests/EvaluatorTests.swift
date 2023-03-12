//
//  EvaluatorTests.swift
//  BooleanExpressionParserTests
//
//  Created by Andrey Filonov on 12/03/23.
//

import XCTest

class EvaluatorTests: XCTestCase {
     
    func testEvaluateExpression() {
        let evaluator = Evaluator()

        XCTAssertTrue(try evaluator.evaluate(expression: "true"))
        XCTAssertFalse(try evaluator.evaluate(expression: "false"))
        XCTAssertTrue(try evaluator.evaluate(expression: "true & true"))
        XCTAssertFalse(try evaluator.evaluate(expression: "true & false"))
        XCTAssertFalse(try evaluator.evaluate(expression: "false&false"))
        XCTAssertTrue(try evaluator.evaluate(expression: "true | true"))
        XCTAssertFalse(try evaluator.evaluate(expression: "false | false"))
        XCTAssertFalse(try evaluator.evaluate(expression: "false|false"))
        XCTAssertTrue(try evaluator.evaluate(expression: "true|false"))
        XCTAssertTrue(try evaluator.evaluate(expression: "true&true | false"))
        XCTAssertTrue(try evaluator.evaluate(expression: "false & false|true"))
        XCTAssertTrue(try evaluator.evaluate(expression: "false | true | false | false"))
        XCTAssertFalse(try evaluator.evaluate(expression: "false&true & true&true & true"))
    }
    
    func testEvaluateExpressionOperationPrecedence() {
        let evaluator = Evaluator()
        
        XCTAssertTrue(try evaluator.evaluate(expression: "true | false & false"))
        XCTAssertFalse(try evaluator.evaluate(expression: "(true | false) & false"))
        XCTAssertTrue(try evaluator.evaluate(expression: "false & true | true"))
        XCTAssertTrue(try evaluator.evaluate(expression: "false & true | true & true"))
        XCTAssertTrue(try evaluator.evaluate(expression: "false & true | true & true"))
        XCTAssertTrue(try evaluator.evaluate(expression: "false & true & false | true & true & true | true"))
    }
    
    func testEvaluateExpressionWithParenthesis() {
        let evaluator = Evaluator()
        
        XCTAssertTrue(try evaluator.evaluate(expression: "(true)"))
        XCTAssertFalse(try evaluator.evaluate(expression: "((false))"))
        XCTAssertTrue(try evaluator.evaluate(expression: "(true | !true)"))
        XCTAssertTrue(try evaluator.evaluate(expression: "true & !false"))
        XCTAssertTrue(try evaluator.evaluate(expression: "(true) | false"))
        XCTAssertTrue(try evaluator.evaluate(expression: "( true | false)"))
        XCTAssertFalse(try evaluator.evaluate(expression: "((true)&false)"))
        XCTAssertTrue(try evaluator.evaluate(expression: "true|(false)"))
        XCTAssertTrue(try evaluator.evaluate(expression: "!(!true)"))
        XCTAssertTrue(try evaluator.evaluate(expression: "(!(!(true & true)))"))
        XCTAssertTrue(try evaluator.evaluate(expression: "((true) & (true) | (false))"))
        XCTAssertTrue(try evaluator.evaluate(expression: "(true | false) & (true | false)"))
        XCTAssertTrue(try evaluator.evaluate(expression: "(true | (false & true)) & (true | false)"))
        XCTAssertTrue(try evaluator.evaluate(expression: "(!((!true) & false)) | (true & false)"))
        XCTAssertTrue(try evaluator.evaluate(expression: "(true | (false & true) & (true | false))"))
        XCTAssertTrue(try evaluator.evaluate(expression: "(true & true) & ((false | true) & !(false & true))"))
        XCTAssertFalse(try evaluator.evaluate(expression: "(!true) & (!false) & ((false | true) & !(false & true))"))
    }
    
    func testInvalidBinarySyntaxShouldThrowValidationError() {
        let evaluator = Evaluator()
        
        let invalidBinarySyntaxExpressions = [
            "&",
            "|",
            " & ",
            " | ",
            "true |",
            "& true",
            "&false",
            "true|",
            "true || false",
            "true | & false",
            "true & & true",
            "false&&true",
            "true & false | ",
            "&true&true&"
        ]
        
        for expression in invalidBinarySyntaxExpressions {
            XCTAssertThrowsError(try evaluator.evaluate(expression: expression)) { error in
                XCTAssertEqual(error as? ValidationError, ValidationError.invalidBinaryOperatorSyntax)
            }
        }
    }
    
    func testInvalidSyntaxShouldThrowValidationError() {
        let evaluator = Evaluator()
        
        let invalidSyntaxExpressions = [
            "()",
            "true false",
            "trrue",
            "true !false"
        ]
        
        for expression in invalidSyntaxExpressions {
            XCTAssertThrowsError(try evaluator.evaluate(expression: expression)) { error in
                XCTAssertEqual(error as? ValidationError, ValidationError.invalidSyntax)
            }
        }
    }
}
