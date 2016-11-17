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
   
   // MARK: - Outlets
   
   @IBOutlet weak var image: UIView!
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
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
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
         servingSize.text = "\(nouille.servingCustom!)"
         totalServingSize.text = "\(Double(numberOfServings) * Double(nouille.servingCustom!))"
         rating.text = "\(nouille.rating!)"
         cookingTime.text = "\(nouille.time!)"
      }
   }
   
   
}
