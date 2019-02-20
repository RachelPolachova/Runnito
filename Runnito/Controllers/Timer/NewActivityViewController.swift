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

class NewActivityViewController: BaseViewController {
    
    var container: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.RunnitoColors.darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var timeLabel: TimeLabel = {
        let label = TimeLabel()
        label.text = "00:00:00"
        return label
    }()
    
    var doneButton: SubmitUIButton = {
        let button = SubmitUIButton()
        button.setTitle("DONE", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = label.font.withSize(25)
        label.textColor = UIColor.RunnitoColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var distanceUnitsLabel: UnitsLabel = {
        let label = UnitsLabel()
        label.text = "meters"
        return label
    }()
    
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
        
        view.addSubview(container)
        view.addSubview(timeLabel)
        view.addSubview(doneButton)
        view.addSubview(distanceLabel)
        view.addSubview(distanceUnitsLabel)
        
        setupLayout()
        setupLocationManager()
        start()
        
        // observers if app goes to background / will enter foreground so time difference can be calculated
        NotificationCenter.default.addObserver(self, selector: #selector(pauseWhenBackground(noti:)), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(noti:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        
        doneButton.addTarget(self, action: #selector(doneButtonPressed(_:)), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: UI methods
    
    func setupLayout() {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height

        container.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        container.heightAnchor.constraint(equalToConstant: height * 0.70).isActive = true
        container.layer.cornerRadius = 15
        
        timeLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 50).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 25).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        distanceUnitsLabel.topAnchor.constraint(equalTo: distanceLabel.bottomAnchor, constant: 5).isActive = true
        distanceUnitsLabel.leadingAnchor.constraint(equalTo: distanceLabel.leadingAnchor).isActive = true
        distanceUnitsLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        doneButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
    }
    
    override func enableDarkMode() {
        super.enableDarkMode()
        container.backgroundColor = UIColor.RunnitoColors.darkGray
        distanceLabel.textColor = UIColor.RunnitoColors.white
        distanceUnitsLabel.textColor = UIColor.RunnitoColors.white
        doneButton.setTitleColor(UIColor.RunnitoColors.white, for: .normal)
    }
    
    override func disableDarkMode() {
        super.disableDarkMode()
        container.backgroundColor = UIColor.RunnitoColors.lightBlue
        distanceLabel.textColor = UIColor.RunnitoColors.darkGray
        distanceUnitsLabel.textColor = UIColor.RunnitoColors.darkGray
        doneButton.setTitleColor(UIColor.RunnitoColors.darkGray, for: .normal)
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
    // MARK: Timer methods
    
    func start() {
        print("⭐️ started with distance: \(distance.value)")
        print("⭐️ started with locations: \(locationsList.count)")
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
    
    @objc func doneButtonPressed(_ sender: SubmitUIButton) {
        
        let alertController = UIAlertController(title: "Done.", message: "Are you sure you are done?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            self.timer.invalidate()
//            self.performSegue(withIdentifier: "saveActivitySegue", sender: nil)
            
            let saveActivityVC = SaveActivityViewController()
            let activity = NewActivity(duration: self.seconds, distance: self.distance.value, locationsList: self.locationsList, pickedActivity: self.pickedActivity ?? ActivitiesEnum(rawValue: 0)!)
            saveActivityVC.activity = activity
            self.navigationController?.pushViewController(saveActivityVC, animated: true)
            self.seconds = 0
            self.distance = Measurement(value: 0, unit: UnitLength.meters)
            self.timeLabel.text = self.secondsToHoursAndMinutes(seconds: self.seconds)
            self.locationManager.stopUpdatingLocation()
            
        }
        
        let noAction = UIAlertAction(title: "No", style: .default)
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
}

//  MARK: Location manager

extension NewActivityViewController: CLLocationManagerDelegate {
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.activityType = .fitness
        locationManager.distanceFilter = 10
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
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

