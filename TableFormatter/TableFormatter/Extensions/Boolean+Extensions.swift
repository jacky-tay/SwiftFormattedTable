//
//  Boolean+Extensions.swift
//  TableFormatter
//
//  Created by Jacky Tay on 28/05/18.
//  Copyright © 2018 Jacky Tay. All rights reserved.
//

import Foundation

extension Bool: InstanceCell {
    func binary() -> String {
        return self ? "1" : "0"
    }
    
    func yesNo() -> String {
        return self ? "yes" : "no"
    }
    
    func toString() -> String {
        return "\(self)"
    }
}
