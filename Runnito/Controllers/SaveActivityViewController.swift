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

class SaveActivityViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var noLocationsLabel: UILabel!
    
//    let realm = try! Realm()
    
    
    let date = Date()
    let formaterr = DateFormatter()
    
//    var locationsList: [CLLocation] = []
//    var duration = 0
//    var distance = 0.0
//    var pickedActivity = ActivitiesEnum(rawValue: 0)
    var activity: NewActivity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setUI()
        
        if let activity = activity {
            drawRoute(locations: activity.locationsList, noLocationsLabel: noLocationsLabel, mapView: mapView)
        }
    }
    
    // MARK: UI methods
    
    func setUI() {
        formaterr.dateFormat = "dd.MM.yyyy"
        
        if let activity = activity {
            timeLabel.text = secondsToHoursAndMinutes(seconds: activity.duration)
            let dist = String(format: "%.0f", ceil(activity.distance))
            distanceLabel.text = "\(dist) meters"
        }
        dateLabel.text = formaterr.string(from: date)
        noLocationsLabel.isHidden = true
    }
    
    
    
    // MARK: Map methods
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor(hexString: "F25652")
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    // MARK: Saving data
    
    @IBAction func saveButtonPressed(_ sender: Any) {
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
            
            let postObject = [
                "distance": activity.distance,
                "duration": activity.duration,
                "timeStamp": [".sv":"timestamp"], //server time
                "activityType": activity.pickedActivity.description,
                "latitudes": latAray,
                "longitudes": longArray,
                "activityTimestamps": timeStampArray
                ] as [String:Any]
            
            
            activitiesRef.setValue(postObject) { (error, reference) in
                if error == nil {
                    print("🌈 success")
                    self.navigationController?.popToRootViewController(animated: true)
                } else {
                    self.errorAlert(message: "\(error?.localizedDescription)")
                }
            }
        }
    }
    
}

extension UIViewController {
    
    func drawRoute(locations: [CLLocation], noLocationsLabel: UILabel, mapView: MKMapView) {
        
        if locations.count < 2 {
            noLocationsLabel.isHidden = false
        } else {

            for i in 0 ..< locations.count-1 {

                let sourceLocation = CLLocationCoordinate2D(latitude: locations[i].coordinate.latitude, longitude: locations[i].coordinate.longitude)
                let destinationLocation = CLLocationCoordinate2D(latitude: locations[i+1].coordinate.latitude, longitude: locations[i+1].coordinate.longitude)


                let sourcePlacemark = MKPlacemark(coordinate: sourceLocation)
                let destinationPlacemark = MKPlacemark(coordinate: destinationLocation)

                let directionRequest = MKDirections.Request()

                directionRequest.source = MKMapItem(placemark: sourcePlacemark)
                directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
                directionRequest.transportType = .walking

                let directions = MKDirections(request: directionRequest)

                directions.calculate { (response, error) in
                    guard let directionResponse = response else {
                        if let err = error {
                            print("error getting directions in draw route: \(err.localizedDescription)")
                        }
                        return
                    }
                    let route = directionResponse.routes[0]
                    mapView.addOverlay(route.polyline, level: .aboveRoads)

                    let center = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
                    mapView.region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
                }
            }
        }
        
    }
    
}


