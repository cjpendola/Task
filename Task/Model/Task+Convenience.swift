//
//  Task+Convenience.swift
//  Task
//
//  Created by Carlos Pendola on 1/31/19.
//  Copyright © 2019 Carlos Pendola. All rights reserved.
//

import Foundation
import CoreData

extension Task {
    convenience init(name: String, notes: String? = nil, due: Date? = nil, context: NSManagedObjectContext = CoreDataStack.context) {
        
        self.init(context: context)
        
        self.name = name
        self.notes = notes
        self.due = due
        self.isComplete = false
    }
}

