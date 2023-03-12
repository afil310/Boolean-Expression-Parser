//
//  Validator.swift
//  BooleanExpressionParser
//
//  Created by Andrey Filonov on 12/03/23.
//

import Foundation

struct Validator {
    
    // MARK: - Constants
    
    private let operatorNOT = Constants.operatorNOT
    private let operatorAND = Constants.operatorAND
    private let operatorOR = Constants.operatorOR
    private let trueString = Constants.trueString
    private let falseString = Constants.falseString
    private let leftParenthesis = Constants.leftParenthesis
    private let rightParenthesis = Constants.rightParenthesis
    
    // MARK: - Properties
    
    private let unaryOperators: Set<Character>
    private let binaryOperators: Set<Character>
    private var allowedChars: Set<Character>
    private let booleans: [String]
    
    // MARK: - Initialization
    
    init() {
        let syntaxChars: Set<Character> = [leftParenthesis, rightParenthesis, " "]
        unaryOperators = [operatorNOT]
        binaryOperators = [operatorAND, operatorOR]
        booleans = [trueString, falseString]
        
        allowedChars = syntaxChars.union(binaryOperators).union(unaryOperators)
        for char in booleans.joined() {
            allowedChars.insert(char)
        }
    }
    
    // MARK: - Public Methods
    
    func validate(_ expression: String) throws {
        try validateExpressionIsNotEmpty(expression)
        try validateAllowedCharacters(in: expression)
        for unaryOperator in unaryOperators {
            try validateUnaryOperatorSyntax(unaryOperator: unaryOperator, in: expression)
        }
        try validateBinaryOperatorsSyntax(in: expression)
        try validateParenthesesMatch(in: expression)
    }
    
    // Checks if the input String is a valid boolean syntax
    func validateBooleanSyntax(_ input: String) throws {
        let operands = input.split { binaryOperators.contains($0) }
            .map { String($0).trimmingCharacters(in: .whitespaces) }
        let operatorsCount = input.filter { binaryOperators.contains($0) }.count
        
        for operand in operands {
            if !booleans.contains(operand) {
                throw ValidationError.invalidSyntax
            }
        }
        
        if operands.count > 1 && operands.count != operatorsCount + 1 {
            throw ValidationError.invalidBinaryOperatorSyntax
        }
    }
    
    // MARK: - Private Methods
    
    private func validateExpressionIsNotEmpty(_ input: String) throws {
        if input.trimmingCharacters(in: .whitespaces).isEmpty {
            throw ValidationError.emptyExpression
        }
    }
    
    private func validateAllowedCharacters(in input: String) throws {
        if (input.contains { !allowedChars.contains($0) }) {
            throw ValidationError.invalidCharacters
        }
    }
    
    // Validates that the input string has correct unary operator syntax
    private func validateUnaryOperatorSyntax(unaryOperator: Character, in input: String) throws {
        let numberOfOperators = input.filter { $0 == unaryOperator }.count
        var numberOfOperatorAndOperandOccurrences = 0
        for operand in booleans + [String(leftParenthesis)] {
            let operatorAndOperand = String(unaryOperator) + operand
            numberOfOperatorAndOperandOccurrences += input.components(separatedBy: operatorAndOperand).count - 1
        }
        
        // Iterate over the input and check that the unary operator syntax is correct
        var index = input.index(after: input.startIndex)
        while index < input.endIndex {
            let nextIndex = input.index(after: index)
            let previousIndex = input.index(before: index)
            guard let char = input[index..<nextIndex].first else { break }
            
            if char == unaryOperator {
                guard let leftChar = input[previousIndex..<index].first else { break }
                
                if !leftChar.isWhitespace && (leftChar != leftParenthesis) {
                    throw ValidationError.invalidUnaryOperatorSyntax
                }
            }
            index = nextIndex
        }
        
        // Check that the number of unary operator occurrences matches the number of occurrences followed by a valid operand
        if numberOfOperators != numberOfOperatorAndOperandOccurrences {
            throw ValidationError.invalidUnaryOperatorSyntax
        }
    }

    
    // Validates that the input string has correct binary operator syntax
    private func validateBinaryOperatorsSyntax(in input: String) throws {
        // Check that the first and last characters are not binary operators
        guard let firstChar = input.first,
              let lastChar = input.last,
              !binaryOperators.contains(firstChar),
              !binaryOperators.contains(lastChar) else {
            throw ValidationError.invalidBinaryOperatorSyntax
        }
        
        // Start checking from the second character
        var index = input.index(after: input.startIndex)
        
        while index < input.endIndex {
            let nextIndex = input.index(after: index)
            let previousIndex = input.index(before: index)
            guard let char = input[index..<nextIndex].first else { break }
            
            // If the character is a binary operator, validate its syntax
            if binaryOperators.contains(char) {
                guard let leftChar = input[previousIndex..<index].first,
                      let rightChar = input[nextIndex..<input.index(after: nextIndex)].first else { break }
                
                // Check if the operator syntax is valid based on the left and right characters
                if !(leftChar.isLetter && rightChar.isLetter) && // A&B
                    !(leftChar == rightParenthesis && rightChar == leftParenthesis) && // (A)|(B)
                    !(leftChar == rightParenthesis && rightChar.isLetter) && // (A)&B
                    !(leftChar.isLetter && rightChar == leftParenthesis) && // A&(B)
                    !(leftChar.isWhitespace && rightChar.isWhitespace) { // A | B
                    throw ValidationError.invalidBinaryOperatorSyntax
                }
            }
            index = nextIndex
        }
    }

    
    // Checks if the parentheses are matched correctly
    private func validateParenthesesMatch(in expression: String) throws {
        var stack = [Character]()
        
        for char in expression {
            switch char {
            case leftParenthesis:
                // if a left parenthesis is encountered, push it onto the stack
                stack.append(char)
            case rightParenthesis:
                // if a right parenthesis is encountered, check if the last element in the stack is a left parenthesis and remove it
                if stack.isEmpty || stack.removeLast() != leftParenthesis {
                    throw ValidationError.mismatchedParentheses
                }
            default:
                break
            }
        }
        
        // if the stack is not empty after all parentheses have been matched, it means there is a mismatch
        if !stack.isEmpty {
            throw ValidationError.mismatchedParentheses
        }
    }

}

