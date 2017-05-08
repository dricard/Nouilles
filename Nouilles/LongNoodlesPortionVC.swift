//
//  LongNoodlesPortionVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-03-05.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

extension Double {
    func rounded(to precision: Double) -> Double {
        let halfPrecision = precision / 2.0
        return Double(Int(Double(self) / precision + halfPrecision)) * precision
    }
}

class LongNoodlesPortionVC: UIViewController {

    // MARK: - Properties
    
    var nouille: Nouille?
    var portion:  Double?
    let portionAreaInInchesSquared = 0.4464008928
    
    // MARK: - Outlets
    
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var portionView: UIView!
    @IBOutlet weak var portionImageView: UIImageView!
    @IBOutlet weak var portionWidthContraint: NSLayoutConstraint!
    @IBOutlet weak var portionSlider: UISlider!
    @IBOutlet weak var portionHeightConstraint: NSLayoutConstraint!
    
    @IBAction func portionSliderUpdated(_ sender: Any) {
        let newValue = Double(portionSlider.value)
        portion = newValue.rounded(to: 0.25)
        updateMealSize(nouille: nouille)
        updatePortionRadius()
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = NoodlesStyleKit.baseGreen
        portionView.backgroundColor = NoodlesStyleKit.baseGreen
        
        updatePortionRadius()
        
        print(userDeviceName())
    }

    func updatePortionRadius() {
        if let portion = portion {
            portionLabel.text = "\(portion)"
            portionSlider.value = Float(portion)
            let portionRect = rectFromRadius(radius: radiusFrom(portion: portion), bounds: portionView.bounds)
            portionWidthContraint.constant = portionRect.width
            portionHeightConstraint.constant = portionRect.height
        }
    }
    
    // MARK: - Utilities
    
    private func updateMealSize(nouille: Nouille?) {
        if let nouille = nouille, let portion = portion {
            let numberOfServings = nouille.numberOfServing as! Int
            if nouille.mealSizePrefered! as! Bool {
                let customServingSize = portion / Double(numberOfServings)
                nouille.servingCustom = customServingSize as NSNumber
            } else {
                let customServingSize = portion / Double(numberOfServings)
                nouille.servingSideDish = customServingSize as NSNumber
            }
        }
    }
    
    private func radiusFrom(portion: Double) -> Double {
        return sqrt((portion * portionAreaInInchesSquared) / Double.pi) * pixelPerInchOfDevice() / 3
    }
    
    private func rectFromRadius(radius: Double, bounds: CGRect) -> CGRect {
        let radiusCGF = CGFloat(radius)
        print(radius)
        return CGRect(x: bounds.width / 2 - radiusCGF, y: bounds.height / 2 - radiusCGF, width: 2 * radiusCGF, height: 2 * radiusCGF)
    }
        
    func userDeviceName() -> (device: String, ppi: Double) {
        var name: [Int32] = [CTL_HW, HW_MACHINE]
        var size: Int = 2
        sysctl(&name, 2, nil, &size, &name, 0)
        var hw_machine = [CChar](repeating: 0, count: Int(size))
        sysctl(&name, 2, &hw_machine, &size, &name, 0)
        let platform: String = String(cString: hw_machine)
        
        //iPhone
        if platform == "iPhone1,1"        { return ("iPhone 1G", 326) }
        else if platform == "iPhone1,2"   { return ("iPhone 3G", 326) }
        else if platform == "iPhone2,1"   { return ("iPhone 3GS", 326) }
        else if platform == "iPhone3,1"   { return ("iPhone 4", 326) }
        else if platform == "iPhone3,3"   { return ("iPhone 4 (Verizon)", 326) }
        else if platform == "iPhone4,1"   { return ("iPhone 4S", 326) }
        else if platform == "iPhone5,1"   { return ("iPhone 5 (GSM)", 326) }
        else if platform == "iPhone5,2"   { return ("iPhone 5 (GSM+CDMA)", 326) }
        else if platform == "iPhone5,3"   { return ("iPhone 5c (GSM)", 326) }
        else if platform == "iPhone5,4"   { return ("iPhone 5c (GSM+CDMA)", 326) }
        else if platform == "iPhone6,1"   { return ("iPhone 5s (GSM)", 326) }
        else if platform == "iPhone6,2"   { return ("iPhone 5s (GSM+CDMA)", 326) }
        else if platform == "iPhone7,2"   { return ("iPhone 6", 326) }
        else if platform == "iPhone7,1"   { return ("iPhone 6 Plus", 326) }
        else if platform == "iPhone8,1"   { return ("iPhone 6s", 326) }
        else if platform == "iPhone8,2"   { return ("iPhone 6s Plus", 401) }
        else if platform == "iPhone8,4"   { return ("iPhone SE", 326) }
        else if platform == "iPhone9,1"   { return ("iPhone 7 (GSM+CDMA)", 326) }
        else if platform == "iPhone9,3"   { return ("iPhone 7 (GSM)", 326) }
        else if platform == "iPhone9,2"   { return ("iPhone 7 Plus (GSM+CDMA)", 401) }
        else if platform == "iPhone9,4"   { return ("iPhone 7 Plus (GSM)", 401) }
            
            //iPod Touch
        else if platform == "iPod1,1"     { return ("iPod Touch 1G", 326) }
        else if platform == "iPod2,1"     { return ("iPod Touch 2G", 326) }
        else if platform == "iPod3,1"     { return ("iPod Touch 3G", 326) }
        else if platform == "iPod4,1"     { return ("iPod Touch 4G", 326) }
        else if platform == "iPod5,1"     { return ("iPod Touch 5G", 326) }
        else if platform == "iPod7,1"     { return ("iPod Touch 6G", 326) }
            
            //iPad
        else if platform == "iPad1,1"     { return ("iPad 1G", 326) }
        else if platform == "iPad2,1"     { return ("iPad 2 (Wi-Fi)", 326) }
        else if platform == "iPad2,2"     { return ("iPad 2 (GSM)", 326) }
        else if platform == "iPad2,3"     { return ("iPad 2 (CDMA)", 326) }
        else if platform == "iPad2,4"     { return ("iPad 2 (Wi-Fi, Mid 2012)", 326) }
        else if platform == "iPad2,5"     { return ("iPad Mini (Wi-Fi)", 326) }
        else if platform == "iPad2,6"     { return ("iPad Mini (GSM)", 326) }
        else if platform == "iPad2,7"     { return ("iPad Mini (GSM+CDMA)", 326) }
        else if platform == "iPad3,1"     { return ("iPad 3 (Wi-Fi)", 326) }
        else if platform == "iPad3,2"     { return ("iPad 3 (GSM+CDMA)", 326) }
        else if platform == "iPad3,3"     { return ("iPad 3 (GSM)", 326) }
        else if platform == "iPad3,4"     { return ("iPad 4 (Wi-Fi)", 326)}
        else if platform == "iPad3,5"     { return ("iPad 4 (GSM)", 326) }
        else if platform == "iPad3,6"     { return ("iPad 4 (GSM+CDMA)", 326) }
        else if platform == "iPad4,1"     { return ("iPad Air (Wi-Fi)", 326) }
        else if platform == "iPad4,2"     { return ("iPad Air (Cellular)", 326) }
        else if platform == "iPad4,3"     { return ("iPad Air (China)", 326) }
        else if platform == "iPad4,4"     { return ("iPad Mini 2G (Wi-Fi)", 326) }
        else if platform == "iPad4,5"     { return ("iPad Mini 2G (Cellular)", 326) }
        else if platform == "iPad4,6"     { return ("iPad Mini 2G (China)", 326) }
        else if platform == "iPad4,7"     { return ("iPad Mini 3 (Wi-Fi)", 326) }
        else if platform == "iPad4,8"     { return ("iPad Mini 3 (Cellular)", 326) }
        else if platform == "iPad4,9"     { return ("iPad Mini 3 (China)", 326) }
        else if platform == "iPad5,1"     { return ("iPad Mini 4 (Wi-Fi)", 326) }
        else if platform == "iPad5,2"     { return ("iPad Mini 4 (Cellular)", 326) }
        else if platform == "iPad5,3"     { return ("iPad Air 2 (Wi-Fi)", 326) }
        else if platform == "iPad5,4"     { return ("iPad Air 2 (Cellular)", 326) }
        else if platform == "iPad6,3"     { return ("iPad Pro 9.7\" (Wi-Fi)", 326) }
        else if platform == "iPad6,4"     { return ("iPad Pro 9.7\" (Cellular)", 326) }
        else if platform == "iPad6,7"     { return ("iPad Pro 12.9\" (Wi-Fi)", 326) }
        else if platform == "iPad6,8"     { return ("iPad Pro 12.9\" (Cellular)", 326) }
            
            //Apple TV
        else if platform == "AppleTV2,1"  { return ("Apple TV 2G", 326) }
        else if platform == "AppleTV3,1"  { return ("Apple TV 3", 326) }
        else if platform == "AppleTV3,2"  { return ("Apple TV 3 (2013)", 326) }
        else if platform == "AppleTV5,3"  { return ("Apple TV 4", 326) }
            
            //Apple Watch
        else if platform == "Watch1,1"    { return ("Apple Watch Series 1 (38mm, S1)", 326) }
        else if platform == "Watch1,2"    { return ("Apple Watch Series 1 (42mm, S1)", 326) }
        else if platform == "Watch2,6"    { return ("Apple Watch Series 1 (38mm, S1P)", 326) }
        else if platform == "Watch2,7"    { return ("Apple Watch Series 1 (42mm, S1P)", 326) }
        else if platform == "Watch2,3"    { return ("Apple Watch Series 2 (38mm, S2)", 326) }
        else if platform == "Watch2,4"    { return ("Apple Watch Series 2 (42mm, S2)", 326) }
            
            //Simulator
        else if platform == "i386"        { return ("Simulator", 326) }
        else if platform == "x86_64"      { return ("Simulator", 326)}
        
        return ("unknown device", 326)
    }
    
    private func pixelPerInchOfDevice() -> Double {
        let device = userDeviceName()
        return device.ppi
    }
}
