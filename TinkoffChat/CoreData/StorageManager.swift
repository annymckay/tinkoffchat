//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 11.04.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    var stack: CoreDataStack = CoreDataStack()
    
    func findOrInsertAppUser(in context: NSManagedObjectContext) -> AppUser? {
        guard let model = context.persistentStoreCoordinator?.managedObjectModel else {
            print("Model is not available in context!")
            assert(false)
            return nil
        }
        var appUser : AppUser?
        guard let fetchRequest = AppUser.fetchRequestAppUser(model: model) else {
            return nil
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            //assert(results.count < 2, "Multiple AppUser found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        
        if appUser == nil {
            appUser = AppUser.insertAppUser(in: context)
        }
        return appUser
    }
    
    func saveAppUser(name: String?, info: String?, photo: UIImage?, completionHandler: @escaping ((String?)->Void)) {
        let appUser = self.findOrInsertAppUser(in: stack.masterContext)

        if (appUser != nil) {
            if let name = name {
                appUser!.name = name
            }
            if let info = info {
                appUser!.info = info
            }
            if let photo = photo {
                if let imageData = UIImageJPEGRepresentation(photo, 1.0) {
                    let imageNSData : NSData = imageData as NSData
                    appUser!.photo = imageNSData
                } else {
                    completionHandler("Can't save photo")
                    print("Can't save photo")
                    return
                }
            }
            self.stack.performSave(context: self.stack.masterContext, completionHandler: completionHandler)
        } else {
            completionHandler("Can't find or insert AppUser")
            print("Can't find or insert AppUser")
        }
    }
    
    func loadAppUser() -> AppUser? {
        return self.findOrInsertAppUser(in: self.stack.saveContext)
    }

}
