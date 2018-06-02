//
//  String+Extensions.swift
//  TableFormatter
//
//  Created by Jacky Tay on 27/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

extension String: InstanceCell {
    
    static func buildRepeated(char: Character, withBound bound: Int) -> String {
        return String(Array(repeating: char, count: bound))
    }
    
    static func buildContent(withBound bound: Int) -> String {
        return buildRepeated(char: " ", withBound: bound)
    }
    
    mutating func replace(string: String, at start: Int) {
        let begin = index(startIndex, offsetBy: start)
        let end = index(begin, offsetBy: string.count)
        replaceSubrange(begin ..< end, with: string)
    }
    
    func subString(from: Int, withLen len: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: min(count - from, len)) // ensure that the end index is always within the string boundary
        return String(self[start ..< end])
    }
    
    func findNextPointer(startFrom start: Int, withLen len: Int) -> Int {
        let substring = subString(from: start, withLen: len).trimmingCharacters(in: .whitespaces)
        
        if let newLine = substring.rangeOfCharacter(from: CharacterSet.newlines) {
            return start + distance(from: substring.startIndex, to: newLine.lowerBound) + 1
        }
        else if self.count > start + substring.count, let indexOfLastSpace = substring.rangeOfCharacter(from: CharacterSet.whitespaces, options: .backwards) {
            return start + distance(from: substring.startIndex, to: indexOfLastSpace.lowerBound) + 1
        }
        return start + substring.count + 1
    }
    
    func toString() -> String {
        return self
    }
}
