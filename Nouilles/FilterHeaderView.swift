//
//  FilterHeaderView.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-02-04.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

/// Custom header view for the FilterVC to customize appearance
class FilterHeaderView: UIView {

    // MARK: - Properties
    
    var label: UILabel!
    
    convenience init() {
        self.init(frame: CGRect.zero) // Since the tableView will lay this out itself
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubViews()
    }

    func setupSubViews() {
        
        // set background color of header
        backgroundColor = NoodlesStyleKit.lighterGreen
        
        // create a label
        let labelFrame = CGRect(x: 20, y: 20, width: 100, height: 20)
        label = UILabel(frame: labelFrame)
        addSubview(label)
        
        // set constraints on label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
