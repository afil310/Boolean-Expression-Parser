//
//  Evaluator.swift
//  BooleanExpressionParser
//
//  Created by Andrey Filonov on 12/03/23.
//

import Foundation

class Evaluator {
    
    // MARK: - Constants
    
    private let operatorNOT = Constants.operatorNOT
    private let operatorAND = Constants.operatorAND
    private let operatorOR = Constants.operatorOR
    private let trueString = Constants.trueString
    private let falseString = Constants.falseString
    private let leftParenthesis = Constants.leftParenthesis
    private let rightParenthesis = Constants.rightParenthesis
    
    private let validator = Validator()
    
    // MARK: - Public Methods
    
    // Evaluates a boolean expression and returns a Boolean value
    func evaluate(expression: String) throws -> Bool {
        do {
            try validator.validate(expression)
            
            /// Evaluate sub-expressions in parentheses and replace each sub-expression with it's result in `expression` string
            var expression = expression
            while let subExpression = getFirstParenthesesSubstring(expression) {
                let evaluatedSubExpression = try evaluateStringAsBooleanExpression(subExpression) ? trueString : falseString
                let subExpressionInParentheses = [String(leftParenthesis), subExpression, String(rightParenthesis)].joined()
                expression = expression.replacingOccurrences(of: subExpressionInParentheses, with: evaluatedSubExpression)
            }
            
            // Evaluate final expression
            return try evaluateStringAsBooleanExpression(expression)
            
        } catch(let error) {
            throw error
        }
    }
    
    // MARK: - Private Methods
    
    // Returns the first substring in parentheses in the input expression
    private func getFirstParenthesesSubstring(_ expression: String) -> String? {
        var stack = [Int]()
        let characters = Array(expression)
        for (index, char) in characters.enumerated() {
            if char == leftParenthesis {
                stack.append(index)
            } else if char == rightParenthesis {
                if let leftParenthesisIndex = stack.popLast() {
                    let substring = String(characters[leftParenthesisIndex+1..<index])
                    if !substring.isEmpty {
                        return substring
                    }
                }
            }
        }
        return nil
    }
    
    // Evaluates a string as a boolean expression and returns a Boolean value
    private func evaluateStringAsBooleanExpression(_ input: String) throws -> Bool {
        let expression = reduceNOTOperatorsAndWhitespaces(input)
        
        do {
            try validator.validateBooleanSyntax(expression)
        } catch (let error) {
            throw error
        }
        
        // Split the input into subexpressions based on OR operators
        let subExpressions = expression.split(separator: operatorOR)
        guard !subExpressions.isEmpty else {
            throw ValidationError.invalidBinaryOperatorSyntax
        }
        
        // Evaluate each subexpression separately
        var result = false
        for subExpression in subExpressions {
            let operands = subExpression.split { $0 == operatorAND }
            guard !operands.isEmpty, let subExpressionResultString = operands.first else {
                throw ValidationError.invalidBinaryOperatorSyntax
            }
            var subExpressionBoolValue = subExpressionResultString == trueString
            for operand in operands.dropFirst() {
                let operandBoolValue = (operand == trueString)
                subExpressionBoolValue = subExpressionBoolValue && operandBoolValue // Evaluate all AND operators left to right
            }
            result = result || subExpressionBoolValue // Evaluate all OR operators left to right
        }
        return result
    }
    
    // Replaces NOT operators in the input string with the evaluated values
    private func reduceNOTOperatorsAndWhitespaces(_ input: String) -> String {
        let notTrueSubstring = String(operatorNOT) + trueString
        let notFalseSubstring = String(operatorNOT) + falseString
        return input.replacingOccurrences(of: notTrueSubstring, with: falseString)
            .replacingOccurrences(of: notFalseSubstring, with: trueString)
            .replacingOccurrences(of: " ", with: "")
    }
}

