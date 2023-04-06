//
//  ValidatorTests.swift
//  BooleanExpressionParserTests
//
//  Created by Andrey Filonov on 12/03/23.
//

import XCTest

class ValidatorTests: XCTestCase {
    
    func testEmptyExpressionShouldThrowValidationError() {
        let validator = Validator()
        
        let emptyExpressions = ["", " ", "    "]
        
        for expression in emptyExpressions {
            XCTAssertThrowsError(try validator.validate(expression)) { error in
                XCTAssertEqual(error as? ValidationError, ValidationError.emptyExpression)
            }
        }
    }
    
    func testMismatchedParenthesesShouldThrowValidationError() {
        let validator = Validator()
        
        let mismatchedParenthesesExpressions = [
            "(",
            "())",
            ")(",
            ")()",
            "true)",
            "(true",
            "((false)",
            "true&false))",
            "(true | false",
            "true | false)",
            "((true) & (true)",
            "(true) & (true))",
            "(true | false) & (true | false))",
            "(!((!true) & false)) | (true & false"
        ]
        
        for expression in mismatchedParenthesesExpressions {
            XCTAssertThrowsError(try validator.validate(expression)) { error in
                XCTAssertEqual(error as? ValidationError, ValidationError.mismatchedParentheses)
            }
        }
    }
    
    func testInvalidUnarySyntaxShouldThrowValidationError() {
        let validator = Validator()
        
        let invalidUnarySyntaxExpressions = [
            "!",
            "false!",
            "true !",
            "! true",
            "!!false",
            "!true!",
            "true ! false",
            "false!true",
        ]
        
        for expression in invalidUnarySyntaxExpressions {
            XCTAssertThrowsError(try validator.validate(expression)) { error in
                XCTAssertEqual(error as? ValidationError, ValidationError.invalidUnaryOperatorSyntax)
            }
        }
    }
    
    func testInvalidCharacterShouldThrowError() {
        let validator = Validator()

        let invalidCharacterExpressions = [
            "?",
            "fal$e",
            "false *true",
            "@false"
        ]
        
        for expression in invalidCharacterExpressions {
            XCTAssertThrowsError(try validator.validate(expression)) { error in
                XCTAssertEqual(error as? ValidationError, ValidationError.invalidCharacters)
            }
        }
    }
    
}
