//
//  ListeDeNouillesVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-08-22.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

class ListeDeNouillesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - Properties
    
    let nouilles = Nouilles.sharedInstance()
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nouilles.listeDeNouilles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Nouille", forIndexPath: indexPath)
        
        cell.textLabel?.text = nouilles.listeDeNouilles[indexPath.row].name
        if let detail = cell.detailTextLabel {
            detail.text = "\(nouilles.listeDeNouilles[indexPath.row].time)"
        }
        return cell
    }
    
}
