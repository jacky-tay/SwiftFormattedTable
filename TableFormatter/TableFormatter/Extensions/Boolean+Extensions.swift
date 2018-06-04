//
//  Boolean+Extensions.swift
//  TableFormatter
//
//  Created by Jacky Tay on 28/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

extension Bool: InstanceCell {
    
    /// Convert boolean value to '1' if true otherwise '0'
    ///
    /// - Returns: Return '1' if true, otherwise '0'
    func binary() -> String {
        return self ? "1" : "0"
    }
    
    /// Convert boolean value to 'yes' if true, otherwise 'no'
    ///
    /// - Returns: Return 'yes' if true, otherwise 'no'
    func yesNo() -> String {
        return self ? "yes" : "no"
    }
    
    
    /// Convert boolean value to string
    ///
    /// - Returns: Return boolean value to string
    func toString() -> String {
        return "\(self)"
    }
}
