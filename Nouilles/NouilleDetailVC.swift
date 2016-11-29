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

      // Ask Model to make sure we have nutritional information
      Nouille.checkForNutritionalInformation(nouille: nouille, context: managedContext!)
      
      updateInterface()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      updateInterface()
   }
   
   // MARK: - Utilities
   
   func updateInterface() {
      
      if let nouille = nouille {
         name.text = nouille.name!
         brand.text = nouille.brand!
         servings.text = "\(numberOfServings)"
         isMealSize.isOn = nouille.mealSizePrefered! as Bool
         if nouille.mealSizePrefered! as Bool {
            servingSize.text = "\(nouille.servingCustom!)"
            totalServingSize.text = "\(Double(numberOfServings) * Double(nouille.servingCustom!))"
         } else {
            servingSize.text = "\(nouille.servingSideDish!)"
            totalServingSize.text = "\(Double(numberOfServings) * Double(nouille.servingSideDish!))"
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
         
         if let nb_calories = nouille.calories {
            calories.text = "\(nb_calories)"
         } else {
            calories.text = .noData
         }

         if let nb_fat = nouille.fat {
            fat.text = "\(nb_fat)"
         } else {
            fat.text = .noData
         }
         if let nb_saturated = nouille.saturated {
            saturated.text = "\(nb_saturated)"
         } else {
            saturated.text = .noData
         }
         if let nb_trans = nouille.trans {
            trans.text = "\(nb_trans)"
         } else {
            trans.text = .noData
         }
         if let nb_sodium = nouille.sodium {
            sodium.text = "\(nb_sodium)"
         } else {
            sodium.text = .noData
         }
         if let nb_carbs = nouille.carbs {
            carbs.text = "\(nb_carbs)"
         } else {
            carbs.text = .noData
         }
         if let nb_fibre = nouille.fibre {
            fibres.text = "\(nb_fibre)"
         } else {
            fibres.text = .noData
         }
         if let nb_sugars = nouille.sugar {
            sugars.text = "\(nb_sugars)"
         } else {
            sugars.text = .noData
         }
         if let nb_protein = nouille.protein {
            protein.text = "\(nb_protein)"
         } else {
            protein.text = .noData
         }

      
      }
   }
   
   
}
