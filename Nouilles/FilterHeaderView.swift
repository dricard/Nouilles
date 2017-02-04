//
//  FilterHeaderView.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-02-04.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

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
        
        backgroundColor = NoodlesStyleKit.lighterGreen
        
        let labelFrame = CGRect(x: 20, y: 20, width: 100, height: 20)
        label = UILabel(frame: labelFrame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 10).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
