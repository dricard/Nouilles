//
//  TakePictureVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-17.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class TakePictureVC: UIViewController {
   
   // MARK: - Outlets
   
   @IBOutlet weak var albumButton: UIBarButtonItem!
   @IBOutlet weak var cameraButton: UIBarButtonItem!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var instructionLabel: UILabel!
   
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Actions
   
   @IBAction func cameraTapped(_ sender: Any) {
   }
   
   @IBAction func albumTapped(_ sender: Any) {
   }
   
}
