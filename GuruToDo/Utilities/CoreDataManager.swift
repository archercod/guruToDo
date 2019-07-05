//
//  CoreDataManager.swift
//  GuruToDo
//
//  Created by Marcin Pietrzak on 05/07/2019.
//  Copyright © 2019 Marcin Pietrzak. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {

    // MARK: - Initialization
    
    private init () {}
    
    /// Get managed context
    ///
    /// - Returns: NSManagedObjectContext
    class func getManagedContext() -> NSManagedObjectContext {
        return CoreDataManager.persistentContainer.viewContext
    }
    
    /// Init and config persistant container
    ///
    @available(iOS 10.0, *)
    static var persistentContainer: NSPersistentContainer = {
        let containerName = "GuruToDo"
        let container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    /// Save context
    ///
    class func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
