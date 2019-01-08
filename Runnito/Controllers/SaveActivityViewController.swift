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

class SaveActivityViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    
    let activities = ["Running", "Cycling", "Skiing", "Roller skating", "Walking"]

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var selectedActivity: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    let realm = try! Realm()
    
    
    let date = Date()
    let formaterr = DateFormatter()
    
    var locationsList: [CLLocation] = []
    var duration = 0
    var distance = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        formaterr.dateFormat = "dd.MM.yyyy"
        
        timeLabel.text = secondsToHoursAndMinutes(seconds: duration)
        dateLabel.text = "\(formaterr.string(from: date))"
        distanceLabel.text = "\(distance)"
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        do {
            try realm.write {
                let newRun = Run()
                newRun.distance = distance
                newRun.duration = duration
                newRun.timeStamp = Date()
                
                newRun.activityType = selectedActivity.text!
                
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
            print("Error during saving run.")
            savingError()
        }
        
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedActivity.text = activities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let atributedString = NSAttributedString(string: activities[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor(hexString: "#3D414C")])
        return atributedString
    }

    func savedSuccessfuly() {
        let alertController = UIAlertController(title: "OK", message: "Activity was successfuly saved.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
            let activityVC = self.storyboard?.instantiateViewController(withIdentifier: "activityVC") as! ActivityViewController
            self.present(activityVC, animated: true, completion: nil)
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
