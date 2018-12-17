//
//  PersonMO.swift
//  docDigitales_Test
//
//  Created by Felipe Montoya on 12/12/18.
//  Copyright © 2018 Felipe Montoya. All rights reserved.
//

import UIKit
import CoreData

public class PersonMO: NSManagedObject {

    static func validate(name: String) -> Bool {
        let regExp = try? NSRegularExpression(pattern: "[A-Za-z_ ]", options: .caseInsensitive)
        let matches = regExp?.matches(in: name, options: [], range: NSRange(location: 0, length: name.count))
        if matches?.count != name.count {
            return false
        }
        return true
    }
    
    static func validate(rfc: String) -> Bool {
         let rfcRegExp = try? NSRegularExpression(pattern: "[A-Za-z0-9]", options: .caseInsensitive)
        let matches = rfcRegExp?.matches(in: rfc, options: [], range: NSRange(location: 0, length: rfc.count))
        if matches?.count != rfc.count || (rfc.count < 12 || rfc.count > 13) {
            return false
        }
        return true
    }
    
    
}
