//
//  ChangeValueVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-03.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

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
   
   // MARK: - Actions
   
   func cancelButtonTapped(_ sender: Any) {
      textField.resignFirstResponder()
      navigationController!.popViewController(animated: true)
   }
   
   // Enable touch outside to end editing
   override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      shouldReturn = false
      view.endEditing(true)
   }
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // add cancel button to navigation bar
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ChangeValueVC.cancelButtonTapped))
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

      guard let nouille = nouille, let indexPath = indexPath else { return .valid }
      
      let validator = nouille.validator(indexPath: indexPath)
      
      // validate the data
      switch validator.validateValue(textField.text!) {
      case .valid:
         if editType == "NumberCell" {
            // we chan for unwrap since the data was
            // validated for typecast to Double in the validation
            let returnValue = Double(textField.text!)!
            nouille.updateValue(value: returnValue, forDataAt: indexPath)
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
         navigationController!.popViewController(animated: true)
      } else {
         _ = validateAndSave()
         shouldReturn = true
      }
   }
}
