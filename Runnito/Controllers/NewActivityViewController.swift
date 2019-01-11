//
//  RunViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 04/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class NewActivityViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    var run: Run?
    var seconds = 0;
    var timer = Timer();
    var timerIsOn = false;
    
    let locationManager = CLLocationManager()
    var locationsList: [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    var notfifierValue = 0
    var pickedActivity = ActivitiesEnum(rawValue: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("notifier: \(notfifierValue), picked activity: \(pickedActivity?.description)")
        
        setUI()
        
        setupLocationManager()
        
        start()
        
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            
            timer.invalidate()
            seconds = 0
            locationManager.stopUpdatingLocation()
            
        }
    }
    
    
    // MARK: Timer
    
    @objc func pauseWhenBackground(noti: Notification) {
        
        
        timer.invalidate()
        timerIsOn = false
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
        print(Date())
        
    }
    
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            print("Seconds before difference: \(seconds)")
            let diffS = getTimeDifference(startDate: savedDate)
            seconds += diffS
            print("Seconds after difference: \(seconds)")
            timeLabel.text = secondsToHoursAndMinutes(seconds: seconds)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            timerIsOn = true
        }
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        locationManager.startUpdatingLocation()
        print("Location updating started")
        
    }
    
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Done.", message: "Are you sure you are done?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            self.timer.invalidate()
            self.performSegue(withIdentifier: "saveActivitySegue", sender: nil)
            self.seconds = 0
            self.timeLabel.text = self.secondsToHoursAndMinutes(seconds: self.seconds)
            self.locationManager.stopUpdatingLocation()
        
        }
        
        let noAction = UIAlertAction(title: "No", style: .default)
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    @objc func updateTimer() {
        
        seconds += 1;
        timeLabel.text = secondsToHoursAndMinutes(seconds: seconds)
        distanceLabel.text = "\(distance)"
        
        
        if (seconds%(notfifierValue*60) == 0) {
            notifier(seconds: seconds)
        }
        
    }
    
    func notifier(seconds: Int) {
        
        var time = ""
        
        if seconds >= 3600 {
            let h = String(seconds/3600)
            let m = String((seconds%3600)/60)
            let s = seconds%60
            
            time = "\(h) hours, \(m) minutes and \(s) seconds."
        } else if seconds >= 60 && seconds < 3600 {
            let m = seconds/60
            let s = seconds%60
            
            time = "\(m) minutes and \(s) seconds."
        } else {
            time = "\(seconds) seconds."
        }
        
        let string = "You are \(pickedActivity!.description) for " + time
        
        let utterance = AVSpeechUtterance(string: string)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")

        
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
    }
    
    func getTimeDifference(startDate: Date) -> Int {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.hour,.minute,.second])
        print(Date())
        let components = calendar.dateComponents(unitFlags, from: startDate, to: Date())
        
        let s = components.hour!*3600 + components.minute!*60 + components.second!
        
        return s
    }
    
    // MARK: Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let saveController = segue.destination as! SaveActivityViewController
        saveController.duration = seconds
        saveController.distance = distance.value
        saveController.locationsList = locationsList
        saveController.pickedActivity = pickedActivity
    }
    
    // MARK: UI methods
    
    func setUI() {
        paceLabel.text = "0"
        distanceLabel.text = "\(distance)"
    }
    
}

// MARK : Location manager

extension NewActivityViewController: CLLocationManagerDelegate {
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for newLocation in locations {
            print("I'm in for")
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else { continue }
            
            if let lastLocation = locationsList.last {
                let delta = newLocation.distance(from: lastLocation)
                distance = distance + Measurement(value: delta, unit: UnitLength.meters)
                print("Distance: \(distance)")
            }
            locationsList.append(newLocation)
            print("New location added: \(newLocation)")
        }
        
    }
    
}



//CONVERSION

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
}
