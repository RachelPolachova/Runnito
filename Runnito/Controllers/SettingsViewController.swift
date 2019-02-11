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
        logOutButton.addTarget(self, action: #selector(logoutHandler), for: .touchUpInside)
        setupLayout()
    }
    
    func setupLayout() {
        logOutButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    @objc func logoutHandler() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            print("Error sign out: \(err.localizedDescription)")
        }
        self.dismiss(animated: true, completion: nil)
        
    }

}
