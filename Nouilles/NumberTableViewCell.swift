//
//  NumberTableViewCell.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-02.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class NumberTableViewCell: UITableViewCell {

   // MARK: - Outlets
   
   @IBOutlet weak var dataLabel: UILabel!
   @IBOutlet weak var label: UILabel!
   @IBOutlet weak var textField: UITextField!
   
   
   // MARK: - Life Cycle
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
