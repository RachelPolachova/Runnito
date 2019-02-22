//
//  DetailsOfActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 08/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class DetailsOfActivityViewController: BaseViewController {

    var everyLabel: UILabel = {
        let label = UILabel()
        label.text = "Every"
        label.textColor = UIColor.RunnitoColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var timeNotifierLabel: UILabel = {
        let label = UILabel()
        label.text = "minutes"
        label.textColor = UIColor.RunnitoColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var valueField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor.RunnitoColors.darkBlue
        textField.textColor = UIColor.RunnitoColors.white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.cornerRadius = 5
        textField.keyboardType = UIKeyboardType.numberPad
        return textField
    }()
    var activitiesPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    var pickedActivity = ActivitiesEnum(rawValue: 0)!
    
    var activity = true
    var delegate: PopupDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        view.backgroundColor = UIColor.RunnitoColors.darkGray
        view.addSubview(activitiesPickerView)
        view.addSubview(everyLabel)
        view.addSubview(valueField)
        view.addSubview(timeNotifierLabel)
        
        setupUI()
        setupLayout()
        
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = addBarButton

        self.dismissKeyboard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //    MARK: - UI methods
    
    func setupUI() {
        if (activity) {
            // choose activity
            everyLabel.isHidden = true
            timeNotifierLabel.isHidden = true
            valueField.isHidden = true
            self.navigationItem.title = "Activity type"
            
            activitiesPickerView.delegate = self
            activitiesPickerView.dataSource = self
        } else {
            // notifier
            activitiesPickerView.isHidden = true
            self.navigationItem.title = "Notifier"
        }
    }
    
    func setupLayout() {
        
        valueField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        valueField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        valueField.widthAnchor.constraint(equalToConstant: 80).isActive = true
        valueField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        everyLabel.rightAnchor.constraint(equalTo: valueField.leftAnchor, constant: -10).isActive = true
        everyLabel.centerYAnchor.constraint(equalTo: valueField.centerYAnchor).isActive = true
        everyLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        timeNotifierLabel.leftAnchor.constraint(equalTo: valueField.rightAnchor, constant: 10).isActive = true
        timeNotifierLabel.centerYAnchor.constraint(equalTo: valueField.centerYAnchor).isActive = true
        timeNotifierLabel.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        activitiesPickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activitiesPickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func disableDarkMode() {
        super.disableDarkMode()
        everyLabel.textColor = UIColor.RunnitoColors.darkGray
        timeNotifierLabel.textColor = UIColor.RunnitoColors.darkGray
        valueField.textColor = UIColor.RunnitoColors.darkGray
        valueField.backgroundColor = UIColor.RunnitoColors.lightBlue
        activitiesPickerView.reloadAllComponents()
    }
    
    override func enableDarkMode() {
        super.enableDarkMode()
        everyLabel.textColor = UIColor.RunnitoColors.white
        timeNotifierLabel.textColor = UIColor.RunnitoColors.white
        valueField.textColor = UIColor.RunnitoColors.white
        valueField.backgroundColor = UIColor.RunnitoColors.darkGray
        activitiesPickerView.reloadAllComponents()
    }
    
    
    @objc func addButtonPressed(_ sender: UIBarButtonItem) {
        
        if (activity) {
            
            delegate?.popupValueSelected(value: pickedActivity)
            self.navigationController?.popToRootViewController(animated: true)
            
        } else {
            
            if let minutes = valueField.text {
                
                if let value = Int(minutes) {
                    
                    delegate?.popupValueSelected(value: value)
                    self.navigationController?.popToRootViewController(animated: true)
                    
                } else if minutes == "" {
                    
                    delegate?.popupValueSelected(value: 0)
                    self.navigationController?.popToRootViewController(animated: true)
                    
                } else {
                    
                    let alert = UIAlertController(title: "Too big number", message: "Insert number smaller than \(Int.max)", preferredStyle: .alert)
                        let okButton = UIAlertAction(title: "OK", style: .default)
                        alert.addAction(okButton)
                        present(alert,animated: true)
                    
                }
            }
        }
    }
}

// MARK: - UIPickerView delegate methods

extension DetailsOfActivityViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ActivitiesEnum.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ActivitiesEnum(rawValue: row)?.description
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: ActivitiesEnum(rawValue: row)?.description ?? "", attributes: [NSAttributedString.Key.foregroundColor : darkMode ? UIColor.RunnitoColors.white : UIColor.RunnitoColors.darkGray])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let activity = ActivitiesEnum(rawValue: row) {
            pickedActivity = activity
        }
    }
}

// MARK: - UITextFieldDelegate methods

extension DetailsOfActivityViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
    }
}
