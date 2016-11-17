//
//  AddNoodleVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-16.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import CoreData

class AddNoodleVC: UIViewController {

   // MARK: - Properties
   
   var managedContext: NSManagedObjectContext?
   
   // MARK: - Outlets
   
   @IBOutlet weak var nameInput: UITextField!
   @IBOutlet weak var brandInput: UITextField!
   @IBOutlet weak var mealServingInput: UITextField!
   @IBOutlet weak var sideDishServingInput: UITextField!
   @IBOutlet weak var ratingInput: UITextField!
   @IBOutlet weak var cookingTimeInput: UITextField!
   
   // MARK: - Actions
   
   @IBAction func addPictureTapped(_ sender: Any) {
   }
   
   @IBAction func scanBardoceTapped(_ sender: Any) {
   }
   
   @IBAction func cancelTapped(_ sender: Any) {
      navigationController!.popViewController(animated: true)
   }
   
   @IBAction func saveTapped(_ sender: Any) {
      if saveNoodleData() {
         // save was successful, pop back to root vc
         navigationController!.popViewController(animated: true)
      } else {
         // there was an error in the save, alert the user
         print("Error while saving")
         // TODO: - Present alert to user regarding what went wrong
      }
   }
   
   // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   // MARK: - Processing and saving Data

   func saveNoodleData() -> Bool {
      
      let newNoodle = Nouille(context: managedContext!)
      
      if let name = nameInput.text {
         newNoodle.name = name
      } else {
         return false
      }
      
      if let brand = brandInput.text {
         newNoodle.brand = brand
      } else {
         return false
      }

      
      if let serving = Double(mealServingInput.text!) {
         newNoodle.servingCustom = serving as NSNumber?
      } else {
         return false
      }

      
      if let sideDishServing = Double(sideDishServingInput.text!) {
         newNoodle.servingSideDish = sideDishServing as NSNumber
      } else {
         return false
      }

      if let cookingTime = Double(cookingTimeInput.text!) {
         newNoodle.time = cookingTime as NSNumber
      } else {
         return false
      }

      if let rating = Double(ratingInput.text!) {
         newNoodle.rating = rating as NSNumber
      } else {
         return false
      }

      // default to prefer meal size servings
      newNoodle.mealSizePrefered = true as NSNumber
      
      do {
         try managedContext?.save()
      } catch let error as NSError {
         print("Could not save context in saveNoodleData() \(error), \(error.userInfo)")
      }

      return true
   }
   
}

extension AddNoodleVC: UITextFieldDelegate {
   
   // Enable touch outide textfields to end editing
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      view.endEditing(true)
   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
      // TODO: - Check validity of input value
      
      textField.resignFirstResponder()
      
      return true
   }
   
   func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
      
      // first deal with first responder
      if textField.isFirstResponder {
         textField.resignFirstResponder()
      }
      
      switch reason {
      case .committed:
         if saveNoodleData() {
            navigationController!.popViewController(animated: true)
         }
      case .cancelled:
         navigationController!.popToRootViewController(animated: true)
      }
   }
}
