//
//  RegisterViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import Firebase


class RegisterViewController: UIViewController {

    var activityView:UIActivityIndicatorView!
    
    var usernameTextField : LoginUITextField = {
        let textField = LoginUITextField()
        textField.placeholder = "Username"
        textField.setIcon(UIImage(named: "user")!)
        return textField
    }()
    
    var mailTextField : LoginUITextField = {
        let textField = LoginUITextField()
        textField.placeholder = "e-mail"
        textField.setIcon(UIImage(named: "envelope")!)
        return textField
    }()
    
    var passwordTextField : LoginUITextField = {
        let textField = LoginUITextField()
        textField.isSecureTextEntry = true
        textField.setIcon(UIImage(named: "key")!)
        return textField
    }()
    
    var registerButton : SubmitUIButton = {
        let button = SubmitUIButton()
        button.setTitle("Register", for: .normal)
        button.backgroundColor = .blue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(usernameTextField)
        view.addSubview(mailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        
        
        registerButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        usernameTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        mailTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        setRegisterButton(enabled: false)
        
        activityView = UIActivityIndicatorView(style: .gray)
        activityView.color = .red
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = registerButton.center
        view.addSubview(activityView)
        
        
        setLayout()
        
    }
    
    
    @objc func textFieldChanged() {
        let username = usernameTextField.text
        let mail = mailTextField.text
        let password = passwordTextField.text
        
        let formFilled = username != "" && mail != "" && password != ""
        setRegisterButton(enabled: formFilled)
    }
    
    func setLayout() {
        
        usernameTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        mailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 25).isActive = true
        mailTextField.centerXAnchor.constraint(equalTo: usernameTextField.centerXAnchor).isActive = true
        mailTextField.widthAnchor.constraint(equalTo: usernameTextField.widthAnchor)
        
        passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 25).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: mailTextField.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: mailTextField.widthAnchor).isActive = true
        
        registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    func setRegisterButton(enabled: Bool) {
        if enabled {
            registerButton.alpha = 1.0
            registerButton.isEnabled = true
        } else {
            registerButton.alpha = 0.5
            registerButton.isEnabled = false
        }
    }
    
    @objc func handleRegistration() {
        guard let username = usernameTextField.text else { return }
        guard let mail = mailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        //cannot "register for multiple times"
        setRegisterButton(enabled: false)
        registerButton.setTitle("", for: .normal)
        
        Auth.auth().createUser(withEmail: mail, password: password) { (user, error) in
            if let err = error {
                print("Error while creating user: \(err.localizedDescription)")
            } else {
                print("User created.")
                
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = username
                changeRequest?.commitChanges(completion: { (error) in
                    if let err = error {
                        print("Error while changing username: \(err.localizedDescription)")
                    } else {
                        print("Name changed.")
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                
            }
        }
    }
    

    

}
