//
//  NoodleListTableViewCell.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-30.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import SwipeCellKit

class NoodleListTableViewCell: SwipeTableViewCell {
    
    // MARK: - Properties
    static let reuseIdentifier = "Nouille"
    
    // MARK: - Outlets
    
    @IBOutlet weak var boxImageView: UIImageView!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeUnitLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var qtyUnitLabel: UILabel!
    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var mealSizeView: UIImageView!
    @IBOutlet weak var onHandIndicatorView: UIImageView!
    @IBOutlet weak var timerView: TimerViewWithLabels!
    @IBOutlet weak var longNoodlesView: UIImageView!
    @IBOutlet weak var glutenFreeView: UIImageView!
    
}
