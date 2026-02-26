//
//  CoreDataStack.swift
//  Project-PersonForm
//
//  Created by Amit Bhujbal on 25/02/2026.
//

import CoreData

class CoreDataStack {
    
    //MARK: CoreData - Name="Mode"
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    var managedContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //MARK: Save to CoreData
    func saveContext() {
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
