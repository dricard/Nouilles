//
//  NouilleDetailVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-15.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class NouilleDetailVC: UIViewController {

   // MARK: - Outlets
   
   @IBOutlet weak var image: UIView!
   @IBOutlet weak var name: UIView!
   @IBOutlet weak var brand: UIView!
   @IBOutlet weak var servings: UIView!
   @IBOutlet weak var totalServingSize: UIView!
   
   @IBOutlet weak var cookingTime: UIView!
   @IBOutlet weak var servingSize: UIView!
   
   @IBOutlet weak var calories: UIView!
   @IBOutlet weak var fat: UIView!
   @IBOutlet var saturated: UILabel!
   @IBOutlet weak var trans: UILabel!
   @IBOutlet weak var sodium: UILabel!
   @IBOutlet weak var carbs: UILabel!
   @IBOutlet weak var fibres: UILabel!
   @IBOutlet weak var sugars: UILabel!
   @IBOutlet weak var protein: UILabel!
   @IBOutlet weak var rating: UILabel!
   
   // MARK: - Actions
   
   @IBAction func minusTapped(_ sender: Any) {
   }
   
   @IBAction func plusTapped(_ sender: Any) {
   }
   
   @IBAction func changeRatingTapped(_ sender: Any) {
   }
   
   
   @IBAction func startTimerTapped(_ sender: Any) {
   }
   
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
