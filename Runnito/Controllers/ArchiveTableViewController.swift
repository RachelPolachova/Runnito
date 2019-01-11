//
//  ArchiveTableViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ArchiveTableViewController: UITableViewController {
    
    var selectedActivity: ActivitiesEnum?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivitiesEnum.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "archiveCell")
        cell.textLabel?.text = ActivitiesEnum(rawValue: indexPath.row)?.description
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedActivity = ActivitiesEnum(rawValue: indexPath.row)
        performSegue(withIdentifier: "goToCurrentActivitySegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let currentActivityVC = segue.destination as! CurrentActivityTableViewController
        currentActivityVC.selectedActivity = selectedActivity
        
    }

}
