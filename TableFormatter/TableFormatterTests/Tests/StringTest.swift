//
//  StringTest.swift
//  TableFormatterTests
//
//  Created by Jacky Tay on 27/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import XCTest
@testable import TableFormatter

class StringTest: XCTestCase {
    func testSubString() {
        let input = "hello world"
        XCTAssertEqual(input.subString(from: 0, withLen: 5), "hello")
        XCTAssertEqual(input.subString(from: 0, withLen: 100), "hello world")
        XCTAssertEqual(input.subString(from: 3, withLen: 4), "lo w")
    }
    
    func testFindNextPointer() {
        
    }
}
