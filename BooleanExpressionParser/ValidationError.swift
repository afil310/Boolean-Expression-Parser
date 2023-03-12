//
//  ValidationError.swift
//  BooleanExpressionParser
//
//  Created by Andrey Filonov on 12/03/23.
//

import Foundation

enum ValidationError: LocalizedError {
    case emptyExpression
    case invalidSyntax
    case invalidUnaryOperatorSyntax
    case invalidBinaryOperatorSyntax
    case invalidCharacters
    case mismatchedParentheses
}

extension ValidationError {
    
    public var errorDescription: String? {
        switch self {
            
        case .emptyExpression:
            return NSLocalizedString("Expression is empty", comment: "Expression validation error")
            
        case .invalidSyntax:
            return NSLocalizedString("Invalid expression syntax", comment: "Expression validation error")
            
        case .invalidUnaryOperatorSyntax:
            return NSLocalizedString("Invalid syntax for unary operator", comment: "Expression validation error")
            
        case .invalidBinaryOperatorSyntax:
            return NSLocalizedString("Invalid syntax for binary operator", comment: "Expression validation error")
            
        case .invalidCharacters:
            return NSLocalizedString("Invalid character(s) found in expression", comment: "Expression validation error")
            
        case .mismatchedParentheses:
            return NSLocalizedString("Mismatched parentheses in expression", comment: "Expression validation error")
        }
    }
}

