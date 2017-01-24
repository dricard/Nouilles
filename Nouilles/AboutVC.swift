//
//  AboutVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-01-23.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

    // MARK: - properties
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var madeByLabel: UILabel!
    @IBOutlet weak var dedicatedToLabel: UILabel!
    @IBOutlet weak var soundCreditLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var supportButton: UIButton!
    @IBOutlet weak var copyrightLabel: UILabel!
    @IBOutlet weak var dedicationLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction func helpButtonTapped(_ sender: Any) {
    }
    
    @IBAction func supportButtonTapped(_ sender: Any) {
    }
    
    // MARK: - Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = .aboutNoodles
        
        titleLabel.text = .noodles
        madeByLabel.text = .isMadeByLabel
        dedicatedToLabel.text = .dedicatedToLabel
        dedicationLabel.text = .dedicationLabel
        soundCreditLabel.text = .ringCredits
        helpButton.setTitle(.helpButtonLabel, for: .normal)
        supportButton.setTitle(.supportButtonLabel, for: .normal)
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "v. " + version
        }
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.string(from: today))!
        copyrightLabel.text = "© \(year) Hexaedre"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
