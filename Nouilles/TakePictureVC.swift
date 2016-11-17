//
//  TakePictureVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-17.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class TakePictureVC: UIViewController {
   
   // MARK: - Properties
   
   var passedImage: UIImage?
   
   // MARK: - Outlets
   
   @IBOutlet weak var albumButton: UIBarButtonItem!
   @IBOutlet weak var cameraButton: UIBarButtonItem!
   @IBOutlet weak var imageView: UIImageView!
   @IBOutlet weak var instructionLabel: UILabel!
   
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Disable the camera if the device does not have one
      cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
      // change the instruction in that case
      if !cameraButton.isEnabled {
         instructionLabel.text = "Choose an image from the Album \n(no camera on this device)"
      }

      if let image = passedImage {
         imageView.contentMode = .scaleAspectFill
         imageView.image = image
         instructionLabel.isHidden = true
      } else {
         instructionLabel.isHidden = false
      }
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   // MARK: - Actions
   
   @IBAction func cameraTapped(_ sender: Any) {
      let pickController = UIImagePickerController()
      if UIImagePickerController.isSourceTypeAvailable(.camera) {
         
         pickController.delegate = self
         pickController.sourceType = .camera
         
         let availableTypes = UIImagePickerController.availableMediaTypes(for: pickController.sourceType)
         
         pickController.mediaTypes = availableTypes!
         pickController.allowsEditing = true
         
         present(pickController, animated: true, completion: nil)
         
      }
   }
   
   @IBAction func albumTapped(_ sender: Any) {
      
      let pickController = UIImagePickerController()
      if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
         
         pickController.delegate = self
         pickController.sourceType = .photoLibrary

         let availableTypes = UIImagePickerController.availableMediaTypes(for: pickController.sourceType)
         
         pickController.mediaTypes = availableTypes!
         pickController.allowsEditing = true

         present(pickController, animated: true, completion: nil)
     
      }
   }
   
   // MARK: - Utilities
   
   func setUIImage(image: UIImage) {
      imageView.image = image
   }
   
}

extension TakePictureVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
      dismiss(animated: true, completion: nil)
      setUIImage(image: info[UIImagePickerControllerEditedImage] as! UIImage)
   }
   
   func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
      dismiss(animated: true, completion: nil)
   }
}
