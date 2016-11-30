//
//  NoodleListTableViewCell.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-30.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class NoodleListTableViewCell: UITableViewCell {

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
   
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
