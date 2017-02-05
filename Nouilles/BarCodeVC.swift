//
//  BarCodeVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

/* THIS IS INSPIRED/ADAPTED FROM A TUTORIAL ON IMPLEMENTING BARCODE SCANNING */

/* 
    This uses the built-in camera on the device to scan a barcode on the
    noodle box and try fetching information from a REST API to populate
    input fields for the user.
 
    There is no need to check if there is a camera available on the device
    because this has been done upstream in the AddNoodleVC and if that
    was the case, the button would be disabled and the user could not have
    gotten here.
 
    Scanning results vary depending on the origin of the noodles. The API
    provider used is based in the US and I am guessin it would work well
    with noodles available there. None of those I tested here in Canada
    provided information. I left this code in here because it might be useful
    in the US or elsewhere and I think the scanning code is interesting.
 
*/

import UIKit
import AVFoundation

class BarCodeVC: UIViewController {
    
    // MARK: - Properties
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var barCodeFrameView: UIView?
    var successView: ScanSuccessView?
    var sound = Sound()
    var scanResults: BarCodeResult?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize a device object
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // instantiate device input
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // initialize the capture screen session
            captureSession = AVCaptureSession()
            
            // set the input device on the capture session
            captureSession?.addInput(input)
            
            // initialize a AVCaptureMetadataOutput object and set as output to capture session
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // set the delegate and use default dispatch queue to execute
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code]
            
            // initialize the video preview layer and add it as a sublayer
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // initialize Barcode frame to highlight barcode
            // this is zero size for now so invisible
            barCodeFrameView = UIView()
            
            if let barCodeFrameView = barCodeFrameView {
                barCodeFrameView.layer.borderColor = NoodlesStyleKit.success.cgColor
                barCodeFrameView.layer.borderWidth = 2
                view.addSubview(barCodeFrameView)
                view.bringSubview(toFront: barCodeFrameView)
            }
            
            // Initialize the successView (success or failure indicator)
            successView = ScanSuccessView()
            if let successView = successView {
                view.addSubview(successView)
                successView.translatesAutoresizingMaskIntoConstraints = false
                successView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -75).isActive = true
                successView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
                successView.heightAnchor.constraint(equalToConstant: 75).isActive = true
                successView.widthAnchor.constraint(equalToConstant: 75).isActive = true
                successView.backgroundColor = UIColor.clear
                view.bringSubview(toFront: successView)
            }
            
            successView?.isHidden = true
            
            // start video capture
            captureSession?.startRunning()
            
        } catch let error as NSError {
            print("Could not instantiate AVCaptureDeviceInput \(error), \(error.userInfo)")
        }
    }
}

extension BarCodeVC: AVCaptureMetadataOutputObjectsDelegate {
    
    enum SuccessState {
        case successWithData
        case failureTalkingWithAPI
        case failureToReturnData
    }
    
    func presentBarCodeResult(for success: Bool, state: SuccessState) {
        
        let title: String = success ? .successful : .failure
        var scanSuccess: String
        switch state {
        case .successWithData:
            scanSuccess = .successWithData
        case .failureToReturnData:
            scanSuccess = .failureToReturnData
        case .failureTalkingWithAPI:
            scanSuccess = .failureToCommunicateWithAPI
        }
        let alertVC = UIAlertController(title: title, message: scanSuccess, preferredStyle: .alert)
        let actionOK = UIAlertAction(title: .ok, style: .default, handler: nil)
        alertVC.addAction(actionOK)
        present(alertVC, animated: true, completion: nil)
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        // check if metadata object is not nil and contains at least one object
        guard metadataObjects != nil, metadataObjects.count != 0 else {
            // resetting the green border to zero (user moved away from a barcode)
            barCodeFrameView?.frame = CGRect.zero
            return
        }
        
        // get the metadata object
        let metadataObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
        
        if metadataObject.type == AVMetadataObjectTypeUPCECode || metadataObject.type == AVMetadataObjectTypeEAN8Code || metadataObject.type == AVMetadataObjectTypeEAN13Code {
            
            let barCodeObj = videoPreviewLayer?.transformedMetadataObject(for: metadataObject)
            barCodeFrameView?.frame = barCodeObj!.bounds
            
            if let codeValue = metadataObject.stringValue {
                
                // we found a barcode: stop scanning
                captureSession?.stopRunning()
                
                // give audio feedback
                sound.playBeep()
                
                // show the success state view
                successView?.isHidden = false
                
                let upc = String(codeValue.characters.dropFirst())
                
                // send 'find by UPC' request to network API
                NetworkCoordinator.sendFindUPCRequest(upc: upc, completionHandlerForUPCRequest: { (productInfo, success, error) in
                    
                    // Utility to extract value from a string
                    func valueFromString(text: String) -> Double? {
                        var matches = [String]()
                        do {
                            let regex = try NSRegularExpression(pattern: "[0-9]+.[0-9]+", options: [])
                            let nsString = text as NSString
                            let results = regex.matches(in: text, options: [], range: NSMakeRange(0, nsString.length))
                            matches = results.map { nsString.substring(with: $0.range) }
                        } catch let error as NSError {
                            print("Could not create valid REGEX \(error), \(error.userInfo)")
                        }
                        if let subString = matches.first {
                            return Double(subString)
                        }
                        return nil
                    }
                    
                    // check for error
                    guard error == nil else {
                        // no need to print error, it was taken care in network code
                        self.successView?.successState = .failure
                        return
                    }
                    
                    // check for success
                    guard success else {
                        // 'success' here only means the communication with the API
                        // was successful, not that any useful information was
                        // returned. If this failed then we present the user with info
                        self.presentBarCodeResult(for: false, state: .failureTalkingWithAPI)
                        return
                    }
                    
                    if let result = productInfo {
                        // we have data
                        // update the success indicator
                        if result["status"] != nil {
                            self.successView?.successState = .failure
                            self.presentBarCodeResult(for: false, state: .failureToReturnData)
                        } else {
                            self.successView?.successState = .success
                            self.presentBarCodeResult(for: true, state: .successWithData)
                            
                            // if successful, extract useful information
                            if let scanResults = self.scanResults {
                                
                                // set the success flag to true
                                scanResults.success = true
                                
                                // find useful information in returned data
                                if let title = result["title"] {
                                    // the "title" property contains both the brand and the name of
                                    // the pasta, so we need to do some checking on the words
                                    // Normally the brand comes first, then the product name
                                    let wordsInTitle = (title as! String).characters.split(separator: " ").map{ String($0) }
                                    if wordsInTitle.count == 1 {
                                        scanResults.brand = wordsInTitle.first
                                    } else if wordsInTitle.count == 2 {
                                        scanResults.brand = wordsInTitle[0]
                                        scanResults.name = wordsInTitle[1]
                                    } else {
                                        // TODO: - perhaps offer a choice to the user
                                        // we have a number of words > 2 that are split between
                                        // the brand name and the pasta name
                                        // for now split between the two
                                        let brandIndex = Int(wordsInTitle.count / 2)
                                        var brand = ""
                                        var name = ""
                                        for index in 0..<brandIndex {
                                            brand += wordsInTitle[index] + " "
                                        }
                                        for index in brandIndex..<wordsInTitle.count {
                                            name += wordsInTitle[index] + " "
                                        }
                                        scanResults.brand = brand
                                        scanResults.name = name
                                    }
                                }
                                if let servingSize = result["serving_size"] {
                                    if let servingSizeValue = valueFromString(text: servingSize as! String) {
                                        scanResults.servingSize = servingSizeValue
                                    }
                                }
                                if let importantBadges = result["important_badges"] as! [String]? {
                                    // this will be useful in a later version where I will
                                    // implement allergies badges/predicates in list view
                                    let glutenFreeBadge = importantBadges.contains(where: { $0 == "gluten_free" })
                                    scanResults.glutenFree = glutenFreeBadge
                                }
                            }
                        }
                    }
                })
            }
        }
    }
}
