//
//  CheckList+Convenience.swift
//  Checklist
//
//  Created by Thao Doan on 5/18/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import Foundation
import CoreData

extension List {
    @discardableResult convenience init(name:String, isDone: Bool = false, insertInto context: NSManagedObjectContext = CoreDataStack.context  ) {
        self.init(context: context)
        self.name = name
        self.isDone = false
    }
}

