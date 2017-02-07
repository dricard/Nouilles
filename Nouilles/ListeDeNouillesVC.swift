//
//  ListeDeNouillesVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

/*
    This presents a list of noodles from the persistant store
    What is dispayed depends on a user selected predicate and
    the sort order is also user defined.
 
    The noodles are displayed with a picture if the user added on
    or a default image of the app logo otherwise.
 
    When a timer is running for one or more noodles, the noodle's
    image is replaced with the timer animation.
 
    The user can swipe left to either deleted the noodle, or toggle
    its 'on hand' status.
 
    Selecting a noodle in the list presents a detailed view
    The user can change the filters/predicates by selecting the
    filters button (top left) and add new noodle by selecting the
    add ('+') button (top right)
 
 */

import UIKit
import CoreData

class ListeDeNouillesVC: UIViewController {
    
    // MARK: - Properties
    
    // Create a Timers object that will hold timers for
    // noodles. This will be passed along when needed
    // Note: not to be confused with the Timer class
    var timers = Timers()
    
    // This is a local timer to refresh the display
    var internalTimer = Timer()
    
    // this is used to pause an ongoing timer animation
    // while the user is in edit (swipe left) mode
    var currentlyEditing = false
    
    // Peristance related
    var managedContext: NSManagedObjectContext!
    var fetchedResultsController: NSFetchedResultsController<Nouille>!
    
    let fetchRequest: NSFetchRequest<Nouille> = Nouille.fetchRequest()
    
    var selectedPredicate: NSPredicate?
    var selectedSortDescriptor: [NSSortDescriptor]?
    
    // Which filters/predicates to use
    var filters = Filters()
    
    let sortDescriptorIndexKey = "sortDescriptorIndexKey"
    let predicateIndexKey = "predicateIndexKey"
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addNoodleButton: UIBarButtonItem!
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Theme related
        tableView.separatorColor = NoodlesStyleKit.baseGreen
        tableView.backgroundColor = NoodlesStyleKit.mediumYellow

        // customize filter button
        filterButton.title = "\u{2630}"
        
        // read sort and predicate prefs
        
        if let sortIndex = UserDefaults.standard.value(forKey: sortDescriptorIndexKey) {
            
            selectedSortDescriptor = filters.sortForIndex(index: sortIndex as! Int)
            selectedPredicate = filters.predicateForIndex(index: UserDefaults.standard.value(forKey: predicateIndexKey) as! Int)
            
        } else {
            // there are no prefs, so use defaults
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
    
    override func viewWillAppear(_ animated: Bool) {
        // update display, if a timer completed while the user was in another
        // view, there might be a TimerView displayed still
        tableView.reloadData()
        // if we have one or more timers running, start a display timer
        if timers.isNotEmpty() {
            DispatchQueue.main.async {
                self.internalTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ListeDeNouillesVC.updateTimers), userInfo: nil, repeats: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // ivalidate any running timer before switching to anoter VC
        internalTimer.invalidate()
    }
    
    // MARK: - Utilities
    
    // Update any/all timers animations
    func updateTimers() {
        if !currentlyEditing {
            if timers.isNotEmpty() {
                for (_, noodleTimer) in timers.timersArray {
                    if noodleTimer.isRunning() {
                        tableView.reloadData()
                    }
                }
            } else {
                internalTimer.invalidate()
                tableView.reloadData()
            }
        }
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
        
        // If this color is changed, be sure to also change the timerView
        // backgroundcolor below to the same color
        cell.backgroundColor = NoodlesStyleKit.lighterYellow
        
        cell.nameLabel?.text = nouille.name!
        cell.brandLabel?.text = nouille.brand!
        cell.qtyUnitLabel.text = .cp
        cell.timeUnitLabel.text = .mn
        
        if nouille.mealSizePrefered! as Bool {
            cell.qtyLabel?.text = Nouille.formatWithFraction(value: Double(nouille.servingCustom!))
            cell.mealSizeView?.image = NoodlesStyleKit.imageOfMealSizeIndicator
        } else {
            cell.qtyLabel?.text = Nouille.formatWithFraction(value: Double(nouille.servingSideDish!))
            cell.mealSizeView?.image = NoodlesStyleKit.imageOfMealSizeIndicatorSD
        }
        cell.timeLabel?.text = Nouille.formatWithExponent(value: Double(nouille.time!))
        
        // Set image of noodle or timer if one is running
        if timers.hasTimerFor(noodle: nouille) {
            cell.timerView.isHidden = false
            cell.timerView.backgroundColor = NoodlesStyleKit.lighterYellow
            if let noodleTimer = timers.timerFor(noodle: nouille) {
                if noodleTimer.isRunning() {
                    cell.timerView.progress = noodleTimer.timerRatio()
                }
            }
        } else {
            cell.timerView.isHidden = true
            if let imageData = nouille.image as? Data {
                let boxImage = UIImage(data: imageData)
                cell.boxImageView?.image = boxImage
            } else {
                // draw default image
                cell.boxImageView?.image = NoodlesStyleKit.imageOfNouille
            }
        }
        
        // set rating indicator (number of stars)
        cell.ratingImageView?.image = NoodlesStyleKit.imageOfRatingIndicator(rating: nouille.rating as! CGFloat)
        
        // set 'on hand' indicator
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
        
        var tableViewRowActions: [UITableViewRowAction]?
        
        let nouille = fetchedResultsController.object(at: indexPath)

        // Here we offer different actions if the row has an active timer. In that
        // case we offer to play/pause the timer or cancel it. Otherwise it's the
        // normal behavior of offering to delete or toggle the 'on hand' status.
        if timers.hasTimerFor(noodle: nouille) {
            let togglePlayPauseTimerAction = UITableViewRowAction(style: .normal, title: "\u{2016}/\u{25B6}", handler: { (action, indexPath) in
                print("play/pause tapped")
            })
            togglePlayPauseTimerAction.backgroundColor = NoodlesStyleKit.baseGreen

            let cancelTimerAction = UITableViewRowAction(style: .normal, title: "\u{25FC}", handler: { (action, indexPath) in
                print("cancel tapped")
            })
            cancelTimerAction.backgroundColor = NoodlesStyleKit.warning

            tableViewRowActions = [ togglePlayPauseTimerAction, cancelTimerAction ]
        } else {
        // add toggle onHand setting action
        let toggleOnHandAction = UITableViewRowAction(style: .normal, title: "\u{2612}\n\(.toggle)\n\(.onHandLabel)", handler: { (action, indexPath) -> Void in
            
            let nouille = self.fetchedResultsController.object(at: indexPath)
            
            let onHand = !(nouille.onHand as! Bool)
            nouille.onHand = onHand as NSNumber?
            
            do {
                try self.managedContext.save()
            } catch let error as NSError {
                print("Could not save context \(error), \(error.userInfo)")
            }
        })
        toggleOnHandAction.backgroundColor = NoodlesStyleKit.baseGreen
        
        // add delete noodle action
            let deleteNoodleAction = UITableViewRowAction(style: .default, title: "\u{267A}\n\(.delete)", handler: { (action, indexPath) -> Void in
                
                let nouille = self.fetchedResultsController.object(at: indexPath)
                
                self.managedContext.delete(nouille)
                
                do {
                    try self.managedContext.save()
                } catch let error as NSError {
                    print("Could not save context \(error), \(error.userInfo)")
                }
                
                // if user deleted a noodle and a timer was running, we need to
                // delete it as well
                if self.timers.hasTimerFor(noodle: nouille) {
                    self.timers.deleteTimerFor(noodle: nouille)
                }
            })
            deleteNoodleAction.backgroundColor = NoodlesStyleKit.darkerOrange
            tableViewRowActions = [toggleOnHandAction, deleteNoodleAction]
        }
        
        return tableViewRowActions
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        // This will stop the update of the timers in the listview
        // while the user is swiping a row to toggle 'on hand' or delete a row
        currentlyEditing = true
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        // This will restart the update of the timers in the listview
        // after the user swipied a row to toggle 'on hand' or deleted a row
        currentlyEditing = false
    }
}

// MARK: - Table View Delegate

extension ListeDeNouillesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // a row was selected, prepare the segue
        let nouille = fetchedResultsController.object(at: indexPath)
        let vc = storyboard?.instantiateViewController(withIdentifier: "NouilleDetailVC") as! NouilleDetailVC
        // dependencies injection
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
    
    // This is used to return modifications to the sort descriptors and
    // predicates from the FilterVC (delegate pattern)
    func filterVC(filter: FilterVC) {
        
        selectedPredicate = filters.predicate()
        selectedSortDescriptor = filters.sortDescriptors()
        
        // remove previous
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
