//
//  String+Extensions.swift
//  TableFormatter
//
//  Created by Jacky Tay on 27/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

extension String: InstanceCell {
    func toString() -> String {
        return self
    }
}

extension String {
    /// Build a string with repeating character Char with length boundary
    ///
    /// - Parameters:
    ///   - char: The repeating character
    ///   - bound: The width of string boundary
    /// - Returns: A string with repeating character with lenght boundary
    static func buildRepeated(char: Character, withBound bound: Int) -> String {
        return String(Array(repeating: char, count: bound))
    }
    
    static func buildContent(withBound bound: Int) -> String {
        return buildRepeated(char: " ", withBound: bound)
    }
    
    /// Replace string at given starting index
    ///
    /// - Parameters:
    ///   - string: The string to be replaced for
    ///   - start: The starting index where string to be replaced
    mutating func replace(string: String, at start: Int) {
        let begin = index(startIndex, offsetBy: start)
        let end = index(begin, offsetBy: string.count)
        replaceSubrange(begin ..< end, with: string)
    }
    
    /// Trim the last new line character if present
    ///
    /// - Returns: The trimmed string
    func trimLastNewLine() -> String {
        if let lastChar = last?.unicodeScalars.first, CharacterSet.newlines.contains(lastChar) {
            return subString(from: 0, withLen: count - 1)
        }
        return self
    }
    
    /// The substring with given starting index and lenghth
    ///
    /// - Parameters:
    ///   - from: The starting index
    ///   - len: The length of substring
    /// - Returns: The substring
    func subString(from: Int, withLen len: Int) -> String {
        let start = index(startIndex, offsetBy: from)
        let end = index(start, offsetBy: min(count - from, len)) // ensure that the end index is always within the string boundary
        return String(self[start ..< end])
    }
    
    /// Find the next new line index or the last space character in a given string with length
    ///
    /// - Parameters:
    ///   - start: The starting index of string
    ///   - len: The length of substring
    /// - Returns: The index pointer for first found new line character or the last space character with given susbtring
    func findNextPointer(startFrom start: Int, withLen len: Int) -> Int {
        let substring = subString(from: start, withLen: len).trimmingCharacters(in: .newlines)
        // find the first new line character if it present in the substring
        if let newLine = substring.rangeOfCharacter(from: CharacterSet.newlines) {
            return start + distance(from: substring.startIndex, to: newLine.lowerBound) + 1
        }
        else if self.count > start + substring.count, let indexOfLastSpace = substring.rangeOfCharacter(from: CharacterSet.whitespaces, options: .backwards) {
            // find the last spacing charter if the orginal string's length is greater than the length of substring
            return start + distance(from: substring.startIndex, to: indexOfLastSpace.lowerBound) + 1
        }
        return start + substring.count + 1
    }
}
