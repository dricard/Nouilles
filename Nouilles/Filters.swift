//
//  Filters.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-02.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation
import UIKit

class Filters: NSObject {
   
   // MARK: - sortTypes enum
   
   enum sortTypes: Int {
      case sort = 0
      case predicate = 1
   }
   
   // MARK: - Properties
   
   let sortSection = 0
   let predicateSection = 1
   
    let sortTitleText: [String] = [ .byName, .byBrand, .byRating, .byCookingTime ]
    let predicateTitleText: [String] = [ .all, .onHandTitleAvailable, .onHandTitleUnavailable ]

    let sortDescriptionText: [String] = [
      .sortByName,
      .sortByBrand,
      .sortByRating,
      .sortByTime
   ]
    let predicateDescriptionText: [String] = [ .allNoodles, .onHandNoodles, .notOnHandNoodles ]

   private var _currentSort: Int
   private var _currentPredicate: Int
   
   
   override init() {
      _currentSort = 0
      _currentPredicate = 0
   }
   
   // MARK: - Methods
   
   func sortDescriptors() -> [NSSortDescriptor] {
      switch _currentSort {
      case 0:
         return [nameSortDescriptor]
      case 1:
         return [brandSortDescriptor, nameSortDescriptor]
      case 2:
         return [ratingSortDescriptor, nameSortDescriptor]
      case 3:
         return [timeSortDescriptor, nameSortDescriptor]
      default:
         return [nameSortDescriptor]
      }
      
   }
   
   func predicate() -> NSPredicate? {
      switch _currentPredicate {
      case 0:
         return nil
      case 1:
         return onHandPredicate
      case 2:
        return notOnHandPredicate
      default:
        return nil
      }
      
   }
   
   
   func setFilters(indexPath: IndexPath) {
      switch sortTypeFromSection(section: indexPath.section) {
      case .sort:
         _currentSort = indexPath.row
      case .predicate:
         _currentPredicate = indexPath.row
      }
   }

   func sortForIndex(index: Int) -> [NSSortDescriptor] {
      _currentSort = index
      return sortDescriptors()
   }
   
   func indexForSort() -> Int {
      return _currentSort
   }

   func predicateForIndex(index: Int) -> NSPredicate? {
      _currentPredicate = index
      return predicate()
   }
   
   func indexForPredicate() -> Int {
      return _currentPredicate
   }
   
   func sortTitle(indexPath: IndexPath) -> String {
      return sortTitleText[indexPath.row]
   }

   func predicateTitle(indexPath: IndexPath) -> String {
      return predicateTitleText[indexPath.row]
   }

   func sortDescription(indexPath: IndexPath) -> String {
      return sortDescriptionText[indexPath.row]
   }
   
   func predicateDescription(indexPath: IndexPath) -> String {
      return predicateDescriptionText[indexPath.row]
   }

   func sortTypeFromSection(section: Int) -> sortTypes {
      
      if section == sortTypes.sort.rawValue {
         return .sort
      } else if section == sortTypes.predicate.rawValue {
         return .predicate
      } else {
         print("Error, bad section reference")
         return .sort
      }
      
   }
   
   func accessoryIndicator(indexPath: IndexPath) -> UITableViewCellAccessoryType {
      
      switch sortTypeFromSection(section: indexPath.section) {
      case .sort:
         if indexPath.row == _currentSort {
            return UITableViewCellAccessoryType.checkmark
         } else {
            return UITableViewCellAccessoryType.none
         }
      case .predicate:
         if indexPath.row == _currentPredicate {
            return UITableViewCellAccessoryType.checkmark
         } else {
            return UITableViewCellAccessoryType.none
         }
      }
   }
   
   func title(indexPath: IndexPath) -> String {
      switch sortTypeFromSection(section: indexPath.section) {
      case .sort:
         return sortTitle(indexPath: indexPath)
      case .predicate:
         return predicateTitle(indexPath: indexPath)
      }
   }
   
   func description(indexPath: IndexPath) -> String {
      switch sortTypeFromSection(section: indexPath.section) {
      case .sort:
         return sortDescription(indexPath: indexPath)
      case .predicate:
         return predicateDescription(indexPath: indexPath)
      }
   }
   
   func headerTitle(section: Int) -> String {
      switch sortTypeFromSection(section: section) {
      case .sort:
         return .sortTitle
      case .predicate:
         return .predicateTitle
      }
   }
   
   func rowsInSection(section: Int) -> Int {
      
      switch sortTypeFromSection(section: section) {
      case .sort:
         return sortTitleText.count
      case .predicate:
         return predicateTitleText.count
      }
   }
   
   func numberOfSections() -> Int {
      return 2
   }
   
   // MARK: - Enums
   
   
   
   // MARK: - Sort Descriptors definitions
   
   lazy var nameSortDescriptor: NSSortDescriptor = {
      let compareSelector = #selector(NSString.localizedStandardCompare(_:))
      return NSSortDescriptor(key: #keyPath(Nouille.name),
                              ascending: true,
                              selector: compareSelector)
   }()
   
   lazy var brandSortDescriptor: NSSortDescriptor = {
      let compareSelector = #selector(NSString.localizedStandardCompare(_:))
      return NSSortDescriptor(key: #keyPath(Nouille.brand),
                              ascending: true,
                              selector: compareSelector)
   }()
   
   lazy var ratingSortDescriptor: NSSortDescriptor = {
      return NSSortDescriptor(key: #keyPath(Nouille.rating),
                              ascending: false)
   }()
   
   lazy var timeSortDescriptor: NSSortDescriptor = {
      return NSSortDescriptor(key: #keyPath(Nouille.time),
                              ascending: true)
   }()
   

   
   // MARK: - Predicate definitions
   
   lazy var onHandPredicate: NSPredicate = {
      return NSPredicate(format: "%K == true", #keyPath(Nouille.onHand))
   }()
   
    lazy var notOnHandPredicate: NSPredicate = {
        return NSPredicate(format: "%K == false", #keyPath(Nouille.onHand))
    }()

}
