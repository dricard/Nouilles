//
//  FilterVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-01.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

protocol FilterVCDelegate: class {
   func filterVC(filter: FilterVC)
}

class FilterVC: UITableViewController {
   
   // MARK: - Properties
   
   let sortOptions = [ "By Name", "By Brand", "By Rating", "By Cooking Time" ]
   
   let sortOptionDescription = [
      "Sort by name",
      "Sort by Brand, then by name",
      "Sort by Rating, then by name",
      "Sort by cooking time, then by name"
   ]
   
   let predicateOptions = [ "All", "On-hand" ]
   let predicateDescription = [ "All noodles", "Only those listed as on-hand" ]
   
   weak var delegate: FilterVCDelegate?
   var selectedPredicate: NSPredicate?
   var selectedSortDescriptor: [NSSortDescriptor]?
   var currentSort: IndexPath?
   var currentPredicate: IndexPath?
   
   var filters: Filters?
   
   lazy var onHandPredicate: NSPredicate = {
      return NSPredicate(format: "%K == true", #keyPath(Nouille.onHand))
   }()

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
   
   // MARK: - Life cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      self.clearsSelectionOnViewWillAppear = false
      
      self.navigationItem.hidesBackButton = true
      let newBackButton = UIBarButtonItem(title: .Back, style: .plain, target: self, action: #selector(FilterVC.sendSortOption))
      self.navigationItem.leftBarButtonItem = newBackButton

   }
   
   func sendSortOption() {
      
      // this sends the list view a "message" to refilter its list
      delegate?.filterVC(filter: self)
      dismiss(animated: true, completion: nil)

   }
   
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      
      guard let filters = filters else { return 0 }
      
      return filters.numberOfSections()
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 
      guard let filters = filters else { return 0 }
      
      return filters.rowsInSection(section: section)
      
   }
   
   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
      guard let filters = filters else { return nil }

      return filters.headerTitle(section: section)

   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      guard let filters = filters else { fatalError() }

      let cell = tableView.dequeueReusableCell(withIdentifier: "sortOptionCell", for: indexPath)
      
      cell.accessoryType = filters.accessoryIndicator(indexPath: indexPath)
      cell.textLabel?.text = filters.title(indexPath: indexPath)
      cell.detailTextLabel?.text = filters.description(indexPath: indexPath)
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      guard let filters = filters else { fatalError() }
    
      filters.setFilters(indexPath: indexPath)
      tableView.reloadData()
      
//      if indexPath.section == 0 {
//         if currentSort != nil {
//            let previouslySelected = tableView.cellForRow(at: currentSort!)! as UITableViewCell
//            previouslySelected.accessoryType = .none
//         }
//         currentSort = indexPath
//         let selected = tableView.cellForRow(at: indexPath)! as UITableViewCell
//         selected.accessoryType = .checkmark
//         switch indexPath.row {
//         case 0:
//            selectedSortDescriptor = [nameSortDescriptor]
//         case 1:
//            selectedSortDescriptor = [brandSortDescriptor, nameSortDescriptor]
//         case 2:
//            selectedSortDescriptor = [ratingSortDescriptor, nameSortDescriptor]
//         case 3:
//            selectedSortDescriptor = [timeSortDescriptor, nameSortDescriptor]
//         default:
//            selectedSortDescriptor = [nameSortDescriptor]
//         }
//      } else {
//         if currentPredicate != nil {
//            let previouslySelected = tableView.cellForRow(at: currentPredicate!)! as UITableViewCell
//            previouslySelected.accessoryType = .none
//         }
//         currentPredicate = indexPath
//         let selected = tableView.cellForRow(at: indexPath)! as UITableViewCell
//         selected.accessoryType = .checkmark
//         switch indexPath.row {
//         case 0:
//            selectedPredicate = onHandPredicate
//         default:
//            selectedPredicate = nil
//         }
//      }
      
   }

   
}
