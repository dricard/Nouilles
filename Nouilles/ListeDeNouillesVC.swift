//
//  ListeDeNouillesVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit
import CoreData

class ListeDeNouillesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   // MARK: - Properties
   
   var managedContext: NSManagedObjectContext!
   
   // MARK: - Outlets
   
   @IBOutlet var tableView: UITableView!
   @IBAction func addNoodleTapped(_ sender: Any) {
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return nouilles.listeDeNouilles.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "Nouille", for: indexPath)
      
      cell.textLabel?.text = nouilles.listeDeNouilles[indexPath.row].name
      if let detail = cell.detailTextLabel {
         detail.text = "\(nouilles.listeDeNouilles[indexPath.row].time)"
      }
      return cell
   }
   
}
