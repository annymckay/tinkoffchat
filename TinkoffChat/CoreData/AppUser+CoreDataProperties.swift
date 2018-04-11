//
//  AppUser+CoreDataProperties.swift
//  TinkoffChat
//
//  Created by Анна Лихтарова on 11.04.2018.
//  Copyright © 2018 Анна Лихтарова. All rights reserved.
//
//

import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var name: String?
    @NSManaged public var info: String?
    @NSManaged public var photo: NSData?

}
