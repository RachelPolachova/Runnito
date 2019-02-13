//
//  SettingsViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    
    
    var logOutButton : SubmitUIButton = {
        let button = SubmitUIButton()
        button.setTitle("Log out", for: .normal)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.addSubview(logOutButton)
        
        
        logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        
        setupLayout()
        
    }
    
    
    
    func setupLayout() {
        
        
        
        logOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print("Error sign out: \(err.localizedDescription)")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    
}


