//
//  AboutVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2017-01-23.
//  Copyright © 2017 Hexaedre. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {

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
        
        let url = URL(string: "http://hexaedre.com/apps/noodles/")
        if let url = url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func supportButtonTapped(_ sender: Any) {
        
        let url = URL(string: "mailto:dr@hexaedre.com?subject=Noodle%20App%20support%20request&body=Please%20ask%20your%20quetion%20or%20make%20your%20comment%20here.%20Thank%20you!")
        if let url = url {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // MARK: - Lyfe Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // theme related
        view.backgroundColor = NoodlesStyleKit.lighterYellow

        // localization
        title = .aboutNoodles
        
        titleLabel.text = .noodles
        madeByLabel.text = .isMadeByLabel
        dedicatedToLabel.text = .dedicatedToLabel
        dedicationLabel.text = .dedicationLabel
        soundCreditLabel.text = .ringCredits
        helpButton.setTitle(.helpButtonLabel, for: .normal)
        supportButton.setTitle(.supportButtonLabel, for: .normal)
        
        // display current version number
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            versionLabel.text = "v. " + version + " (" + buildNumber + ")"
        }
        
        // display copyright
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let year = Int(formatter.string(from: today))!
        copyrightLabel.text = "© \(year) Hexaedre"

    }
}
