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
    
    /**
     display only area of the activity
     */
    func mapRegion(locations: [CLLocation]) -> MKCoordinateRegion? {
        
        guard
            locations.count > 0
            else {
                return nil
        }
        
        let latitudes = locations.map { location -> Double in
            return location.coordinate.latitude
        }
        
        let longitudes = locations.map { location -> Double in
            return location.coordinate.longitude
        }
        
        let maxLat = latitudes.max()!
        let minLat = latitudes.min()!
        let maxLong = longitudes.max()!
        let minLong = longitudes.min()!
        
        let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2,
                                            longitude: (minLong + maxLong) / 2)
        let span = MKCoordinateSpan(latitudeDelta: (maxLat - minLat) * 1.3,
                                    longitudeDelta: (maxLong - minLong) * 1.3)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    
    /**
     returns MKPolyline with all locations
     */
    func polyLine(locations: [CLLocation]) -> MKPolyline {
        
        let coords: [CLLocationCoordinate2D] = locations.map { location in
            return CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
        return MKPolyline(coordinates: coords, count: coords.count)
    }
    
}
