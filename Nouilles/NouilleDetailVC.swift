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
   
   var numberOfServings: Int = 3
   
   let tapRec = UITapGestureRecognizer()
   
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
   @IBOutlet weak var rating: UILabel!
   @IBOutlet weak var isMealSize: UISwitch!
   
   // MARK: - Actions
   
   @IBAction func minusTapped(_ sender: Any) {
      numberOfServings -= 1
      if numberOfServings < 1 { numberOfServings = 1 }
      updateInterface()
   }
   
   @IBAction func plusTapped(_ sender: Any) {
      numberOfServings += 1
      if numberOfServings > 9 { numberOfServings = 9 }
      updateInterface()
   }
   
   @IBAction func changeRatingTapped(_ sender: Any) {
   }
   
   
   @IBAction func startTimerTapped(_ sender: Any) {
      
      // segue to take picture VC
      let controller = storyboard?.instantiateViewController(withIdentifier: "TimerVC") as! TimerVC
      
      if let nouille = nouille {
         if let time = nouille.time {
            controller.cookingTime = Int(Double(time) * 60.0)
         }

      } else {
         fatalError("Nouille is nil in startTimerTapped")
      }
      
      show(controller, sender: self)
   }
   
   @IBAction func preferedMealSizeTapped(_ sender: Any) {
      if let nouille = nouille {
         nouille.mealSizePrefered = isMealSize.isOn as NSNumber
         
         do {
            try managedContext?.save()
         } catch let error as NSError {
            print("Could not save context in preferedMealSizeTapped \(error), \(error.userInfo)")
         }

      }
      updateInterface()
   }
   
   func imageTapped() {
      print("image was tapped")
      
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
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // add gesture recognizer for tap on image 
      // even if no camera is available on device
      // because user can choose from the album
      
      // add gesture recognizer on image so user can add/change picture
      tapRec.addTarget(self, action: #selector(NouilleDetailVC.imageTapped))
      image.addGestureRecognizer(tapRec)

      updateInterface()
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
         name.text = nouille.name!
         brand.text = nouille.brand!
         servings.text = "\(numberOfServings)"
         isMealSize.isOn = nouille.mealSizePrefered! as Bool
         if nouille.mealSizePrefered! as Bool {
            servingSize.text = "\(nouille.servingCustom!)"
            customServingSize = Double(nouille.servingCustom!)
            let totalServing = Double(numberOfServings) * customServingSize
            totalServingSize.text = "\(totalServing)"
         } else {
            servingSize.text = "\(nouille.servingSideDish!)"
            customServingSize = Double(nouille.servingSideDish!)
            let totalServing = Double(numberOfServings) * customServingSize
            totalServingSize.text = "\(totalServing)"
         }
         rating.text = "\(nouille.rating!)"
         cookingTime.text = "\(nouille.time!) mn"
         
         image.contentMode = .scaleAspectFill
         if let imageData = nouille.image {
            image.image = UIImage(data: imageData as Data)
         } else if let imageDeNouille = UIImage(named: "penne.png") {
            image.image = imageDeNouille
         }
         
         // nutritional information
         
         if let nb_serving = nouille.serving {
            referenceServing = Double(nb_serving)
            servingSize.text = "\(nb_serving)"
         } else {
            calories.text = .noData
         }
        
         if let nb_calories = nouille.calories {
            let scaled = scaleData(qty: Double(nb_calories))
            calories.text = "\(scaled)"
         } else {
            calories.text = .noData
         }
         if let nb_fat = nouille.fat {
            let scaled = scaleData(qty: Double(nb_fat))
            fat.text = "\(scaled)"
         } else {
            fat.text = .noData
         }
         if let nb_saturated = nouille.saturated {
            let scaled = scaleData(qty: Double(nb_saturated))
            saturated.text = "\(scaled)"
         } else {
            saturated.text = .noData
         }
         if let nb_trans = nouille.trans {
            let scaled = scaleData(qty: Double(nb_trans))
            trans.text = "\(scaled)"
         } else {
            trans.text = .noData
         }
         if let nb_sodium = nouille.sodium {
            let scaled = scaleData(qty: Double(nb_sodium))
            sodium.text = "\(scaled)"
         } else {
            sodium.text = .noData
         }
         if let nb_carbs = nouille.carbs {
            let scaled = scaleData(qty: Double(nb_carbs))
            carbs.text = "\(scaled)"
         } else {
            carbs.text = .noData
         }
         if let nb_fibre = nouille.fibre {
            let scaled = scaleData(qty: Double(nb_fibre))
            fibres.text = "\(scaled)"
         } else {
            fibres.text = .noData
         }
         if let nb_sugars = nouille.sugar {
            let scaled = scaleData(qty: Double(nb_sugars))
            sugars.text = "\(scaled)"
         } else {
            sugars.text = .noData
         }
         if let nb_protein = nouille.protein {
            let scaled = scaleData(qty: Double(nb_protein))
            protein.text = "\(scaled)"
         } else {
            protein.text = .noData
         }

      
      }
   }
   
   
}
