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
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.text = "Login."
        label.textColor = UIColor.RunnitoColors.red
        label.font = label.font.withSize(30)
        return label
    }()
    
    var mailTextField : LoginUITextField = {
        let textField = LoginUITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        textField.setPlaceholder(placeholder: "E-mail")
        textField.setIcon(UIImage(named: "envelope")!)
        return textField
    }()
    
    var passwordTextField : LoginUITextField = {
        let textField = LoginUITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        textField.isSecureTextEntry = true
        textField.setIcon(UIImage(named: "key")!)
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.addSubview(mailTextField)
        view.addSubview(passwordTextField)

        setupLayout()
        setupUI()
        
        let loginButton = UIBarButtonItem(title: "Login", style: .done, target: self, action: #selector(handleLogin))
        self.navigationItem.rightBarButtonItem = loginButton
        self.hideKeyboardWhenTappedAround()

    }
    
    func setupUI() {
        self.view.backgroundColor = UIColor.RunnitoColors.darkGray
    }
    
    func setupLayout() {
        
        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        mailTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 25).isActive = true
        mailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        mailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        mailTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 25).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: mailTextField.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: mailTextField.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        
    }
    
    @objc func handleLogin() {
        guard let mail = mailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: mail, password: password) { (user, error) in
            if let err = error {
                self.presentErrorAlert(message: err.localizedDescription)
            } else {
                print("Logged in.")
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }

}
