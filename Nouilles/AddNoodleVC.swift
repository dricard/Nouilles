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
   var dataSaved: Bool = false
   
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
      let saveActionResult = saveNoodleData()
      if saveActionResult.success {
         // save was successful, pop back to root vc
         navigationController!.popViewController(animated: true)
      }
   }
   
   func backButtonTapped() {
      print("woohoo")
      if unsavedChanges() {
         print("Unsaved Changes")
         let controller = UIAlertController(title: "Unsaved entry", message: "You have entered some data and have not saved, are you sure you to discard the data?", preferredStyle: .alert)
         let discardAction = UIAlertAction(title: "Discard", style: .default) { (action) in
            _ = self.navigationController?.popViewController(animated: true)
         }
         let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action) in
            print("\(action)")
            let saveActionResult = self.saveNoodleData()
            if saveActionResult.success {
               // save was successful, pop back to root vc
               self.navigationController!.popViewController(animated: true)
            } else {
               // there was an error in the save, alert the user
               if let field = saveActionResult.field, let error = saveActionResult.error {
                  self.presentValidationErrorDialog(field, error)
               }
            }
         })
         controller.addAction(discardAction)
         controller.addAction(saveAction)
         present(controller, animated: true, completion: nil)
      } else {
         print("No unsaved changes")
         _ = self.navigationController?.popViewController(animated: true)
      }
   }
   
   // MARK: - Life Cycle
   
    override func viewDidLoad() {
        super.viewDidLoad()

      self.navigationItem.hidesBackButton = true
      let newBackButton = UIBarButtonItem(title: .Back, style: .plain, target: self, action: #selector(AddNoodleVC.backButtonTapped))
      self.navigationItem.leftBarButtonItem = newBackButton
   }
   

   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)

      if self.isMovingFromParentViewController {
         // We are exiting back, check for unsaved inputs
         if unsavedChanges() {
            print("Unsaved Changes")
            let controller = UIAlertController(title: "Unsaved entry", message: "You have entered some data and have not saved, are you sure you want to discard the data?", preferredStyle: .alert)
            let discardAction = UIAlertAction(title: "Discard", style: .default, handler: { (action) in
               print("User chose to discard")
            })
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (action) in
               print("User chose to save")
            })
            controller.addAction(discardAction)
            controller.addAction(saveAction)
            present(controller, animated: true, completion: nil)
         } else {
            print("No unsaved changes")
         }
      }
      
   }
   
   // MARK: - Processing and saving Data

   func presentValidationErrorDialog(_ field: String, _ error: Error) {
      
      print("=============")
      print("In present error dialog")
      print("=============")

      let controller = UIAlertController()
      controller.title = "Invalid Entry"
      let errorType = "\(error)"
      controller.message = "Field '\(field)' \(ErrorCode.message(rawValue: errorType))"
      
      let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil)
      controller.addAction(okAction)
      self.present(controller, animated: true, completion: nil)
      
   }
   
   func saveNoodleData() -> (success: Bool, field: String?, error: Error?) {
      
      // Validation of data properties
      let validatorConfigurator = ValidatorConfigurator.sharedInstance
      let nameValidator = validatorConfigurator.nameValidator()
      let brandValidator = validatorConfigurator.brandValidator()
      let mealServingValidator = validatorConfigurator.servingValidator()
      let sideDishServingValidator = validatorConfigurator.sideDishServingValidator()
      let cookingTimeValidator = validatorConfigurator.cookingTimeValidator()
      let ratingValidator = validatorConfigurator.ratingValidator()
      
      // New noodle data properties
      var _name: String
      var _brand: String
      var _serving: Double
      var _sdServing: Double
      var _time: Double
      var _rating: Double
      
      
      if let name = nameInput.text {
         switch nameValidator.validateValue(name) {
         case .valid:
            _name = name
         case .invalid(let error):
            presentValidationErrorDialog("Name", error)
            return (false, "Name", error)
         }
      } else {
         fatalError()
      }
      
      if let brand = brandInput.text {
         switch brandValidator.validateValue(brand) {
         case .valid:
            _brand = brand
         case .invalid(let error):
            presentValidationErrorDialog("Brand", error)
            return (false, "Brand", error)
         }
      } else {
         fatalError()
      }

      
      if let servingText = mealServingInput.text {
         switch mealServingValidator.validateValue(servingText) {
         case .valid:
            let serving = Double(servingText)!
            _serving = serving
         case .invalid(let error):
            presentValidationErrorDialog("Meal Serving", error)
            return (false, "Meal Serving", error)
         }
      } else {
         fatalError()
      }

      if let sideDishServingText = sideDishServingInput.text {
         switch sideDishServingValidator.validateValue(sideDishServingText) {
         case .valid:
            let serving = Double(sideDishServingText)! // If valid, then it's been checked for casting
            _sdServing = serving
         case .invalid(let error):
            presentValidationErrorDialog("Side dish serving", error)
            return (false, "Side dish serving", error)
         }
      } else {
         fatalError()
      }
      
      if let cookingTimeText = cookingTimeInput.text {
         switch cookingTimeValidator.validateValue(cookingTimeText) {
         case .valid:
            let cookingTime = Double(cookingTimeText)!
            _time = cookingTime
         case .invalid(let error):
            presentValidationErrorDialog("Cooking time", error)
            return (false, "Cooking time", error)
         }
      } else {
         fatalError()
      }

      if let ratingText = ratingInput.text {
         switch ratingValidator.validateValue(ratingText) {
         case .valid:
            let rating = Double(ratingText)!
            _rating = rating
         case .invalid(let error):
            presentValidationErrorDialog("Rating", error)
            return (false, "Rating", error)
         }
      } else {
         fatalError()
      }

      // Create the new noodle
      let newNoodle = Nouille(context: managedContext!)

      // user data
      newNoodle.name = _name
      newNoodle.brand = _brand
      newNoodle.servingCustom = _serving as NSNumber
      newNoodle.servingSideDish = _sdServing as NSNumber
      newNoodle.time = _time as NSNumber
      newNoodle.rating = _rating as NSNumber

      // default to prefer meal size servings
      newNoodle.mealSizePrefered = true as NSNumber
      
      // Save the context / new noodle to coredata
      do {
         try managedContext?.save()
      } catch let error as NSError {
         print("Could not save context in saveNoodleData() \(error), \(error.userInfo)")
      }

      dataSaved = true
      return (true, nil, nil)
   }
   
   
   /// This check if the user started to input data in any
   /// of the fields. If that's the case then we should
   /// warn the user when he moves away from this VC and
   /// might loose what he's entered.
   func unsavedChanges() -> Bool {
      
      if !dataSaved {
         // default to false
         let foundUnsavedData = false
         
         // check for non empty text field
         
         if !(nameInput.text?.isEmpty)! { return true }
         if !(brandInput.text?.isEmpty)! { return true }
         if !(mealServingInput.text?.isEmpty)! { return true }
         if !(sideDishServingInput.text?.isEmpty)! { return true }
         if !(ratingInput.text?.isEmpty)! { return true }
         if !(cookingTimeInput.text?.isEmpty)! { return true }
         
         return foundUnsavedData
      } else {
         return false
      }
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
         print("In .committed")
         let saveActionResult = saveNoodleData()
         if saveActionResult.success {
            // save was successful, pop back to root vc
            navigationController!.popViewController(animated: true)
         } else {
            // there was an error in the save, alert the user
            if let field = saveActionResult.field, let error = saveActionResult.error {
               presentValidationErrorDialog(field, error)
            }
         }
      case .cancelled:
         navigationController!.popToRootViewController(animated: true)
      }
   }
}
