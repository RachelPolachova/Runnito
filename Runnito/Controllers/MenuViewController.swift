//
//  MenuViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: UIViewController {

    var loginButton : ChooseUIButton = {
        let button = ChooseUIButton()
        button.setTitle("Login", for: .normal)
        return button
    }()
    var registerButton : ChooseUIButton = {
        let button = ChooseUIButton()
        button.setTitle("Register", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        setupUI()
        
    }
    
    //    MARK: - UI methods
    
    func setupUI() {
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true

        registerButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -25).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
    }
    
    @objc func loginButtonPressed(sender: ChooseUIButton) {
        performSegue(withIdentifier: "goToLoginSegue", sender: self)
    }
    
    @objc func registerButtonPressed(sender: ChooseUIButton) {
        performSegue(withIdentifier: "goToRegisterSegue", sender: self)
    }
    

}
