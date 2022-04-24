//
//  Validations.swift
//  DontForgetMe
//
//  Created by Michael Padilla on 4/23/22.
//

import Foundation

struct Validation {
    static let EMAIL = "^\\w+\\.?\\w+@[A-z]+\\.\\w+$"
    static let USERNAME = "^[A-z]+\\w+$"
    static let PHONE = "^\\d{3,15}$"
    
    static func textsAreNotEmpty(_ texts: String...) -> Bool {
        texts.allSatisfy { text in
            !text.isEmpty
        }
    }
    
    static func isValid(text: String, pattern: String) -> Bool {
        let range = NSRange(location: 0, length: text.utf16.count)
        let regex = try! NSRegularExpression(pattern: pattern)
        
        return regex.firstMatch(in: text, options: [], range: range) != nil
    }
}
