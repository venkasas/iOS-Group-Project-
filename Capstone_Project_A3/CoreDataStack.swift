//
//  CoreDataStack.swift
//  Capstone_Project_A3
//
//  Created by Sasidurka on 2024-10-22.
//

import Foundation
import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()

    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "ParknPerk")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

