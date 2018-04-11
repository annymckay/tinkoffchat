//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 11.04.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    //store
    var storeURL : URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("MyStore.sqlite")
    }
    //model
    let dataModelName = "CoreDataModel"
    let dataModelExtension = "momd"
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName, withExtension: self.dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    //coordinator
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeURL,
                                               options: nil)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        return coordinator
    }()
    //context
    lazy var masterContext: NSManagedObjectContext = {
        var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        masterContext.mergePolicy = NSOverwriteMergePolicy
        return masterContext
    }()
    lazy var mainContext: NSManagedObjectContext = {
        var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.parent = self.masterContext
        mainContext.mergePolicy = NSOverwriteMergePolicy
        return mainContext
    }()
    lazy var saveContext: NSManagedObjectContext = {
        var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        saveContext.parent = self.mainContext
        saveContext.mergePolicy = NSOverwriteMergePolicy
        return saveContext
    }()
    public func performSave(context: NSManagedObjectContext, completionHandler : ((String?) -> Void)?) {
        
        if context.hasChanges {
            context.perform { [weak self] in
                do {
                    try context.save()
                }
                catch {
                    print("Context save error: \(error)")
                    completionHandler?("Context save error: \(error)")
                }
                
                if let parent = context.parent {
                    self?.performSave(context: parent, completionHandler: completionHandler)
                } else {
                    completionHandler?(nil)
                }
            }
        } else {
            completionHandler?(nil)
        }
    }
}
