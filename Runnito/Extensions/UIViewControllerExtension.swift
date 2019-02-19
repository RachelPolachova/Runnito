//
//  UIViewControllerExtension.swift
//  Runnito
//
//  Created by Ráchel Polachová on 18/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

extension UIViewController {
    
    //    MARK: - Time conversion methods
    
    func convertDateFromFirebaseTimestamp(timestamp: Double) -> String {
        
        let converted = NSDate(timeIntervalSince1970: timestamp / 1000)
        
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.local
        dateFormatter.locale = Locale(identifier: "en_GB")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMd, hh:mm")
        let time = dateFormatter.string(from: converted as Date)
        
        return time
    }
    
    func secondsToHoursAndMinutes(seconds: Int) -> String {
        var h = "00"
        var m = "00"
        var s = "00"
        
        h = isLoverThanTen(conversion: seconds/3600)
        m = isLoverThanTen(conversion: (seconds%3600)/60)
        s = isLoverThanTen(conversion: seconds%60)
        
        return "\(h):\(m):\(s)"
    }
    
    func isLoverThanTen(conversion: Int) -> String {
        if conversion < 10 {
            return "0\(conversion)"
        }
        return "\(conversion)"
    }
    
    //    MARK: - Error alert methods
    
    func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: "We are sorry, \(message)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
    //    MARK: - Keyboard methods
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //    MARK: - Map methods
    
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
