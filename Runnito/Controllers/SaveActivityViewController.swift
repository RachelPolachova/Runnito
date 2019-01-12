//
//  SaveActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 04/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import CoreLocation
import RealmSwift
import MapKit

class SaveActivityViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var noLocationsLabel: UILabel!
    
    let realm = try! Realm()
    
    
    let date = Date()
    let formaterr = DateFormatter()
    
    var locationsList: [CLLocation] = []
    var duration = 0
    var distance = 0.0
    var pickedActivity = ActivitiesEnum(rawValue: 0)
    
    var testingLocations: [CLLocation] = [CLLocation(latitude: 49.195061, longitude: 16.606836), CLLocation(latitude: 50.075539, longitude: 14.437800), CLLocation(latitude: 49.948250, longitude: 15.267970)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        setUI()
        
        drawRoute(locations: locationsList, noLocationsLabel: noLocationsLabel, mapView: mapView)
        
//        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        
        
    }
    
    // MARK: UI methods
    
    func setUI() {
        formaterr.dateFormat = "dd.MM.yyyy"
        
        timeLabel.text = secondsToHoursAndMinutes(seconds: duration)
        dateLabel.text = "\(formaterr.string(from: date))"
        distanceLabel.text = "\(distance)"
        
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
        
        do {
            try realm.write {
                let newRun = Run()
                newRun.distance = distance
                newRun.duration = duration
                newRun.timeStamp = Date()
                newRun.activityType = pickedActivity!.description
                
                for location in locationsList {
                    let newLocation = Location()
                    newLocation.latitude = Double(location.coordinate.latitude)
                    newLocation.longitude = Double(location.coordinate.longitude)
                    newLocation.timeStamp = location.timestamp
                    newRun.locations.append(newLocation)
                }
                realm.add(newRun)
                savedSuccessfuly()
            }
        } catch {
            print("Error during saving run. \(error.localizedDescription)")
            savingError()
        }
        
    }

    func savedSuccessfuly() {
        let alertController = UIAlertController(title: "OK", message: "Activity was successfuly saved.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let activityVC = self.storyboard?.instantiateInitialViewController()
            self.present(activityVC!, animated: true, completion: nil)
        }
        
        alertController.addAction(okButton)
        present(alertController,animated: true, completion: nil)
        
    }
    
    func savingError() {
        let alertController = UIAlertController(title: "Error", message: "Please try save your activity again.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func drawRoute(locations: [CLLocation], noLocationsLabel: UILabel, mapView: MKMapView) {
        
//        let locations = locationsList
        
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
                directionRequest.transportType = .automobile
                
                let directions = MKDirections(request: directionRequest)
                
                directions.calculate { (response, error) in
                    guard let directionResponse = response else {
                        if let err = error {
                            print("error getting directions: \(err.localizedDescription)")
                        }
                        return
                    }
                    
                    print("printing : \(i). location: long \(locations[i].coordinate.longitude) lat \(locations[i].coordinate.latitude)")
                    
                    let route = directionResponse.routes[0]
                    mapView.addOverlay(route.polyline, level: .aboveRoads)
                    
                    let rect = route.polyline.boundingMapRect
                    mapView.setRegion(MKCoordinateRegion(rect), animated: true)
                    
                }
            }
        }
        
        
    }
    
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}


