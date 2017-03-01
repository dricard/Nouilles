//
//  EditDataVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-02.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

/*
    This lists all the data on a Noodle so the user
    can choose one to edit. The actual modification
    occurs in ChangeValueVC.
 
*/

import UIKit
import Firebase

class EditDataVC: UITableViewController {
    
    // MARK: - Properties
    
    var nouille: Nouille?
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // localization
        title = .editTitle
        
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
        guard let nouille = nouille else { return }
        textCell.dataLabel.text = nouille.dataLabel(indexPath: indexPath)
        textCell.label.text = nouille.data(indexPath: indexPath)
    }
    
    func configureNumberCell(cell: UITableViewCell, indexPath: IndexPath) {
        let numberCell = cell as! NumberTableViewCell
        guard let nouille = nouille else { return }
        numberCell.dataLabel.text = nouille.dataLabel(indexPath: indexPath)
        numberCell.label.text = nouille.data(indexPath: indexPath)
    }
    
    func configureBoolCell(cell: UITableViewCell, indexPath: IndexPath) {
        let boolCell = cell as! BoolTableViewCell
        guard let nouille = nouille else { return }
        boolCell.dataLabel.text = nouille.dataLabel(indexPath: indexPath)
        boolCell.label.text = nouille.data(indexPath: indexPath)
        boolCell.boolStateSwitch.isOn = nouille.state(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let nouille = nouille else { return UITableViewCell() }
        let identifier = nouille.reuseIdentifier(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        // Theme related
        cell.backgroundColor = NoodlesStyleKit.lighterYellow
        cell.accessoryType = .disclosureIndicator
        
        if identifier == DataCellTypes.textCell.rawValue {
            configureTextCell(cell: cell, indexPath: indexPath)
        } else if identifier == DataCellTypes.valueCell.rawValue {
            configureNumberCell(cell: cell, indexPath: indexPath)
        } else if identifier == DataCellTypes.boolCell.rawValue {
            configureBoolCell(cell: cell, indexPath: indexPath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let value = indexPath.row as NSObject
        
        FIRAnalytics.logEvent(withName: Names.editParameterSelectedEvent, parameters: [Names.parameterSelectedKey: value])
        
        guard let nouille = nouille else { return }
        // bool types are edited in place, otherwise segue to changeValueVC
        if nouille.reuseIdentifier(indexPath: indexPath) != DataCellTypes.boolCell.rawValue {
            let controller = storyboard?.instantiateViewController(withIdentifier: "ChangeValueVC") as! ChangeValueVC
            controller.nouille = nouille
            controller.editType = nouille.reuseIdentifier(indexPath: indexPath)
            controller.indexPath = indexPath
            
            show(controller, sender: self)
        }
    }
    
}
