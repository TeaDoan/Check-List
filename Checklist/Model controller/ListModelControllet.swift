//
//  ListModelControllet.swift
//  Checklist
//
//  Created by Thao Doan on 5/18/18.
//  Copyright © 2018 Thao Doan. All rights reserved.
//

import Foundation
import CoreData

class ListModelController {
    
    static let shared = ListModelController()
    
    func add(name:String) {
        List(name: name)
        savePersistanceStore()
    }
    func update(list: List,newName: String,isDone: Bool = false){
        
        list.name = newName
        list.isDone = false
        savePersistanceStore()
        
    }
    func detele(list:List){
        CoreDataStack.context.delete(list)
        savePersistanceStore()
        
    }
    func savePersistanceStore(){
        do {
           try CoreDataStack.context.save()
        } catch let error {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    func toggleCheckListButton(list:List) {
        if list.isDone == true {
            list.isDone = false
        } else {
            list.isDone = true
        }
    }
}
 
