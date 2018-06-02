//
//  Number+Extensions.swift
//  TableFormatter
//
//  Created by Jacky Tay on 28/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

protocol Number: InstanceCell {
    func toNSNumber() -> NSNumber
}

extension Int: Number {
    func toString() -> String {
        return "\(self)"
    }
    
    func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Int64: Number {
    func toString() -> String {
        return "\(self)"
    }
    
    func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Float: Number {
    func toString() -> String {
        return "\(self)"
    }
    
    func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Double: Number {
    func toString() -> String {
        return "\(self)"
    }
    
    func toNSNumber() -> NSNumber {
        return NSNumber(value: self)
    }
}

extension Number {
    
    func dollar() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        return formatter.string(from: self.toNSNumber()) ?? ""
    }
}
