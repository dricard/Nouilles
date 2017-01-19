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
    
    // Create a Timers object that will hold timers for
    // noodles. This will be passed along when needed
    var timers = Timers()
    
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Nouille>!
    
    let fetchRequest: NSFetchRequest<Nouille> = Nouille.fetchRequest()
    
    var selectedPredicate: NSPredicate?
    var selectedSortDescriptor: [NSSortDescriptor]?
    
    var filters = Filters()
    
    let sortDescriptorIndexKey = "sortDescriptorIndexKey"
    let predicateIndexKey = "predicateIndexKey"
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addNoodleButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // read sort and predicate prefs
        
        if let sortIndex = UserDefaults.standard.value(forKey: sortDescriptorIndexKey) {
            
            selectedSortDescriptor = filters.sortForIndex(index: sortIndex as! Int)
            
            selectedPredicate = filters.predicateForIndex(index: UserDefaults.standard.value(forKey: predicateIndexKey) as! Int)
            
        } else {
            // there are no prefs, use defaults
            selectedSortDescriptor = filters.sortForIndex(index: 0)
            selectedPredicate = filters.predicateForIndex(index: 0)
            // and save those
            UserDefaults.standard.set(0, forKey: sortDescriptorIndexKey)
            UserDefaults.standard.set(0, forKey: predicateIndexKey)
        }
        
        fetchRequest.sortDescriptors = selectedSortDescriptor
        fetchRequest.predicate = selectedPredicate
        
        // set-up fetched results controller
        
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
    
    func configure(cell: NoodleListTableViewCell, indexPath: IndexPath) {
        
        let nouille = fetchedResultsController.object(at: indexPath)
        
        cell.backgroundColor = NoodlesStyleKit.lighterYellow
        
        cell.nameLabel?.text = nouille.name!
        cell.brandLabel?.text = nouille.brand!
        
        if nouille.mealSizePrefered! as Bool {
            cell.qtyLabel?.text = Nouille.formatWithFraction(value: Double(nouille.servingCustom!))
            cell.mealSizeView?.image = NoodlesStyleKit.imageOfMealSizeIndicator
        } else {
            cell.qtyLabel?.text = Nouille.formatWithFraction(value: Double(nouille.servingSideDish!))
            cell.mealSizeView?.image = NoodlesStyleKit.imageOfMealSizeIndicatorSD
        }
        cell.timeLabel?.text = Nouille.formatWithExponent(value: Double(nouille.time!))
        if let imageData = nouille.image as? Data {
            let boxImage = UIImage(data: imageData)
            cell.boxImageView?.image = boxImage
        } else {
            // draw default image
            cell.boxImageView?.image = NoodlesStyleKit.imageOfNouille
        }
        cell.ratingImageView?.image = NoodlesStyleKit.imageOfRatingIndicator(rating: nouille.rating as! CGFloat)
        
        if nouille.onHand as! Bool {
            cell.onHandIndicatorView?.image = NoodlesStyleKit.imageOfOnHandIndicator
        } else {
            cell.onHandIndicatorView?.image = NoodlesStyleKit.imageOfOnHandIndicatorEmpty
        }
        
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
    
    
}

// MARK: - Gestures

extension ListeDeNouillesVC {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // toggle onHand setting
        let toggleOnHandAction = UITableViewRowAction(style: .normal, title: "toggle on hand", handler: { (action, indexPath) -> Void in
            
            let nouille = self.fetchedResultsController.object(at: indexPath)
            
            let onHand = !(nouille.onHand as! Bool)
            nouille.onHand = onHand as NSNumber?
            
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Could not save context \(error), \(error.userInfo)")
            }
        })
        
        let deleteNoodleAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) -> Void in
            
            let nouille = self.fetchedResultsController.object(at: indexPath)
            
            self.managedContext.delete(nouille)
            
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Could not save context \(error), \(error.userInfo)")
            }
            
            
        })
        return [toggleOnHandAction, deleteNoodleAction]
    }
    
    // This enables the swipe left to delete gesture on the tableview
    //   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    //      if editingStyle == UITableViewCellEditingStyle.delete {
    //
    //         let nouille = fetchedResultsController.object(at: indexPath)
    //
    //         managedContext.delete(nouille)
    //
    //         do {
    //            try managedContext.save()
    //         } catch let error as NSError {
    //            print("Could not save context \(error), \(error.userInfo)")
    //         }
    //
    //
    //      }
    //   }
    
}
// MARK: - Table View Delegate

extension ListeDeNouillesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // a row was selected, prepare the segue
        let nouille = fetchedResultsController.object(at: indexPath)
        let vc = storyboard?.instantiateViewController(withIdentifier: "NouilleDetailVC") as! NouilleDetailVC
        vc.managedContext = self.managedContext!
        vc.nouille = nouille
        vc.timers = timers
        show(vc, sender: self)
        
        tableView.deselectRow(at: indexPath, animated: true)
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
        
        // save new sort and predicate in prefs
        UserDefaults.standard.set(filters.indexForSort(), forKey: sortDescriptorIndexKey)
        UserDefaults.standard.set(filters.indexForPredicate(), forKey: predicateIndexKey)
        
    }
    
}
