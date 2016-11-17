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
   }
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // add gesture recognizer for tap on image if camera available on device
      
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
         tapRec.addTarget(self, action: #selector(NouilleDetailVC.imageTapped))
         image.addGestureRecognizer(tapRec)
      }
      
      updateInterface()
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
         
         // placeholder image for now
         // TODO: - put code to display proper image
         
         if let imageDeNouille = UIImage(named: "penne.png") {
            image.contentMode = .scaleAspectFill
            image.image = imageDeNouille
         }
      }
   }
   
   
}
