//
//  BranchMO.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/12/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit
import CoreData

public class BranchMO: NSManagedObject {
    
    static func validate(number: String) -> Bool {
        let numRegExp = try? NSRegularExpression(pattern: "[0-9]", options: .caseInsensitive)
        let matches = numRegExp?.matches(in: number, options: [], range: NSRange(location: 0, length: number.count))
        if matches?.count != number.count {
            return false
        }
        return true
    }
    

}
