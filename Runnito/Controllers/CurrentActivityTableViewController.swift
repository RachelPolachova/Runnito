//
//  CurrentActivityTableViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentActivityTableViewController: UITableViewController {
    
    var selectedActivity: ActivitiesEnum?
    
    let realm = try! Realm()
    
//    var allActivities = List<Run>()
    
    var activitiesList: Run?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        allActivities = realm.objects(Run)
        

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }
    
    func loadData() {
        
        
        
    }


}
