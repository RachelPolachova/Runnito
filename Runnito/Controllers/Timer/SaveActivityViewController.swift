//
//  SaveActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 04/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class SaveActivityViewController: BaseViewController, MKMapViewDelegate {

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
    
    
    var activity: NewActivity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        view.addSubview(dateLabel)
        view.addSubview(timeLabel)
        view.addSubview(distanceLabel)
        view.addSubview(noLocationsLabel)
        view.addSubview(mapView)
        
        setupUI()
        setupLayout()
        
        let saveBarButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed(_:)))
        let cancelBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = saveBarButton
        self.navigationItem.leftBarButtonItem = cancelBarButton
        
        
        if let activity = activity {
            drawRoute(locations: activity.locationsList, noLocationsLabel: noLocationsLabel, mapView: mapView)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UI methods
    
    func setupUI() {
        
        self.view.backgroundColor = UIColor.RunnitoColors.darkGray
        
        let date = Date()
        let formatterr = DateFormatter()
        formatterr.dateFormat = "dd.MM.yyyy"
        
        if let activity = activity {
            timeLabel.text = secondsToHoursAndMinutes(seconds: activity.duration)
            let dist = String(format: "%.0f", ceil(activity.distance))
            distanceLabel.text = "\(dist) meters"
        }
        dateLabel.text = formatterr.string(from: date)
        noLocationsLabel.isHidden = false
    }
    
    func setupLayout() {

        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
        dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
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
    
    // MARK: Map methods
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.RunnitoColors.red
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    // MARK: Saving data
    
    @objc func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func saveButtonPressed(_ sender: UIBarButtonItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var latAray = [Double]()
        var longArray = [Double]()
        var timeStampArray = [String]()
        
        guard let activity = activity else { return }
        
        for location in activity.locationsList {
            latAray.append(Double(location.coordinate.latitude))
            longArray.append(Double(location.coordinate.longitude))
            timeStampArray.append(formatter.string(from: location.timestamp))
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            
            
            let activitiesRef = Database.database().reference().child("users/profile/\(uid)/activities/\(activity.pickedActivity.description)").childByAutoId()
            
            isConnected { (isConnected) in
                if isConnected {
                    print("🌈 Yay, is connected!")
                } else {
                    self.presentErrorAlert(message: "cannot connect to database. Data will be saved when connection will be successful.")
                }
            }
            
            self.navigationController?.popToRootViewController(animated: true)
            
            let postObject = [
                "distance": activity.distance,
                "duration": activity.duration,
                "timeStamp": [".sv":"timestamp"], //server time
                "latitudes": latAray,
                "longitudes": longArray,
                "activityTimestamps": timeStampArray
                ] as [String:Any]
            
            print("🐽 before setvalue!")
            activitiesRef.setValue(postObject) { (error, reference) in
                
                if error == nil {
                    print("🌈 success")
                } else {
                    print("🔥 Cannot save!")
                    self.presentErrorAlert(message: "\(error?.localizedDescription)")
                }
            }
        } else {
            print("🔥 no uid")
            self.presentErrorAlert(message: "something went wrong. Please, try again.")
        }
    }
    
    func isConnected(completionHandler : @escaping (Bool) -> ()) {
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            completionHandler((snapshot.value as? Bool)!)
        })
    }
    
}


