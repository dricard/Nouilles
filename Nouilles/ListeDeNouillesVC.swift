//
//  ListeDeNouillesVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class ListeDeNouillesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Nouille", forIndexPath: indexPath)
        
        cell.textLabel?.text = "Tortiglioni"
        if let detail = cell.detailTextLabel {
            detail.text = "8 minutes"
        }
        return cell
    }
    
}
