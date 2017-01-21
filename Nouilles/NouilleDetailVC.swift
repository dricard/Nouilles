//
//  NouilleDetailVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-15.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import CoreData

class NouilleDetailVC: UIViewController {
    
    // MARK: - Properties
    
    var managedContext: NSManagedObjectContext?
    var nouille: Nouille?
    var timers: Timers?
    
    let tapRec = UITapGestureRecognizer()
    let tapMS = UITapGestureRecognizer()
    let tapSeg = UITapGestureRecognizer()
    let tapOH = UITapGestureRecognizer()
    let tapTimerButton = UITapGestureRecognizer()
    
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
    
    // MARK: - Actions
    
    @IBAction func segmentedControlTapped(_ sender: Any) {
        
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
        
        guard let timers = timers, let nouille = nouille else { return }
        // check if a timer is running already for this noodle
        if !timers.hasTimerFor(noodle: nouille) {
            // no current timer for this noodle, so we create a new one
            timers.createTimerFor(noodle: nouille)
        }
        
        // segue to take picture VC
        
        // instantiate VC
        let controller = storyboard?.instantiateViewController(withIdentifier: "TimerVC") as! TimerVC
        
        // we pass the timer information along
        controller.noodleTimer = timers.timerFor(noodle: nouille)
        controller.timers = timers
        controller.nouille = nouille
        
        // present the VC
        show(controller, sender: self)
    }
    
    func preferedMealSizeTapped(_ sender: Any) {
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
    
    func onHandTapped(_ sender: Any) {
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
    
    func imageTapped() {
        
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
    
    func editButtonTapped() {
        
        // segue to edit data VC
        let controller = storyboard?.instantiateViewController(withIdentifier: "EditDataVC") as! EditDataVC
        
        if let nouille = nouille {
            controller.nouille = nouille
        } else {
            fatalError()
        }
        show(controller, sender: self)
    }
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = NoodlesStyleKit.lighterYellow
        
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
        
        // localize
        numberOfPeopleLabel.text = .numberOfPeopleLabel
        unitsLabel.text = .cp
        timeLabel.text = .mn
        
        // add gesture recognizer on timer button so user can start timer
        tapTimerButton.addTarget(self, action: #selector(NouilleDetailVC.startTimerTapped))
        timerButton.addGestureRecognizer(tapTimerButton)
        
        updateInterface()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // we might have changed the usual number of servings, save
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save context \(error), \(error.userInfo)")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateInterface()
    }
    
    // MARK: - Utilities
    
    func updateInterface() {
        
        var customServingSize: Double = 0.0
        var referenceServing: Double = 0.0
        
        func scaleData(qty: Double) -> Double {
            
            if referenceServing != 0 {
                return customServingSize * qty / referenceServing
            } else {
                print("DIVIDE BY ZERO ERROR")
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
            } else if let imageDeNouille = UIImage(named: "penne.png") {
                image.image = imageDeNouille
            }
            
            if nouille.onHand as! Bool {
                onHandIndicatorView?.image = NoodlesStyleKit.imageOfOnHandIndicator
            } else {
                onHandIndicatorView?.image = NoodlesStyleKit.imageOfOnHandIndicatorEmpty
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
            
            // update modify timer button depending if a timer
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
