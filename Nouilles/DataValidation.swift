//
//  DataValidation.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-28.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import Foundation

// Inspired by a blog post

// First the result types
enum ValidatorResult {
   case valid
   case invalid(error: Error)
}

// Now the error cases
enum NameBrandValidatorError: Error {
   case empty
}

enum ServingValidatorError: Error {
   case empty
   case notANumber
   case negativeOrZero
}

enum NumberValidatorError: Error {
   case notANumber
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

// Convinience method

enum ErrorCode {
   
   static func message(rawValue: String) -> String {
      switch rawValue {
      case "empty":
         return "cannot be empty"
      case "notANumber":
         return "must be a number"
      case "negativeOrZero":
         return "cannot be negative"
      case "tooBig":
         return "is outside the allowed range of values"
      default:
         return "is invalid"
      }
   }
}

// we define a protocol
protocol Validator {
   func validateValue(_ value: String) -> ValidatorResult
}

// and a series of component validators

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

// and a way to configure them

struct ValidatorConfigurator {
   
   static let sharedInstance = ValidatorConfigurator()
   
   func nameValidator() -> Validator {
      return emptyFieldStringValidator()
   }
   
   func brandValidator() -> Validator {
      return emptyFieldStringValidator()
   }

   func servingValidator() -> Validator {
      return servingStringValidator()
   }

   func sideDishServingValidator() -> Validator {
      return servingStringValidator()
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
   
   private func servingStringValidator() -> Validator {
      return CompositeValidator(validators: EmptyStringValidator(invalidError: ServingValidatorError.empty), NotANumberValidator(invalidError: ServingValidatorError.notANumber), NegativeOrZeroValidator(invalidError: ServingValidatorError.negativeOrZero))
   }

   private func cookingTimeStringValidator() -> Validator {
      return CompositeValidator(validators: EmptyStringValidator(invalidError: CookingTimeValidatorError.empty), NotANumberValidator(invalidError: CookingTimeValidatorError.notANumber), NegativeOrZeroValidator(invalidError: CookingTimeValidatorError.negativeOrZero), TooBigValidator(invalidError: CookingTimeValidatorError.tooBig, maxValue: 60.0))
   }
   
   private func ratingStringValidator() -> Validator {
      return CompositeValidator(validators: EmptyStringValidator(invalidError: RatingValidatingError.empty), NotANumberValidator(invalidError: RatingValidatingError.notANumber), NegativeOrZeroValidator(invalidError: RatingValidatingError.negativeOrZero), TooBigValidator(invalidError: RatingValidatingError.tooBig, maxValue: 5.0))
   }
   

}
