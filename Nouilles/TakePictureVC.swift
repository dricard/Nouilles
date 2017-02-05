//
//  TakePictureVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-17.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

/* 
    This lets the user take a picture of the noodles to use
    or select an image/picture from the album.
 
    The take picture button is disabled if the device has
    no camera (older iPods for instance). In this case
    the user can only chose from the album.
 
*/

import UIKit
import CoreData

class TakePictureVC: UIViewController {
    
    // MARK: - Properties
    
    // we use this property to hold the passed image
    // in case the user cancels the operation
    var passedImage: UIImage?
    
    var managedContext: NSManagedObjectContext?
    var nouille: Nouille?
    
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
        // change the instructions label depending on presence/absence of camera
        if cameraButton.isEnabled {
            instructionLabel.text = .cameraAvailableOnDevice
        } else {
            instructionLabel.text = .noCameraOnDevice
        }
        
        // if we had an image passed in, use that, otherwise use default
        if let image = passedImage {
            setUIImage(image: image)
        } else {
            instructionLabel.isHidden = false
        }
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
            pickController.showsCameraControls = true
            
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
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        instructionLabel.isHidden = true
    }
    
}

extension TakePictureVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        setUIImage(image: info[UIImagePickerControllerEditedImage] as! UIImage)
        if nouille != nil {
            nouille!.image = UIImagePNGRepresentation(info[UIImagePickerControllerEditedImage] as! UIImage) as NSData?
            if nouille!.image == nil {
                fatalError("image is nil")
            }
            do {
                try managedContext?.save()
            } catch let error as NSError {
                print("Could not save context \(error), \(error.userInfo)")
            }
            
        } else {
            fatalError("Nouille is nil in TakePictureVC")
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
