//
//  FilterVC.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-12-01.
//  Copyright © 2016 Hexaedre. All rights reserved.
//

import UIKit

/*
    This VC lets the user select sort descriptors and predicates.
    
    It relates to the Filters class and uses a delegate pattern to
    update the list view controller when changes are made to the
    selected filters.
 
    This is a barebones VC, all the logic is in Filters.
 
*/

protocol FilterVCDelegate: class {
    func filterVC(filter: FilterVC)
}

class FilterVC: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: FilterVCDelegate?
    var filters: Filters?
    
    // MARK: - Outlets
    
    @IBOutlet weak var aboutButton: UIBarButtonItem!
    
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Theme related
        view.backgroundColor = NoodlesStyleKit.lighterYellow
        tableView.separatorColor = NoodlesStyleKit.baseGreen
        tableView.backgroundColor = NoodlesStyleKit.mediumYellow

        // localization
        title = .filtersLabel
        aboutButton.title = .aboutButtonLabel
        
        self.clearsSelectionOnViewWillAppear = false
        
        // navigation: replace the default navigation 'back' button to send user's choice
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: .Back, style: .plain, target: self, action: #selector(FilterVC.sendSortOption))
        self.navigationItem.leftBarButtonItem = newBackButton
        
    }
    
    // MARK: - Utilities
    
    func sendSortOption() {
        // this sends the list view a "message" to refilter its list
        delegate?.filterVC(filter: self)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Tableview data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let filters = filters else { return 0 }
        return filters.numberOfSections()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filters = filters else { return 0 }
        return filters.rowsInSection(section: section)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let filters = filters else { return nil }
        return filters.headerTitle(section: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = FilterHeaderView()
        guard let filters = filters else { return nil }
        let title = filters.headerTitle(section: section)
        sectionHeaderView.label.text = title
        return sectionHeaderView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let filters = filters else { fatalError() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortOptionCell", for: indexPath)
        cell.accessoryType = filters.accessoryIndicator(indexPath: indexPath)
        cell.textLabel?.text = filters.title(indexPath: indexPath)
        cell.detailTextLabel?.text = filters.description(indexPath: indexPath)
        cell.backgroundColor = NoodlesStyleKit.lighterYellow
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let filters = filters else { fatalError() }
        filters.setFilters(indexPath: indexPath)
        
        let selected = (indexPath.section * 10 + indexPath.row) as NSObject
        
        tableView.reloadData()
    }
}
