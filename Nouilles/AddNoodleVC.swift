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
    var scanResult = BarCodeResult()
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameInput: UITextField!
    @IBOutlet weak var brandInput: UITextField!
    @IBOutlet weak var mealServingInput: UITextField!
    @IBOutlet weak var sideDishServingInput: UITextField!
    @IBOutlet weak var ratingInput: UITextField!
    @IBOutlet weak var cookingTimeInput: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    // MARK: - Actions
    
    @IBAction func addPictureTapped(_ sender: Any) {
    }
    
    @IBAction func scanBardoceTapped(_ sender: Any) {
        
        // segue to scan barcode VC
        let vc = storyboard?.instantiateViewController(withIdentifier: "BarCodeVC") as! BarCodeVC
        vc.scanResults = scanResult
        
        show(vc, sender: self)
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
        
        if unsavedChanges() {
            
            let controller = UIAlertController(title: .unsavedEntry, message: .areYouSure, preferredStyle: .alert)
            let discardAction = UIAlertAction(title: .discard, style: .default) { (action) in
                _ = self.navigationController?.popViewController(animated: true)
            }
            let saveAction = UIAlertAction(title: .save, style: .default, handler: { (action) in
                
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
            
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = .addNoodleTitle
        view.backgroundColor = NoodlesStyleKit.lighterYellow
        contentView.backgroundColor = NoodlesStyleKit.lighterYellow
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: .Back, style: .plain, target: self, action: #selector(AddNoodleVC.backButtonTapped))
        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            // We are exiting back, check for unsaved inputs
            if unsavedChanges() {
                
                let controller = UIAlertController(title: .unsavedEntry, message: .areYouSure, preferredStyle: .alert)
                let discardAction = UIAlertAction(title: .discard, style: .default, handler: { (action) in
                    print("User chose to discard")
                })
                let saveAction = UIAlertAction(title: .save, style: .default, handler: { (action) in
                    print("User chose to save")
                })
                controller.addAction(discardAction)
                controller.addAction(saveAction)
                present(controller, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if scanResult.success {
            if let name = scanResult.name {
                nameInput.text = name
            }
            if let brand = scanResult.brand {
                brandInput.text = brand
            }
            if let servingSize = scanResult.servingSize {
                mealServingInput.text = "\(servingSize)"
            }
            if let cookingTime = scanResult.cookingTime {
                cookingTimeInput.text = "\(cookingTime)"
            }
        }
    }
    
    // MARK: - Utility
    
    func translateCommaToPeriod(numberString: String) -> String {
        
        return numberString.replacingOccurrences(of: ",", with: ".")
        
    }
    
    // MARK: - Processing and saving Data
    
    func presentValidationErrorDialog(_ field: String, _ error: Error) {
        
        let controller = UIAlertController()
        controller.title = .invalidEntry
        let errorType = "\(error)"
        controller.message = "\(.field) '\(field)' \(ErrorCode.message(rawValue: errorType))"
        
        let okAction = UIAlertAction(title: .ok, style: UIAlertActionStyle.default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func saveNoodleData() -> (success: Bool, field: String?, error: Error?) {
        
        // Validation of data properties
        let validatorConfigurator = ValidatorConfigurator.sharedInstance
        let nameValidator = validatorConfigurator.nameValidator()
        let brandValidator = validatorConfigurator.brandValidator()
        let mealServingValidator = validatorConfigurator.numberValidator()
        let sideDishServingValidator = validatorConfigurator.numberValidator()
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
                presentValidationErrorDialog(.name, error)
                return (false, .name, error)
            }
        } else {
            fatalError()
        }
        
        if let brand = brandInput.text {
            switch brandValidator.validateValue(brand) {
            case .valid:
                _brand = brand
            case .invalid(let error):
                presentValidationErrorDialog(.brand, error)
                return (false, .brand, error)
            }
        } else {
            fatalError()
        }
        
        
        if var servingText = mealServingInput.text {
            // for languages where the decimal indicator is a comma instead of a period
            servingText = translateCommaToPeriod(numberString: servingText)
            switch mealServingValidator.validateValue(servingText) {
            case .valid:
                let serving = Double(servingText)!
                _serving = serving
            case .invalid(let error):
                presentValidationErrorDialog(.mealServing, error)
                return (false, .mealServing, error)
            }
        } else {
            fatalError()
        }
        
        if var sideDishServingText = sideDishServingInput.text {
            // for languages where the decimal indicator is a comma instead of a period
            sideDishServingText = translateCommaToPeriod(numberString: sideDishServingText)

            switch sideDishServingValidator.validateValue(sideDishServingText) {
            case .valid:
                // If valid, then it's been checked for casting
                // so we can for unwrap here
                let serving = Double(sideDishServingText)!
                _sdServing = serving
            case .invalid(let error):
                presentValidationErrorDialog(.sdMealServing, error)
                return (false, .sdMealServing, error)
            }
        } else {
            fatalError()
        }
        
        if var cookingTimeText = cookingTimeInput.text {
            // for languages where the decimal indicator is a comma instead of a period
           cookingTimeText = translateCommaToPeriod(numberString: cookingTimeText)

            switch cookingTimeValidator.validateValue(cookingTimeText) {
            case .valid:
                // If valid, then it's been checked for casting
                // so we can for unwrap here
                let cookingTime = Double(cookingTimeText)!
                _time = cookingTime
            case .invalid(let error):
                presentValidationErrorDialog(.cookingTime, error)
                return (false, .cookingTime, error)
            }
        } else {
            fatalError()
        }
        
        if var ratingText = ratingInput.text {
            // for languages where the decimal indicator is a comma instead of a period
            ratingText = translateCommaToPeriod(numberString: ratingText)

            switch ratingValidator.validateValue(ratingText) {
            case .valid:
                // If valid, then it's been checked for casting
                // so we can for unwrap here
                let rating = Double(ratingText)!
                _rating = rating
            case .invalid(let error):
                presentValidationErrorDialog(.ratingCap, error)
                return (false, .ratingCap, error)
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
        // default to number of serving of 1
        newNoodle.numberOfServing = 1
        // default to onHand
        newNoodle.onHand = true
        
        // Save the context / new noodle to coredata
        do {
            try managedContext?.save()
        } catch let error as NSError {
            print("Could not save context in saveNoodleData() \(error), \(error.userInfo)")
        }
        
        // Ask Model to fetch nutritional information
        Nouille.checkForNutritionalInformation(nouille: newNoodle, context: managedContext!) { success in
            // no need for closure in this case
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
