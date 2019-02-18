//
//  LoginViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var mailTextField : LoginUITextField = {
        let textField = LoginUITextField()
        textField.setIcon(UIImage(named: "user")!)
        textField.placeholder = "Your e-mail"
        return textField
    }()
    
    var passwordTextField : LoginUITextField = {
        let textField = LoginUITextField()
        textField.setIcon(UIImage(named: "key")!)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    var loginButton : SubmitUIButton = {
        let button = SubmitUIButton()
        button.setTitle("Login", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        setupLayout()
        
        loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        mailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        setLoginButton(enabled: false)
    }
    
    func setupLayout() {
        mailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        mailTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 25).isActive = true
        passwordTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    

    @objc func textFieldChanged() {
        let mail = mailTextField.text
        let password = passwordTextField.text
        
        let formFilled = mail != nil && password != nil
        setLoginButton(enabled: formFilled)
    }
    
    func setLoginButton(enabled: Bool) {
        if enabled {
            loginButton.alpha = 1.0
            loginButton.isEnabled = true
        } else {
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        }
    }
    
    @objc func handleLogin() {
        guard let mail = mailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        setLoginButton(enabled: false)
        
        Auth.auth().signIn(withEmail: mail, password: password) { (user, error) in
            if let err = error {
                self.errorAlert(message: err.localizedDescription)
            } else {
                print("Logged in.")
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }

}
