//
//  ActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 07/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ActivityViewController: UIViewController {

    @IBOutlet weak var chooseActivityButton: UIButton!
    @IBOutlet weak var notifierButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    
    var pickedActivity = ActivitiesEnum(rawValue: 0)
    var notifierValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func chooseActivityButtonPressed(_ sender: Any) {
        
        
        
    }
    @IBAction func notifierButtonPressed(_ sender: Any) {
        
        
        
    }
    
    func goToPopup(isItActivity: Bool) {
        
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        
        print("start button pressed: notifier: \(notifierValue), picked activity: \(pickedActivity?.description)")
        
        performSegue(withIdentifier: "toNewActivityVCSegue", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toChooseActivitySegue" {
            let popup = segue.destination as! PopupActivityPopupViewController
            popup.delegate = self
            popup.activity = true
        }

        if segue.identifier == "toNotifierSegue" {
            let popup = segue.destination as! PopupActivityPopupViewController
            popup.delegate = self
            popup.activity = false
        }
        
        if segue.identifier == "toNewActivityVCSegue" {
            let startVC = segue.destination as! NewActivityViewController
            startVC.pickedActivity = pickedActivity
            startVC.notifierValue = notifierValue
            
        }
        
        
    }
    
    func setUI() {
        chooseActivityButton.layer.cornerRadius = 0
        chooseActivityButton.layer.borderWidth = 1
        chooseActivityButton.layer.borderColor = UIColor(hexString: "F25652").cgColor
        
        notifierButton.layer.cornerRadius = 0
        notifierButton.layer.borderWidth = 1
        notifierButton.layer.borderColor = UIColor(hexString: "F25652").cgColor
        
        startButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        startButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        startButton.layer.shadowOpacity = 1

    }
    
}

extension ActivityViewController: PopupDelegate {
    
    
    func popupValueSelected(value: Int) {
        notifierValue = value
        notifierButton.setTitle(String(value), for: .normal)
    }
    
    func popupValueSelected(value: ActivitiesEnum) {
        pickedActivity = value
        chooseActivityButton.setTitle(value.description, for: .normal
        )
    }
    
//    func popupValueSelected(value: String, isActivity: Bool) {
//        if (isActivity) {
//            choosedActivity = value
//            chooseActivityButton.setTitle(value, for: .normal)
//        } else {
//            notifierValue = Int(value)!
//            notifierButton.setTitle(value, for: .normal)
//        }
    }

