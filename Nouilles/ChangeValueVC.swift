//
//  ChangeValueVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-03.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

/*
 This VC lets the user change one value for a specific
 noodle. Two types of values can be changed here, either
 a numerical value or text.
 
 The type is passed in the editType variable.
 
 */

import UIKit

class ChangeValueVC: UIViewController {
    
    // MARK: - Properties
    
    var nouille: Nouille?
    var editType: String?
    var indexPath: IndexPath?
    var shouldReturn: Bool = true
    
    // MARK: - Outlets
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var valueNameLabel: UILabel!
    @IBOutlet weak var valueUnitLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var currentValueTitleLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        switch validateAndSave() {
        case .valid:
            textField.resignFirstResponder()
        //            navigationController!.popViewController(animated: true)
        case .invalid(_):
            return
        }
    }
    
    func cancelButtonTapped(_ sender: Any) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
    // Enable touch outside to end editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        shouldReturn = false
        view.endEditing(true)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // localization
        title = .editTitle
        saveButton.setTitle(.save, for: .normal)
        promptLabel.text = .enterValueLabel
        currentValueTitleLabel.text = .currentValueLabel
        
        // Theme related
        view.backgroundColor = NoodlesStyleKit.lighterYellow
        
        // add cancel button to navigation bar
        let cancelButton = UIBarButtonItem(title: .cancel, style: .plain, target: self, action: #selector(ChangeValueVC.cancelButtonTapped))
        self.navigationItem.rightBarButtonItem = cancelButton
        
        // Fill in the data
        if let nouille = nouille, let indexPath = indexPath {
            valueNameLabel.text = nouille.dataLabel(indexPath: indexPath)
            currentValueLabel.text = nouille.data(indexPath: indexPath)
            valueUnitLabel.text = nouille.unitsLabel(indexPath: indexPath)
            textField.text = nouille.data(indexPath: indexPath)
        }
        
        textField.delegate = self
    }
    
}

extension ChangeValueVC: UITextFieldDelegate {
    
    func presentValidationErrorDialog(_ field: String, _ error: Error) {
        
        let controller = UIAlertController()
        controller.title = .invalidEntry
        let errorType = "\(error)"
        controller.message = "\(.field) '\(field)' \(ErrorCode.message(rawValue: errorType))"
        
        let okAction = UIAlertAction(title: .ok, style: UIAlertActionStyle.default, handler: nil)
        controller.addAction(okAction)
        self.present(controller, animated: true, completion: nil)
        
    }
    
    func validateAndSave() -> ValidatorResult {
        
        guard let nouille = nouille, let indexPath = indexPath, let inputText = textField.text else { return .valid }
        
        var textToValidate = inputText
        
        let validator = nouille.validator(indexPath: indexPath)
        
        if editType == DataCellTypes.valueCell.rawValue {
            // if we're dealing with a number we first strip trailing spaces if any
            // because it throws the validation
            textToValidate = inputText.replacingOccurrences(of: " ", with: "")
            // change occurences of ',' to '.' for french users
            textToValidate = textToValidate.replacingOccurrences(of: ",", with: ".")
        }
        // validate the data
        switch validator.validateValue(textToValidate) {
        case .valid:
            if editType == DataCellTypes.valueCell.rawValue {
                // we can force unwrap the cast to Double here since the data was
                // validated for typecast to Double in the validation process
                let returnValue = Double(textToValidate)!
                nouille.updateValue(value: returnValue, forDataAt: indexPath)
            } else if editType == DataCellTypes.textCell.rawValue {
                nouille.updateText(newText: textToValidate, forDataAt: indexPath)
            }
            return .valid
        case .invalid(let error):
            presentValidationErrorDialog(nouille.dataLabel(indexPath: indexPath), error)
            return .invalid(error: error)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch validateAndSave() {
        case .valid:
            textField.resignFirstResponder()
            return true
        case .invalid(_):
            return true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
        if shouldReturn {
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true)
            }
        } else {
            _ = validateAndSave()
            shouldReturn = true
        }
    }
}
