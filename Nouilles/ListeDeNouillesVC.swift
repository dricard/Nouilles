//
//  ListeDeNouillesVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import CoreData

class ListeDeNouillesVC: UIViewController {
   
   // MARK: - Properties
   
   var managedContext: NSManagedObjectContext!
   
   // MARK: - Outlets
   
   @IBOutlet var tableView: UITableView!
   @IBOutlet weak var addNoodleButton: UIBarButtonItem!
   
   // MARK: - Actions
   
   @IBAction func addNoodleTapped(_ sender: Any) {
      
      
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      
      if segue.identifier == "AddNoodleVC" {
         let vc = segue.destination as! AddNoodleVC
         vc.managedContext = self.managedContext!
      } else if segue.identifier == "NouilleDetailVC" {
         let vc = segue.destination as! NouilleDetailVC
         vc.managedContext = self.managedContext!
      }
      
      
   }
}

// MARK: - Table View Data Source

extension ListeDeNouillesVC: UITableViewDataSource {
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return 1
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Nouille", for: indexPath)
      
      cell.textLabel?.text = "Penne Rifate"
      if let detail = cell.detailTextLabel {
         detail.text = "\(8)"
      }
      return cell
   }
   
}

// MARK: - Table View Delegate

extension ListeDeNouillesVC: UITableViewDelegate {
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
      // a row was selected, prepare the segue
      
      
   }
}
