//
//  CurrentActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 12/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import MapKit
import RealmSwift

class CurrentActivityViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var noLocationsLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedActivity: Run?
    
//    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let activity = selectedActivity {
            let formaterr = DateFormatter()
            formaterr.dateFormat = "dd MMM yyyy"
            
            timeLabel.text = secondsToHoursAndMinutes(seconds: activity.duration)
            distanceLabel.text = String(activity.distance)
            dateLabel.text = formaterr.string(from: activity.timeStamp)
            
        }

        // Do any additional setup after loading the view.
    }
    

}
