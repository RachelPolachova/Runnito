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
    
    var selectedActivity: Activity?
    var locations: [CLLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setUI()
        if selectedActivity != nil {
            drawRoute(locations: getArrayOfLocations(), noLocationsLabel: noLocationsLabel, mapView: mapView)
        }

    }
    
    //    MARK: - UI methods
    
    func setUI() {
        
        noLocationsLabel.isHidden = true
        
        if let activity = selectedActivity {
            let formaterr = DateFormatter()
            formaterr.dateFormat = "dd MMM yyyy"
            
            timeLabel.text = secondsToHoursAndMinutes(seconds: activity.duration)
            distanceLabel.text = String(format: "%.0f", ceil(activity.distance)) + " meters"
            dateLabel.text = String(activity.timestamp)
        }
    }
    
    func getArrayOfLocations() -> [CLLocation] {
        
        var locations = [CLLocation]()
        
        if let activity = selectedActivity {
            if let latitudes = activity.latitudes,
                let longitudes = activity.longitudes {
                for i in 0..<longitudes.count {
                    locations.append(CLLocation(latitude: latitudes[i], longitude: longitudes[i]))
                }
            }
            
        }
        
        return locations
    }
    
    
}

// MARK: - MKMapView delegate methods

extension CurrentActivityViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(hexString: "F25652")
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
