//
//  NewViewController.swift
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
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    
    var seconds = 0;
    var timer = Timer();
    
    let locationManager = CLLocationManager()
    var locationsList: [CLLocation] = []
    var distance = Measurement(value: 0, unit: UnitLength.meters)
    
    var notifierValue = 0
    var pickedActivity = ActivitiesEnum(rawValue: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // authorization on the beginning 
        let utterance = AVSpeechUtterance(string: " ")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        let synth = AVSpeechSynthesizer()
        synth.speak(utterance)
        
        setUI()
        setupLocationManager()
        start()
        
        // observers if app goes to background / will enter foreground so time difference can be calculated
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
    }
    
    // MARK: UI methods
    
    func setUI() {
        paceLabel.text = "0"
        distanceLabel.text = "\(distance)"
    }
    
    // MARK: Timer methods
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        locationManager.startUpdatingLocation()
    }
    
    @objc func updateTimer() {

        seconds += 1;
        timeLabel.text = secondsToHoursAndMinutes(seconds: seconds)
        distanceLabel.text = "\(distance)"
        distanceLabel.text = String(format: "%.0f", ceil(distance.value))
        
        
        if notifierValue != 0 {
            if (seconds%(notifierValue*60) == 0) {
                notifier(seconds: seconds)
            }
        }
    }
    
    
/**
     Speech synthesis voice reading time of activity
     - Parameters:
        - seconds: time of activity in secods
     
 */
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
    
/**
     If user goes back, timer will be invalidated and values resetted
*/
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil {
            timer.invalidate()
            seconds = 0
            locationManager.stopUpdatingLocation()
            print("did move called")
        }
    }
    
/**
     Saves current time to UserDefaults when user goes to background
     - Parameters:
        - noti: Notification center in viewDidLoad with observer
 */
    @objc func pauseWhenBackground(noti: Notification) {
        timer.invalidate()
        let shared = UserDefaults.standard
        shared.set(Date(), forKey: "savedTime")
        print(Date())
    }
    
    
/**
     Updates timer to correct time after entering foreground again
     - Parameters:
        - noti: Notification center in viewDidLoad with observer
 */
    @objc func willEnterForeground(noti: Notification) {
        if let savedDate = UserDefaults.standard.object(forKey: "savedTime") as? Date {
            let diffS = getTimeDifference(startDate: savedDate)
            seconds += diffS
            timeLabel.text = secondsToHoursAndMinutes(seconds: seconds)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        }
    }
    
/**
     Calculates difference between startDate and current time
     
    - Parameters:
        - startDate: since when
     - Returns:
        difference in seconds
*/
    func getTimeDifference(startDate: Date) -> Int {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.hour,.minute,.second])
        print(Date())
        let components = calendar.dateComponents(unitFlags, from: startDate, to: Date())
        
        let s = components.hour!*3600 + components.minute!*60 + components.second!
        
        return s
    }
    
    
    //    MARK: Finishing activity methods
    
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
    
    // MARK: Segue methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let saveController = segue.destination as! SaveActivityViewController
        let activity = NewActivity(duration: seconds, distance: distance.value, locationsList: locationsList, pickedActivity: pickedActivity ?? ActivitiesEnum(rawValue: 0)!)
        saveController.activity = activity
//        saveController.duration = seconds
//        saveController.distance = distance.value
//        saveController.locationsList = locationsList
//        saveController.pickedActivity = pickedActivity
    }
    
}

//  MARK: Location manager

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

