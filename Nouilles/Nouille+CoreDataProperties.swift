//
//  Nouille+CoreDataProperties.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-01-11.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import Foundation
import CoreData


extension Nouille {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Nouille> {
        return NSFetchRequest<Nouille>(entityName: "Nouille");
    }

    @NSManaged public var brand: String?
    @NSManaged public var calories: NSNumber?
    @NSManaged public var carbs: NSNumber?
    @NSManaged public var fat: NSNumber?
    @NSManaged public var fibre: NSNumber?
    @NSManaged public var image: NSData?
    @NSManaged public var mealSizePrefered: NSNumber?
    @NSManaged public var name: String?
    @NSManaged public var numberOfServing: NSNumber?
    @NSManaged public var onHand: NSNumber?
    @NSManaged public var perBox: NSNumber?
    @NSManaged public var protein: NSNumber?
    @NSManaged public var rating: NSNumber?
    @NSManaged public var saturated: NSNumber?
    @NSManaged public var serving: NSNumber?
    @NSManaged public var servingCustom: NSNumber?
    @NSManaged public var servingSideDish: NSNumber?
    @NSManaged public var sodium: NSNumber?
    @NSManaged public var sugar: NSNumber?
    @NSManaged public var time: NSNumber?
    @NSManaged public var trans: NSNumber?
    @NSManaged public var userRating: NSSet?

}

// MARK: Generated accessors for userRating
extension Nouille {

    @objc(addUserRatingObject:)
    @NSManaged public func addToUserRating(_ value: UserRating)

    @objc(removeUserRatingObject:)
    @NSManaged public func removeFromUserRating(_ value: UserRating)

    @objc(addUserRating:)
    @NSManaged public func addToUserRating(_ values: NSSet)

    @objc(removeUserRating:)
    @NSManaged public func removeFromUserRating(_ values: NSSet)

}
