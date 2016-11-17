//
//  UserRating+CoreDataProperties.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-17.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation
import CoreData


extension UserRating {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserRating> {
        return NSFetchRequest<UserRating>(entityName: "UserRating");
    }

    @NSManaged public var rating: NSNumber?
    @NSManaged public var username: String?
    @NSManaged public var nouille: Nouille?

}
