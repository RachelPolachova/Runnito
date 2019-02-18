//
//  UIViewControllerExtension.swift
//  Runnito
//
//  Created by Ráchel Polachová on 18/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

extension UIViewController {
    
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
    
    func errorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: "We are sorry, \(message)", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okButton)
        present(alertController, animated: true, completion: nil)
    }
    
}
