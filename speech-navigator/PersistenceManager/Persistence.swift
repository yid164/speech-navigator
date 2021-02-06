//
//  Persistence.swift
//  speech-navigator
//
//  Created by YINSHENG DONG on 2021-02-06.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "speech-navigator")
        container.loadPersistentStores{ (_, error) in
            if let error = error as NSError? {
                print("BBBB")
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}