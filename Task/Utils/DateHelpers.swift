//
//  DateHelpers.swift
//  Task
//
//  Created by Carlos Pendola on 1/31/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

import Foundation

extension Date {
    
    func stringValue() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: self)
    }
    
}
