//
//  ChooseActivityPopupViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 08/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class PopupActivityPopupViewController: UIViewController {

    @IBOutlet weak var activitiesPickerView: UIPickerView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var everyLabel: UILabel!
    @IBOutlet weak var timeNotifierLabel: UILabel!
    @IBOutlet weak var valueField: UITextField!
    
    let activities = ["Running","Walking","Cycling","Hiking"]
    var pickedActivity = ""
    
    var activity = true
    var delegate: PopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    
    @IBAction func okButtonPressed(_ sender: Any) {
        
        if (activity) {
            
            delegate?.popupValueSelected(value: pickedActivity, isActivity: true)
            dismiss(animated: true, completion: nil)
            
        } else {
            
            if let minutes = valueField.text {
                
                if Int(minutes) != nil {
                    
                    delegate?.popupValueSelected(value: minutes, isActivity: false)
                    dismiss(animated: true, completion: nil)
                    
                } else if minutes == "" {
                    
                    delegate?.popupValueSelected(value: "0", isActivity: false)
                    dismiss(animated: true, completion: nil)
                    
                } else {
                    
                    let alert = UIAlertController(title: "Please insert smaller number", message: "Insert number smaller than \(Int.max)", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(okButton)
                        present(alert,animated: true)
                    
                }
                
                }
            }
        }
    
    func setupUI() {
        if (activity) {
            everyLabel.isHidden = true
            timeNotifierLabel.isHidden = true
            valueField.isHidden = true
            
            activitiesPickerView.delegate = self
            activitiesPickerView.dataSource = self
        } else {
            activitiesPickerView.isHidden = true
            titleLabel.text = "Notifier"
        }
    }
    
}

// MARK: Extensions

extension PopupActivityPopupViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return activities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return activities[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedActivity = activities[row]
    }
}

extension PopupActivityPopupViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
}
