//
//  CurrentActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 12/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import MapKit

class CurrentActivityViewController: BaseViewController {
    
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
        view.addSubview(noLocationsLabel)
        view.addSubview(mapView)
        
        setUI()
        setupLayout()
        if selectedActivity != nil {
            drawRoute(locations: getArrayOfLocations(), noLocationsLabel: noLocationsLabel, mapView: mapView)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //    MARK: - UI methods
    
    func setUI() {
        
        noLocationsLabel.isHidden = true
        
        if let activity = selectedActivity {
            let formaterr = DateFormatter()
            formaterr.dateFormat = "dd MMM yyyy"
            
            timeLabel.text = secondsToHoursAndMinutes(seconds: activity.duration)
            distanceLabel.text = String(format: "%.0f", ceil(activity.distance)) + " meters"
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
        
        distanceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.heightAnchor.constraint(equalToConstant: height / 2).isActive = true
        
        noLocationsLabel.bottomAnchor.constraint(equalTo: mapView.topAnchor, constant: -10).isActive = true
        noLocationsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        noLocationsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func enableDarkMode() {
        super.enableDarkMode()
        dateLabel.textColor = UIColor.RunnitoColors.white
        distanceLabel.textColor = UIColor.RunnitoColors.white
        noLocationsLabel.textColor = UIColor.RunnitoColors.white
    }
    
    override func disableDarkMode() {
        super.disableDarkMode()
        dateLabel.textColor = UIColor.RunnitoColors.darkGray
        distanceLabel.textColor = UIColor.RunnitoColors.darkGray
        noLocationsLabel.textColor = UIColor.RunnitoColors.darkGray
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
