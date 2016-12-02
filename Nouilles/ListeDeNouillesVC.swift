//
//  ListeDeNouillesVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import CoreData

class ListeDeNouillesVC: UIViewController {
   
   // MARK: - Properties
   
   var managedContext: NSManagedObjectContext!
   var fetchedResultsController: NSFetchedResultsController<Nouille>!
   
   let fetchRequest: NSFetchRequest<Nouille> = Nouille.fetchRequest()

   var selectedPredicate: NSPredicate?
   var selectedSortDescriptor: [NSSortDescriptor]?

   var filters = Filters()
   
   // MARK: - Outlets
   
   @IBOutlet var tableView: UITableView!
   @IBOutlet weak var addNoodleButton: UIBarButtonItem!
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // set-up fetched results controller
      
      let nameSort = NSSortDescriptor(key: #keyPath(Nouille.name), ascending: true)
      selectedSortDescriptor = [nameSort]
      fetchRequest.sortDescriptors = [nameSort]
      
      fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
      
      fetchedResultsController.delegate = self
      
      doFetch()
      
   }
   
   
   
   // MARK: - Actions
   
   @IBAction func addNoodleTapped(_ sender: Any) {
      
      
   }
   
   // MARK: - Navigation
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.identifier == "AddNoodleVC" {
         let vc = segue.destination as! AddNoodleVC
         vc.managedContext = self.managedContext!
      } else if segue.identifier == "toFilterVC" {
         let nc = segue.destination as? UINavigationController
         let vc = nc?.topViewController as! FilterVC
         vc.delegate = self
         vc.selectedSortDescriptor = selectedSortDescriptor
         vc.selectedPredicate = selectedPredicate
         vc.filters = filters
      }
      
   }
   
   // MARK: - Fetch Request Methods
   
   // execute the fetch request
   func doFetch() {
      do {
         try fetchedResultsController.performFetch()
      } catch let error as NSError {
         print("Could not fetch \(error), \(error.userInfo)")
      }
   }

}

// MARK: - Table View Data Source

extension ListeDeNouillesVC: UITableViewDataSource {
   
   func formatWithFraction(value: Double) -> String {
      
      let integerPart = Int(value)
      let fractionalPart = value.truncatingRemainder(dividingBy: 1.0)
      
      var returnedString = integerPart != 0 ? "\(integerPart)" : ""
      
      switch fractionalPart {
      case 0.24...0.26:
         returnedString += "¼"
      case 0.32...0.34:
         returnedString += "⅓"
      case 0.49...0.51:
         returnedString += "½"
      case 0.66...0.68:
         returnedString += "⅔"
      case 0.74...0.76:
         returnedString += "¾"
      default:
         if fractionalPart != 0 {
            let rounded = Int(fractionalPart * 100)
            returnedString += ".\(rounded)"
         }
      }
      
      return returnedString
   }

   func formatWithExponent(value: Double) -> String {
      
      let integerPart = Int(value)
      let fractionalPart = value.truncatingRemainder(dividingBy: 1.0)
      
      var returnedString = integerPart != 0 ? "\(integerPart)" : ""
      
      switch fractionalPart {
      case 0.15...0.17:
         returnedString += "¹⁰"
      case 0.24...0.26:
         returnedString += "¹⁵"
      case 0.32...0.34:
         returnedString += "²⁰"
      case 0.49...0.51:
         returnedString += "³⁰"
      case 0.66...0.68:
         returnedString += "⁴⁰"
      case 0.74...0.76:
         returnedString += "⁴⁵"
      case 0.82...0.84:
         returnedString += "⁵⁰"
      default:
         if fractionalPart != 0 {
            let rounded = Int(fractionalPart * 100)
            returnedString += ".\(rounded)"
         }
      }
      
      return returnedString
   }

   func configure(cell: NoodleListTableViewCell, indexPath: IndexPath) {
      
      let nouille = fetchedResultsController.object(at: indexPath)
      
      cell.backgroundColor = NoodlesStyleKit.lighterYellow
       
      cell.nameLabel?.text = nouille.name!
      cell.brandLabel?.text = nouille.brand!

      if nouille.mealSizePrefered! as Bool {
         cell.qtyLabel?.text = formatWithFraction(value: Double(nouille.servingCustom!))
         cell.mealSizeView?.image = NoodlesStyleKit.imageOfMealSizeIndicator
      } else {
         cell.qtyLabel?.text = formatWithFraction(value: Double(nouille.servingSideDish!))
         cell.mealSizeView?.image = NoodlesStyleKit.imageOfMealSizeIndicatorSD
      }
      cell.timeLabel?.text = formatWithExponent(value: Double(nouille.time!))
      if let imageData = nouille.image as? Data {
         let boxImage = UIImage(data: imageData)
         cell.boxImageView?.image = boxImage
      } else {
         // draw default image
         cell.boxImageView?.image = NoodlesStyleKit.imageOfNouille
      }
      cell.ratingImageView?.image = NoodlesStyleKit.imageOfRatingIndicator(rating: nouille.rating as! CGFloat)
      
      
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
      
      return sectionInfo.numberOfObjects
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let cell = tableView.dequeueReusableCell(withIdentifier: NoodleListTableViewCell.reuseIdentifier, for: indexPath) as! NoodleListTableViewCell
      
      configure(cell: cell, indexPath: indexPath)
      
      return cell
   }
   
   // This enables the swipe left to delete gesture on the tableview
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == UITableViewCellEditingStyle.delete {
         
         let nouille = fetchedResultsController.object(at: indexPath)
         
         managedContext.delete(nouille)
         
         do {
            try managedContext.save()
         } catch let error as NSError {
            print("Could not save context \(error), \(error.userInfo)")
         }

         
      }
   }

   
}

// MARK: - Table View Delegate

extension ListeDeNouillesVC: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      // a row was selected, prepare the segue
      let nouille = fetchedResultsController.object(at: indexPath)
      let vc = storyboard?.instantiateViewController(withIdentifier: "NouilleDetailVC") as! NouilleDetailVC
      vc.managedContext = self.managedContext!
      vc.nouille = nouille
      show(vc, sender: self)
      
   }
}

extension ListeDeNouillesVC: NSFetchedResultsControllerDelegate {
   
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
   
   
}

extension ListeDeNouillesVC: FilterVCDelegate {

   func filterVC(filter: FilterVC) {
      
      selectedPredicate = filters.predicate()
      selectedSortDescriptor = filters.sortDescriptors()
      
      fetchRequest.predicate = nil
      fetchRequest.sortDescriptors = nil
      
      fetchRequest.predicate = selectedPredicate
      
      if let sr = selectedSortDescriptor {
         fetchRequest.sortDescriptors = sr
      }
      
      fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
     
      fetchedResultsController.delegate = self

      doFetch()
      tableView.reloadData()
   }

}
