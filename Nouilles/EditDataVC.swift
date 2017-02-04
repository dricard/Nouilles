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
        title = "Edit"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
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
        
        cell.backgroundColor = NoodlesStyleKit.lighterYellow
        cell.accessoryType = .disclosureIndicator
        
        if identifier! == "TextCell" {
            configureTextCell(cell: cell, indexPath: indexPath)
        } else if identifier! == "NumberCell" {
            configureNumberCell(cell: cell, indexPath: indexPath)
        } else if identifier == "BoolCell" {
            configureBoolCell(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if nouille?.reuseIdentifier(indexPath: indexPath) != "BoolCell" {
            let controller = storyboard?.instantiateViewController(withIdentifier: "ChangeValueVC") as! ChangeValueVC
            if let nouille = nouille {
                controller.nouille = nouille
                controller.editType = nouille.reuseIdentifier(indexPath: indexPath)
                controller.indexPath = indexPath
            } else {
                fatalError()
            }
            
            show(controller, sender: self)
        }
    }
    
}
