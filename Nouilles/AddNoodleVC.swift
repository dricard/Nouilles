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
            if self.saveNoodleData() {
               // save was successful, pop back to root vc
               _ = self.navigationController?.popViewController(animated: true)
            } else {
               // there was an error in the save, alert the user
               print("Error while saving")
               // TODO: - Present alert to user regarding what went wrong
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
      let newBackButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(AddNoodleVC.backButtonTapped))
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
   
   func unsavedChanges() -> Bool {
      
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
