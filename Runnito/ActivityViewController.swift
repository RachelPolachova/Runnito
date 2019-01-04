//
//  RunViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 04/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    var seconds = 0;
    var timer = Timer();
    var timerIsOn = false;
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.isHidden = false
        cancelButton.isHidden = true
        doneButton.isHidden = true

    }
    

    @IBAction func startButtonPressed(_ sender: UIButton) {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        timerIsOn = true
        reverseButtons()
        
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Cancel the activity", message: "Are you sure?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .destructive) { (UIAlertAction) in
            self.timer.invalidate()
            self.seconds = 0
            self.timeLabel.text = self.secondsToHoursAndMinutes(seconds: self.seconds)
            self.reverseButtons()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (UIAlertAction) in
            //bla
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController,animated: true,completion: nil)
        
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Done.", message: "Are you sure you are done?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            self.timer.invalidate()
            self.performSegue(withIdentifier: "saveActivitySegue", sender: nil)
            self.seconds = 0
            self.timeLabel.text = self.secondsToHoursAndMinutes(seconds: self.seconds)
            self.reverseButtons()
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (UIAlertAction) in
            //bla
        }
        
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        self.present(alertController,animated: true,completion: nil)
    }
    
    @objc func updateTimer() {
        
        seconds += 1;
        timeLabel.text = secondsToHoursAndMinutes(seconds: seconds)
        
    }
    
    
    
    //SEGUE
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let saveController = segue.destination as! SaveActivityViewController
        saveController.sec = seconds
    }
    
    //REVERSE BUTTONS
    func reverseButtons() {
        startButton.isHidden = !startButton.isHidden
        doneButton.isHidden = !doneButton.isHidden
        cancelButton.isHidden = !cancelButton.isHidden
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
