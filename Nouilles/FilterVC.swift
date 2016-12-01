//
//  FilterVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-01.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

protocol FilterVCDelegate: class {
   func filterVC(filter: FilterVC, didSelectPredicate predicate: NSPredicate?, sortDescriptor: NSSortDescriptor?)
}

class FilterVC: UITableViewController {
   
   // MARK: - Properties
   
   let sortOptions = ["By Name", "By Brand", "By Rating", "By Cooking Time"]
   
   let sortOptionDescription = [
      "Sort by name",
      "Sort by Brand, then by name",
      "Sort by Rating, then by name",
      "Sort by cooking time, then by name"
   ]
   
   let predicateOptions = ["On-hand", "All"]
   let predicateDescription = ["Only those listed as on-hand", "All noodles"]
   
   weak var delegate: FilterVCDelegate?
   var selectedPredicate: NSPredicate?
   var selectedSortDescriptor: [NSSortDescriptor]?
   var currentSort: IndexPath?
   var currentPredicate: IndexPath?
   
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
      
      // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      // self.navigationItem.rightBarButtonItem = self.editButtonItem()
   }
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      
      return 2
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      if section == 0 {
         return sortOptions.count
      } else {
         return predicateOptions.count
      }
   }
   
   override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      
      if section == 0 {
         return "Sort"
      } else {
         return "Show"
      }
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "sortOptionCell", for: indexPath)
      
      if indexPath.section == 0 {
         cell.textLabel?.text = sortOptions[indexPath.row]
         cell.detailTextLabel?.text = sortOptionDescription[indexPath.row]
      } else {
         cell.textLabel?.text = predicateOptions[indexPath.row]
         cell.detailTextLabel?.text = predicateDescription[indexPath.row]
      }
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      if indexPath.section == 0 {
         if currentSort != nil {
            let previouslySelected = tableView.cellForRow(at: currentSort!)! as UITableViewCell
            previouslySelected.accessoryType = .none
         }
         currentSort = indexPath
         let selected = tableView.cellForRow(at: indexPath)! as UITableViewCell
         selected.accessoryType = .checkmark
         switch indexPath.row {
         case 0:
            selectedSortDescriptor = [nameSortDescriptor]
         case 1:
            selectedSortDescriptor = [brandSortDescriptor, nameSortDescriptor]
         case 2:
            selectedSortDescriptor = [ratingSortDescriptor, nameSortDescriptor]
         case 3:
            selectedSortDescriptor = [timeSortDescriptor, nameSortDescriptor]
         default:
            selectedSortDescriptor = [nameSortDescriptor]
         }
      } else {
         if currentPredicate != nil {
            let previouslySelected = tableView.cellForRow(at: currentPredicate!)! as UITableViewCell
            previouslySelected.accessoryType = .none
         }
         currentPredicate = indexPath
         let selected = tableView.cellForRow(at: indexPath)! as UITableViewCell
         selected.accessoryType = .checkmark
         switch indexPath.row {
         case 0:
            selectedPredicate = onHandPredicate
         default:
            selectedPredicate = nil
         }
      }
      
   }
   
   /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
   
   /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
    // Delete the row from the data source
    tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
   
   /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
    }
    */
   
   /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
}
