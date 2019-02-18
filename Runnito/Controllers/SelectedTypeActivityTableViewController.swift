//
//  CurrentActivityTableViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import Firebase

class SelectedTypeActivityTableViewController: UITableViewController {
    
    var selectedTypeOfActivity: ActivitiesEnum?
    var selectedActivity: Activity?
    var activities = [Activity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeActivities()
        
    }
    
    //    MARK: - Firebase methods
    
    func observeActivities() {
        
        if let uid = Auth.auth().currentUser?.uid {
            let activitiesRef = Database.database().reference().child("users/profile/\(uid)/activities/\(selectedTypeOfActivity!.description)")
            
            activitiesRef.observe(.value) { (snapshot) in
                
                var tempActivities = [Activity]()
                
                for child in snapshot.children {
                    if let childSnapshot = child as? DataSnapshot,
                        let dict = childSnapshot.value as? [String:Any],
                        let activityType = dict["activityType"] as? String,
                        let duration = dict["duration"] as? Int,
                        let distance = dict["distance"] as? Double,
                        let timestamp = dict["timeStamp"] as? Double {
                        
                        // some activities may not have any locations
                        if let latitudes = dict["latitudes"] as? [Double],
                            let longitudes = dict["longitudes"] as? [Double],
                            let activityTimeStamps = dict["activityTimestamps"] as? [String] {
                            let activity = Activity(key: childSnapshot.key,timestamp: timestamp, distance: distance, duration: duration, latitudes: latitudes, longitudes: longitudes, activityTimestamps: activityTimeStamps)
                            tempActivities.append(activity)
                        } else {
                            let activity = Activity(key: childSnapshot.key, timestamp: timestamp, distance: distance, duration: duration)
                            tempActivities.append(activity)
                        }
                        
                    } else {
                        self.errorAlert(message: "please try again")
                    }
                }
                self.activities = tempActivities
                self.tableView.reloadData()
            }
        }

    }
    
//    MARK: Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CurrentActivityViewController
        destinationVC.selectedActivity = selectedActivity
    }
}

//  MARK: - Table view methods

extension SelectedTypeActivityTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectedTypeActivityTableViewCell", for: indexPath) as! SelectedTypeActivityTableViewCell

        let activity = activities[indexPath.row]
        cell.distanceLabel.text = String(format: "%.0f", ceil(activity.distance))
        cell.dateLabel.text = String(activity.timestamp)
        cell.timeLabel.text = secondsToHoursAndMinutes(seconds: activity.duration)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedActivity = activities[indexPath.row]
        performSegue(withIdentifier: "goToCurrentActivity", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            deleteActivity(key: activities[indexPath.row].key)
            activities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func deleteActivity(key: String) {
        if let uid = Auth.auth().currentUser?.uid {
            
            let activityRef = Database.database().reference().child("users/profile/\(uid)/activities/\(selectedTypeOfActivity!.description)/\(key)")
            activityRef.removeValue()
        }
    }
    
}
