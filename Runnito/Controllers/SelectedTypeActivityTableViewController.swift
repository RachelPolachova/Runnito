//
//  CurrentActivityTableViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import RealmSwift

class SelectedTypeActivityTableViewController: UITableViewController {
    
    var selectedTypeOfActivity: ActivitiesEnum?
    var selectedActivity: Run?
    
    let realm = try! Realm()
    var allActivities: Results<Run>?

    
    var selectedActivitiesList: [Run] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        allActivities = realm.objects(Run.self)
      
        
        loadData()
        print("count after load: \(selectedActivitiesList.count)")

        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return selectedActivitiesList.count

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedTypeActivityTableViewCell", for: indexPath) as! SelectedTypeActivityTableViewCell
        
        let activity = selectedActivitiesList[indexPath.row]
        let formaterr = DateFormatter()
        formaterr.dateFormat = "dd MMM yyyy"
        
        cell.timeLabel.text = secondsToHoursAndMinutes(seconds: activity.duration)
        cell.dateLabel.text = formaterr.string(from: activity.timeStamp)
        cell.distanceLabel.text = String(format: "%.0f", ceil(activity.distance))
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedActivity = selectedActivitiesList[indexPath.row]
        performSegue(withIdentifier: "goToCurrentActivity", sender: nil)
    }
    
    
    // MARK: Realm methods
    
    func loadData() {
        
        
        if let list = allActivities {
            for activity in list {
                if activity.activityType == selectedTypeOfActivity?.description {
                    print("if in for true for type: \(activity.activityType)")
                    
                    selectedActivitiesList.append(activity)
                    
                }
            }
        }
        
    }
    
    // MARK: Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CurrentActivityViewController
        destinationVC.selectedActivity = selectedActivity
    }


}
