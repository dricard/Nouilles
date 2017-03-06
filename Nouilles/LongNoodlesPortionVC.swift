//
//  LongNoodlesPortionVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-03-05.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class LongNoodlesPortionVC: UIViewController {

    // MARK: - Properties
    
    var portion:  Double?
    
    // MARK: - Outlets
    
    @IBOutlet weak var portionLabel: UILabel!
    @IBOutlet weak var portionView: UIView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = NoodlesStyleKit.baseGreen
        portionView.backgroundColor = NoodlesStyleKit.baseGreen
        
    }

    override func viewDidLayoutSubviews() {
        if let portion = portion {
            portionLabel.text = "\(portion)"
            let portionRect = CGRect(x: portionView.bounds.width/2 - 100, y: portionView.bounds.height/2 - 100, width: 200, height: 200)
            drawRingFittingInsideView(rect: portionRect)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Utilities
    
    private func drawRingFittingInsideView(rect: CGRect) {
        
        let lineWidth: CGFloat = 4
        let halfWidth = lineWidth / 2
        
        let insetRect = UIEdgeInsetsInsetRect(rect, UIEdgeInsetsMake(halfWidth, halfWidth, halfWidth, halfWidth))
        let circlePath = UIBezierPath(ovalIn: insetRect)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = NoodlesStyleKit.lighterYellow.cgColor
        shapeLayer.strokeColor = NoodlesStyleKit.darkerGreen.cgColor
        shapeLayer.lineWidth = lineWidth
        portionView.layer.addSublayer(shapeLayer)
    }
}
