//
//  BarCodeVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-21.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeVC: UIViewController {
   
   // MARK: - Properties
   
   var captureSession: AVCaptureSession?
   var videoPreviewLayer: AVCaptureVideoPreviewLayer?
   var barCodeFrameView: UIView?
   
   
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
            barCodeFrameView.layer.borderColor = UIColor.green.cgColor
            barCodeFrameView.layer.borderWidth = 2
            view.addSubview(barCodeFrameView)
            view.bringSubview(toFront: barCodeFrameView)
         }
         
         // start video capture
         captureSession?.startRunning()
         
         
      } catch let error as NSError {
         print("Could not instantiate AVCaptureDeviceInput \(error), \(error.userInfo)")
      }

   }
   
}

extension BarCodeVC: AVCaptureMetadataOutputObjectsDelegate {
   
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
            print("Found metadata with value: \(codeValue)")
         }

      }
      
   }
}
