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
   
   // MARK: - Outlets
   
   @IBOutlet weak var promptLabel: UILabel!
   @IBOutlet weak var valueNameLabel: UILabel!
   @IBOutlet weak var valueUnitLabel: UILabel!
   @IBOutlet weak var currentValueLabel: UILabel!
   @IBOutlet weak var explanationLabel: UILabel!
   @IBOutlet weak var textField: UITextField!
   
   // MARK: - Actions
   
   @IBAction func cancelButtonTapped(_ sender: Any) {
      navigationController!.popViewController(animated: true)
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
   }
   
   // MARK: - Actions
   
   func cancelTapped() {
      
   }

}
