//
//  CurrentActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 12/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import MapKit

class CurrentActivityViewController: UIViewController {
    
//    @IBOutlet weak var dateLabel: UILabel!
//    @IBOutlet weak var timeLabel: UILabel!
//    @IBOutlet weak var distanceLabel: UILabel!
//    @IBOutlet weak var noLocationsLabel: UILabel!
//    @IBOutlet weak var mapView: MKMapView!
    
    var timeLabel = TimeLabel()
    var dateLabel: UnitsLabel = {
        let label = UnitsLabel()
        label.textAlignment = .center
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.RunnitoColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var distanceUnitsLabel: UnitsLabel = {
        let label = UnitsLabel()
        label.textAlignment = .center
        label.text = "meters"
        return label
    }()
    
    var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    var noLocationsLabel: UILabel = {
        let label = UILabel()
        label.text = "No locations"
        label.textColor = UIColor.RunnitoColors.white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var selectedActivity: Activity?
    var locations: [CLLocation] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        view.addSubview(dateLabel)
        view.addSubview(timeLabel)
        view.addSubview(distanceLabel)
        view.addSubview(distanceUnitsLabel)
        view.addSubview(noLocationsLabel)
        view.addSubview(mapView)
        
        setUI()
        setupLayout()
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
            distanceLabel.text = String(format: "%.0f", ceil(activity.distance))
            dateLabel.text = self.convertDateFromFirebaseTimestamp(timestamp: activity.timestamp)
        }
        
        self.view.backgroundColor = UIColor.RunnitoColors.darkGray
        
        
        noLocationsLabel.isHidden = false
        
    }
    
    func setupLayout() {
        
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
        dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        dateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 25).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        distanceUnitsLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 5).isActive = true
        distanceUnitsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        distanceUnitsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: height / 2).isActive = true
        
        noLocationsLabel.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -10).isActive = true
        noLocationsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        noLocationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
        renderer.strokeColor = UIColor.RunnitoColors.red
        renderer.lineWidth = 4.0
        return renderer
    }
    
}
