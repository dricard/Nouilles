//
//  EditDataVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-02.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class EditDataVC: UITableViewController {
   
   // MARK: - Properties
   
   var nouille: Nouille?
   
   // MARK: - Outlets
   
   // MARK: - Life Cycle
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
   
   
   // MARK: - Table view data source
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      
      guard let nouille = nouille else { return 0 }
      
      return nouille.numberOfSection()
      
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
      guard let nouille = nouille else { return 0 }
      
      return nouille.numberOfRows(section: section)
      
   }
   
   func configureTextCell(cell: UITableViewCell, indexPath: IndexPath) {
      let textCell = cell as! TextTableViewCell
      textCell.dataLabel.text = nouille?.dataLabel(indexPath: indexPath)
      textCell.label.text = nouille?.data(indexPath: indexPath)
   }
   
   func configureNumberCell(cell: UITableViewCell, indexPath: IndexPath) {
      let numberCell = cell as! NumberTableViewCell
      numberCell.dataLabel.text = nouille?.dataLabel(indexPath: indexPath)
      numberCell.label.text = nouille?.data(indexPath: indexPath)
   }
   
   func configureBoolCell(cell: UITableViewCell, indexPath: IndexPath) {
      let boolCell = cell as! BoolTableViewCell
      boolCell.dataLabel.text = nouille?.dataLabel(indexPath: indexPath)
      boolCell.label.text = nouille?.data(indexPath: indexPath)
      boolCell.boolStateSwitch.isOn = nouille!.state(indexPath: indexPath)
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
      let identifier = nouille?.reuseIdentifier(indexPath: indexPath)
      
      let cell = tableView.dequeueReusableCell(withIdentifier: identifier!, for: indexPath)
      
      if identifier! == "TextCell" {
         configureTextCell(cell: cell, indexPath: indexPath)
      } else if identifier! == "NumberCell" {
         configureNumberCell(cell: cell, indexPath: indexPath)
      } else if identifier == "BoolCell" {
         configureBoolCell(cell: cell, indexPath: indexPath)
      }
      return cell   
   }
   
   
   /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
   
   /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
    // Delete the row from the data source
    tableView.deleteRows(at: [indexPath], with: .fade)
    } else if editingStyle == .insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
   
   /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    
    }
    */
   
   /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
}
