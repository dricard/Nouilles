//
//  DataValidation.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-28.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

// Inspired by a blog post
// This file contains a number of enums and structs that are used
// to validate the data entered by the user. This separates the
// the concerns of the VC and those of the model (which knows
// about the data). The way this is set-up is by component and
// it is composable.

// First the result types
enum ValidatorResult {
   case valid
   case invalid(error: Error)
}

// MARK: - Error Enumerations

// Now the error cases
enum NameBrandValidatorError: Error {
   case empty
}

enum NumberValidatorError: Error {
   case empty
   case notANumber
   case negativeOrZero
}

enum CookingTimeValidatorError: Error {
   case empty
   case notANumber
   case negativeOrZero
   case tooBig
}

enum RatingValidatingError: Error {
   case empty
   case notANumber
   case negativeOrZero
   case tooBig
}

// MARK: - Error Reporting

// Convinience method for error reporting
// this is localization complient
// see LocalizationUtilities.swift
// for the String extension defined to help
// remove the NSLocalizedString code clutter

enum ErrorCode {
   
   static func message(rawValue: String) -> String {
      switch rawValue {
      case "empty":
         return .empty
      case "notANumber":
         return .notANumber
      case "negativeOrZero":
         return .negativeOrZero
      case "tooBig":
         return .tooBig
      default:
         return .invalid
      }
   }
}

// MARK: - Validator Protocol

// we define the protocol
protocol Validator {
   func validateValue(_ value: String) -> ValidatorResult
}

// MARK: - Component Validators

// and a series of component validators

struct discardValidator: Validator {
   internal func validateValue(_ value: String) -> ValidatorResult {
      // this is used for cases where we do not have to
      // validate but it's useful to return something
      return .valid
   }
}

struct EmptyStringValidator: Validator {
   
   // This will allow the validator to be reused
   private let invalidError: Error
   
   init(invalidError: Error) {
      self.invalidError = invalidError
   }
   
   
   func validateValue(_ value: String) -> ValidatorResult {
      if value.isEmpty {
         return .invalid(error: invalidError)
      } else {
         return .valid
      }
   }
}

struct NotANumberValidator: Validator {
   
   // This will allow the validator to be reused
   private let invalidError: Error
   
   init(invalidError: Error) {
      self.invalidError = invalidError
   }
   
   func validateValue(_ value: String) -> ValidatorResult {
      
      guard let _ = Double(value) else {
         return .invalid(error: invalidError)
      }
      
      return .valid
   }
}

struct NegativeOrZeroValidator: Validator {

   // This will allow the validator to be reused
   private let invalidError: Error
   
   init(invalidError: Error) {
      self.invalidError = invalidError
   }
   
   func validateValue(_ value: String) -> ValidatorResult {

      guard let numericalValue = Double(value) else {
         return .invalid(error: NumberValidatorError.notANumber)
      }
      
      if numericalValue <= 0.0 {
         return .invalid(error: invalidError)
      } else {
         return .valid
      }
   }

}

struct TooBigValidator: Validator {
   
   // This will allow the validator to be reused
   private let invalidError: Error
   private let maxValue: Double
   
   init(invalidError: Error, maxValue: Double) {
      self.invalidError = invalidError
      self.maxValue = maxValue
   }
   
   func validateValue(_ value: String) -> ValidatorResult {
      
      guard let numericalValue = Double(value) else {
         return .invalid(error: NumberValidatorError.notANumber)
      }
      
      if numericalValue > maxValue {
         return .invalid(error: invalidError)
      } else {
         return .valid
      }
   }
   
}

// MARK: - Composite Validator

// now a way to compose those component together

struct CompositeValidator: Validator {
   
   private let validators: [Validator]
   
   init(validators: Validator...) {
      self.validators = validators
   }
   
   func validateValue(_ value: String) -> ValidatorResult {
      
      for validator in validators {
         switch validator.validateValue(value) {
         case .valid:
            break
         case .invalid(let error):
            return .invalid(error: error)
         }
      }
      
      return .valid
   }
}

// MARK: - Validator Configuration

// and a way to configure them

struct ValidatorConfigurator {
   
   static let sharedInstance = ValidatorConfigurator()
   
   func boolValidator() -> Validator {
      return discardValidator()
   }

   func nameValidator() -> Validator {
      return emptyFieldStringValidator()
   }
   
   func brandValidator() -> Validator {
      return emptyFieldStringValidator()
   }

   func numberValidator() -> Validator {
      return numberStringValidator()
   }

   func sideDishServingValidator() -> Validator {
      return numberStringValidator()
   }

   func cookingTimeValidator() -> Validator {
      return cookingTimeStringValidator()
   }
   
   func ratingValidator() -> Validator {
      return ratingStringValidator()
   }
   
   // helper methods
   
   private func emptyFieldStringValidator() -> Validator {
      return EmptyStringValidator(invalidError: NameBrandValidatorError.empty)
   }
   
   private func numberStringValidator() -> Validator {
      return CompositeValidator(validators: EmptyStringValidator(invalidError: NumberValidatorError.empty), NotANumberValidator(invalidError: NumberValidatorError.notANumber), NegativeOrZeroValidator(invalidError: NumberValidatorError.negativeOrZero))
   }

   private func cookingTimeStringValidator() -> Validator {
      return CompositeValidator(validators: EmptyStringValidator(invalidError: CookingTimeValidatorError.empty), NotANumberValidator(invalidError: CookingTimeValidatorError.notANumber), NegativeOrZeroValidator(invalidError: CookingTimeValidatorError.negativeOrZero), TooBigValidator(invalidError: CookingTimeValidatorError.tooBig, maxValue: 60.0))
   }
   
   private func ratingStringValidator() -> Validator {
      return CompositeValidator(validators: EmptyStringValidator(invalidError: RatingValidatingError.empty), NotANumberValidator(invalidError: RatingValidatingError.notANumber), NegativeOrZeroValidator(invalidError: RatingValidatingError.negativeOrZero), TooBigValidator(invalidError: RatingValidatingError.tooBig, maxValue: 5.0))
   }
   

}
