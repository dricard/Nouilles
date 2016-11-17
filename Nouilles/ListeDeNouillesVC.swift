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
   
   // MARK: - Outlets
   
   @IBOutlet var tableView: UITableView!
   @IBOutlet weak var addNoodleButton: UIBarButtonItem!
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // set-up fetched results controller
      let fetchRequest: NSFetchRequest<Nouille> = Nouille.fetchRequest()
      
      let nameSort = NSSortDescriptor(key: #keyPath(Nouille.name), ascending: true)
      fetchRequest.sortDescriptors = [nameSort]
      
      fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedContext, sectionNameKeyPath: nil, cacheName: nil)
      
      fetchedResultsController.delegate = self
      
      doFetch()
      
   }
   
   // MARK: - Actions
   
   @IBAction func addNoodleTapped(_ sender: Any) {
      
      
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.identifier == "AddNoodleVC" {
         let vc = segue.destination as! AddNoodleVC
         vc.managedContext = self.managedContext!
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
   
   func configure(cell: UITableViewCell, indexPath: IndexPath) {
      
      let nouille = fetchedResultsController.object(at: indexPath)
      
      cell.textLabel?.text = nouille.name
      if let detail = cell.detailTextLabel {
         
         // construct detail label
         var label = "Temps: \(nouille.time!) mn, portion: "
         if nouille.mealSizePrefered! as Bool {
            label += "\(nouille.servingCustom!) ts (meal), "
         } else {
            label += "\(nouille.servingSideDish!) ts (side dish), "
         }
         label += "rating: \(nouille.rating!) / 5"
         detail.text = label
      }
     
      
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
      
      return sectionInfo.numberOfObjects
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Nouille", for: indexPath)
      
      configure(cell: cell, indexPath: indexPath)
      
      return cell
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
