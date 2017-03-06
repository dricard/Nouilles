//
//  NouilleDetailVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-15.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class NouilleDetailVC: UIViewController {
    
    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext?
    var nouille: Nouille?
    var timers: Timers?
    var indexPath: IndexPath?
    
    let tapRec = UITapGestureRecognizer()
    let tapMS = UITapGestureRecognizer()
    let tapSeg = UITapGestureRecognizer()
    let tapOH = UITapGestureRecognizer()
    let tapTimerButton = UITapGestureRecognizer()
    
    // This is used to try only once to fetch data from
    // the network if missing nutritional information
    var didNotTryToFetch = true
    
    // MARK: - Outlets
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var brand: UILabel!
    @IBOutlet weak var servings: UILabel!
    @IBOutlet weak var totalServingSize: UILabel!
    
    @IBOutlet weak var cookingTime: UILabel!
    @IBOutlet weak var servingSize: UILabel!
    
    @IBOutlet weak var calories: UILabel!
    @IBOutlet weak var fat: UILabel!
    @IBOutlet weak var saturated: UILabel!
    @IBOutlet weak var trans: UILabel!
    @IBOutlet weak var sodium: UILabel!
    @IBOutlet weak var carbs: UILabel!
    @IBOutlet weak var fibres: UILabel!
    @IBOutlet weak var sugars: UILabel!
    @IBOutlet weak var protein: UILabel!
    @IBOutlet weak var mealPreferedSizeIndicator: UIImageView!
    @IBOutlet weak var ratingView: UIImageView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var onHandIndicatorView: UIImageView!
    @IBOutlet weak var timerButton: TimerButton!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var longNoodlesView: UIImageView!
    @IBOutlet weak var glutenFreeView: UIImageView!
    @IBOutlet weak var longNoodlesPortionButton: UIButton!
    
    
    // MARK: - Actions
    
    @IBAction func segmentedControlTapped(_ sender: Any) {

        FIRAnalytics.logEvent(withName: Names.segmentedControlTappedEvent, parameters: nil)

        var numberOfServings = nouille?.numberOfServing as! Int16
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            // substract
            numberOfServings -= 1
            if numberOfServings < 1 { numberOfServings = 1 }
        case 1:
            // add
            numberOfServings += 1
            if numberOfServings > 9 { numberOfServings = 9 }
        default:
            break
        }
        nouille?.numberOfServing = numberOfServings as NSNumber
        updateInterface()
        
    }
    
    func startTimerTapped(_ sender: Any) {
        
        FIRAnalytics.logEvent(withName: Names.timerStartedEvent, parameters: nil)
        guard let timers = timers, let nouille = nouille else { return }
        // check if a timer is running already for this noodle
        if !timers.hasTimerFor(noodle: nouille) {
            // no current timer for this noodle, so we create a new one
            if let indexPath = indexPath {
                timers.createTimerFor(noodle: nouille, indexPath: indexPath)
            } else {
                fatalError("No indexPath in NouilleDetailVC/startTimerTapped")
            }
        }
        
        // segue to take Timer VC
        
        // instantiate VC
        let controller = storyboard?.instantiateViewController(withIdentifier: "TimerVC") as! TimerVC
        
        // we pass the timer information along (dependencies injections)
        // we need both the timer (noodleTimer) and the Timers object
        // (timers) because some actions require class methods from Timers.
        controller.noodleTimer = timers.timerFor(noodle: nouille)
        controller.timers = timers
        controller.nouille = nouille
        
        // present the VC
        show(controller, sender: self)
    }
    
    // toggle the prefered meal size indicator when tapped
    func preferedMealSizeTapped(_ sender: Any) {
        
        FIRAnalytics.logEvent(withName: Names.mealSizeButtonTappedEvent, parameters: nil)

        if let nouille = nouille {
            let newState = !(nouille.mealSizePrefered as! Bool)
            nouille.mealSizePrefered = newState as NSNumber
            
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save context in preferedMealSizeTapped \(error), \(error.userInfo)")
            }
            
        }
        updateInterface()
    }
    
    // toggle the 'on hand' indicator when tapped
    func onHandTapped(_ sender: Any) {
        
        FIRAnalytics.logEvent(withName: Names.availableButtonTappedEvent, parameters: nil)

        if let nouille = nouille {
            
            let newState = !(nouille.onHand as! Bool)
            nouille.onHand = newState as NSNumber
            
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save context in preferedMealSizeTapped \(error), \(error.userInfo)")
            }
            
        }
        updateInterface()
    }
    
    // when the image is tapped we segue to the Take picture VC
    func imageTapped() {
        
        FIRAnalytics.logEvent(withName: Names.pictureTappedEvent, parameters: nil)

        // segue to take picture VC
        let controller = storyboard?.instantiateViewController(withIdentifier: "TakePictureVC") as! TakePictureVC
        
        if let nouille = nouille {
            if let imageData = nouille.image {
                controller.passedImage = UIImage(data: imageData as Data)
            }
            controller.managedContext = managedContext
            controller.nouille = nouille
        } else {
            fatalError("Nouille is nil in imageTapped")
        }
        
        show(controller, sender: self)
        
    }
    
    // segue to edit values VC when 'edit' button tapped
    func editButtonTapped() {
        
        FIRAnalytics.logEvent(withName: Names.editButtonTappedEvent, parameters: nil)

        // segue to edit data VC
        let controller = storyboard?.instantiateViewController(withIdentifier: "EditDataVC") as! EditDataVC
        
        if let nouille = nouille {
            controller.nouille = nouille
        } else {
            fatalError()
        }
        show(controller, sender: self)
    }
    
    @IBAction func longNoodlesPortionTapped(_ sender: Any) {
        FIRAnalytics.logEvent(withName: Names.longNoodlesUnitsButtonTappedEvent, parameters: nil)
        
        var totalServing: Double
        
        // segue to edit data VC
        let controller = storyboard?.instantiateViewController(withIdentifier: "LongNoodlesPortionVC") as! LongNoodlesPortionVC
        
        if let nouille = nouille {
            let numberOfServings = nouille.numberOfServing as! Int
            if nouille.mealSizePrefered! as Bool {
                let customServingSize = Double(nouille.servingCustom!)
                totalServing = Double(numberOfServings) * customServingSize
            } else {
                let customServingSize = Double(nouille.servingSideDish!)
                totalServing = Double(numberOfServings) * customServingSize
            }
            controller.portion = totalServing
        }
        
        show(controller, sender: self)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Theme related
        view.backgroundColor = NoodlesStyleKit.lighterYellow
        
        // localize
        numberOfPeopleLabel.text = .numberOfPeopleLabel

        longNoodlesPortionButton.layer.cornerRadius = 25
        longNoodlesPortionButton.layer.borderWidth = 2
        longNoodlesPortionButton.layer.borderColor = NoodlesStyleKit.darkerGreen.cgColor
        
        timeLabel.text = .mn
        
        // add gesture recognizer for tap on image
        // even if no camera is available on device
        // because user can choose from the album
        
        // add gesture recognizer on image so user can add/change picture
        tapRec.addTarget(self, action: #selector(NouilleDetailVC.imageTapped))
        image.addGestureRecognizer(tapRec)
        
        // add gesture recognizer on preferedMealSize so user can toggle
        tapMS.addTarget(self, action: #selector(NouilleDetailVC.preferedMealSizeTapped))
        mealPreferedSizeIndicator.addGestureRecognizer(tapMS)
        
        // add gesture recognizer on onHandIndicator so user can toggle
        tapOH.addTarget(self, action: #selector(NouilleDetailVC.onHandTapped))
        onHandIndicatorView.addGestureRecognizer(tapOH)
        
        // add segmented control target
        segmentedControl.addTarget(self, action: #selector(NouilleDetailVC.segmentedControlTapped), for: .valueChanged)
        
        // add edit button to navigation bar
        let editButton = UIBarButtonItem(title: .editButtonlabel, style: .plain, target: self, action: #selector(NouilleDetailVC.editButtonTapped))
        self.navigationItem.rightBarButtonItem = editButton
        
        // add gesture recognizer on timer button so user can start timer
        tapTimerButton.addTarget(self, action: #selector(NouilleDetailVC.startTimerTapped))
        timerButton.addGestureRecognizer(tapTimerButton)
        
        // Add blur to blurView
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = NoodlesStyleKit.lighterYellow
        blurEffectView.alpha = 0.6
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
        // Hide indicator views for now
        activityIndicator.hidesWhenStopped = true
        blurView.alpha = 0.0
        
        updateInterface()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // we might have changed the usual number of servings, so save
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save context \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Things may have changed, so
        updateInterface()
    }
    
    // MARK: - Utilities
        
    func presentNetworkErrorDialog(_ error: NSError) {
        
        let controller = UIAlertController()
        controller.title = .networkError
        controller.message = "\(NetworkParams.message(error: error.code))"
        
        let okAction = UIAlertAction(title: .ok, style: UIAlertActionStyle.default, handler: nil)
        controller.addAction(okAction)
        present(controller, animated: true, completion: nil)
        
    }

    func updateInterface() {
        
        var customServingSize: Double = 0.0
        var referenceServing: Double = 0.0
        
        // utility function
        func scaleData(qty: Double) -> Double {
            
            if referenceServing != 0 {
                return customServingSize * qty / referenceServing
            } else {
                // Try downloading data from the food info API
                
                if didNotTryToFetch {
                    // change display to advise user that network activity is going on
                    blurView.alpha = 1.0
                    activityIndicator.startAnimating()
                    
                    // Ask Model to fetch nutritional information
                    Nouille.checkForNutritionalInformation(nouille: nouille, context: managedContext!) { success, error in
                        if success {
                            DispatchQueue.main.async {
                                self.activityIndicator.stopAnimating()
                                self.blurView.alpha = 0.0
                                self.updateInterface()
                            }
                        } else {
                            self.activityIndicator.stopAnimating()
                            self.blurView.alpha = 0.0
                            if let error = error {
                                self.presentNetworkErrorDialog(error)
                            }
                        }
                    }
                    didNotTryToFetch = false
                }
                return 0
            }
            
        }
        
        if let nouille = nouille {
            let numberOfServings = nouille.numberOfServing as! Int
            name.text = nouille.name!
            brand.text = nouille.brand!
            servings.text = "\(numberOfServings)"
            if nouille.mealSizePrefered! as Bool {
                mealPreferedSizeIndicator?.image = NoodlesStyleKit.imageOfMealSizeIndicator
                servingSize.text = "\(nouille.servingCustom!)"
                customServingSize = Double(nouille.servingCustom!)
                let totalServing = Double(numberOfServings) * customServingSize
                totalServingSize.text = Nouille.formatWithFraction(value: totalServing)
            } else {
                mealPreferedSizeIndicator?.image = NoodlesStyleKit.imageOfMealSizeIndicatorSD
                servingSize.text = "\(nouille.servingSideDish!)"
                customServingSize = Double(nouille.servingSideDish!)
                let totalServing = Double(numberOfServings) * customServingSize
                totalServingSize.text = Nouille.formatWithFraction(value: totalServing)
            }
            ratingView?.image = NoodlesStyleKit.imageOfRatingIndicator(rating: nouille.rating as! CGFloat)
            cookingTime.text = Nouille.formatWithExponent(value: Double(nouille.time!))
            
            image.contentMode = .scaleAspectFill
            if let imageData = nouille.image {
                image.image = UIImage(data: imageData as Data)
            } else {
                image.image = NoodlesStyleKit.imageOfNoodlePlaceholderImage
            }
            
            if nouille.onHand as! Bool {
                onHandIndicatorView?.image = NoodlesStyleKit.imageOfOnHandIndicator
            } else {
                onHandIndicatorView?.image = NoodlesStyleKit.imageOfOnHandIndicatorEmpty
            }
            
            if nouille.glutenFree as! Bool {
                glutenFreeView.image = NoodlesStyleKit.imageOfGlutenFreeBadge
            } else {
                glutenFreeView.image = nil
            }
            
            if nouille.longNoodles as! Bool {
                longNoodlesView.image = NoodlesStyleKit.imageOfLongNoodles
            } else {
                longNoodlesView.image = nil
            }
            
            // nutritional information
            
            if let nb_serving = nouille.serving {
                referenceServing = Double(nb_serving)
                let servingString = Nouille.formatWithFraction(value: referenceServing)
                servingSize.text = "\(servingString) " + .cp
            } else {
                calories.text = .noData
            }
            
            if let nb_calories = nouille.calories {
                let scaled = scaleData(qty: Double(nb_calories))
                calories.text = Nouille.formatedNutritionalInfo(for: "calories", with: scaled)
            } else {
                calories.text = .noData
            }
            if let nb_fat = nouille.fat {
                let scaled = scaleData(qty: Double(nb_fat))
                fat.text = Nouille.formatedNutritionalInfo(for: "fat", with: scaled)
            } else {
                fat.text = .noData
            }
            if let nb_saturated = nouille.saturated {
                let scaled = scaleData(qty: Double(nb_saturated))
                saturated.text = Nouille.formatedNutritionalInfo(for: "saturated", with: scaled)
            } else {
                saturated.text = .noData
            }
            if let nb_trans = nouille.trans {
                let scaled = scaleData(qty: Double(nb_trans))
                trans.text = Nouille.formatedNutritionalInfo(for: "trans", with: scaled)
            } else {
                trans.text = .noData
            }
            if let nb_sodium = nouille.sodium {
                let scaled = scaleData(qty: Double(nb_sodium))
                sodium.text = Nouille.formatedNutritionalInfo(for: "sodium", with: scaled)
            } else {
                sodium.text = .noData
            }
            if let nb_carbs = nouille.carbs {
                let scaled = scaleData(qty: Double(nb_carbs))
                carbs.text = Nouille.formatedNutritionalInfo(for: "carbs", with: scaled)
            } else {
                carbs.text = .noData
            }
            if let nb_fibre = nouille.fibre {
                let scaled = scaleData(qty: Double(nb_fibre))
                fibres.text = Nouille.formatedNutritionalInfo(for: "fibre", with: scaled)
            } else {
                fibres.text = .noData
            }
            if let nb_sugars = nouille.sugar {
                let scaled = scaleData(qty: Double(nb_sugars))
                sugars.text = Nouille.formatedNutritionalInfo(for: "sugar", with: scaled)
            } else {
                sugars.text = .noData
            }
            if let nb_protein = nouille.protein {
                let scaled = scaleData(qty: Double(nb_protein))
                protein.text = Nouille.formatedNutritionalInfo(for: "protein", with: scaled)
            } else {
                protein.text = .noData
            }
            
            // change quantity units and enable portion button if longnoodles
            if nouille.longNoodles as! Bool {
                unitsLabel.text = ""
                unitsLabel.isHidden = true
                longNoodlesPortionButton.setTitle(.po, for: .normal)
                longNoodlesPortionButton.isHidden = false
                longNoodlesPortionButton.backgroundColor = NoodlesStyleKit.baseGreen
            } else {
                unitsLabel.text = .cp
                unitsLabel.isHidden = false
                longNoodlesPortionButton.isHidden = true
            }

            // update/modify timer button depending if a timer
            // is running or not
            guard let timers = timers else { return }
            if timers.hasTimerFor(noodle: nouille) {
                // change button name to 'show'
                timerButton.buttonLabel = .timerShowLabel
            } else {
                // change button name to 'start'
                timerButton.buttonLabel = .timerStartLabel
           }
        }
    }
    
    
}
