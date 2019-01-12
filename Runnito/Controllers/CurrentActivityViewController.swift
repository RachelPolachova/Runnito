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
    var locations: [CLLocation] = []
    
//    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        setUI()
        
        if selectedActivity != nil {
            drawRoute(locations: getArrayOfLocations(), noLocationsLabel: noLocationsLabel, mapView: mapView)
        }

        // Do any additional setup after loading the view.
    }
    
    func getArrayOfLocations() -> [CLLocation] {
        if let activity = selectedActivity {
            for location in activity.locations {
                locations.append(CLLocation(latitude: location.latitude, longitude: location.longitude))
            }
        }
        return locations
    }
    
    func setUI() {
        
        noLocationsLabel.isHidden = true
        
        if let activity = selectedActivity {
            let formaterr = DateFormatter()
            formaterr.dateFormat = "dd MMM yyyy"
            
            timeLabel.text = secondsToHoursAndMinutes(seconds: activity.duration)
            distanceLabel.text = String(activity.distance)
            dateLabel.text = formaterr.string(from: activity.timeStamp)
            
        }
        
    }
    

}

extension CurrentActivityViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(hexString: "F25652")
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
