//
//  AddNoodleVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-16.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class AddNoodleVC: UIViewController {

   
   // MARK: - Outlets
   
   @IBOutlet weak var nameInput: UITextField!
   @IBOutlet weak var brandInput: UITextField!
   @IBOutlet weak var mealServingInput: UITextField!
   @IBOutlet weak var sideDishServingInput: UITextField!
   @IBOutlet weak var ratingINput: UITextField!
   
   // MARK: - Actions
   
   @IBAction func addPictureTapped(_ sender: Any) {
   }
   
   @IBAction func scanBardoceTapped(_ sender: Any) {
   }
   
   @IBAction func cancelTapped(_ sender: Any) {
   }
   
   @IBAction func saveTapped(_ sender: Any) {
   }
   
   // MARK: - Life Cycle
   
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
