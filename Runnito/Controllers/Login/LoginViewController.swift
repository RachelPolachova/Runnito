//
//  LoginViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: BaseViewController {
    
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
        textField.returnKeyType = .next
        textField.setIcon(UIImage(named: "envelope")!)
        return textField
    }()
    
    var passwordTextField : LoginUITextField = {
        let textField = LoginUITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.setIcon(UIImage(named: "key")!)
        return textField
    }()
    
    var activityView: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(titleLabel)
        view.addSubview(mailTextField)
        view.addSubview(passwordTextField)

        mailTextField.delegate = self
        passwordTextField.delegate = self
        
        setupLayout()
        setupUI()
        view.addSubview(activityView)
        
        let loginButton = UIBarButtonItem(title: "Login", style: .done, target: self, action: #selector(loginButtonPressed))
        self.navigationItem.rightBarButtonItem = loginButton
        self.hideKeyboardWhenTappedAround()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //    MARK: - UI methods
    
    func setupUI() {
        self.view.backgroundColor = UIColor.RunnitoColors.darkGray
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.color = UIColor.RunnitoColors.red
        activityView.frame = CGRect(x: 0, y: 0, width: 150.0, height: 150.0)
        activityView.center = self.view.center
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
    
    override func enableDarkMode() {
        super.enableDarkMode()
        mailTextField.textColor = UIColor.RunnitoColors.white
        mailTextField.layer.borderColor = UIColor.RunnitoColors.darkGray.cgColor
        mailTextField.backgroundColor = UIColor.RunnitoColors.darkGray
        mailTextField.tintColor = UIColor.RunnitoColors.white
        mailTextField.setPlaceholder(placeholder: "E-mail", color: UIColor.RunnitoColors.white)
        passwordTextField.textColor = UIColor.RunnitoColors.white
        passwordTextField.layer.borderColor = UIColor.RunnitoColors.darkGray.cgColor
        passwordTextField.backgroundColor = UIColor.RunnitoColors.darkGray
        passwordTextField.tintColor = UIColor.RunnitoColors.white
//        passwordTextField.setPlaceholder(placeholder: "E-mail", color: UIColor.RunnitoColors.white)
    }
    
    override func disableDarkMode() {
        super.disableDarkMode()
        mailTextField.textColor = UIColor.RunnitoColors.darkGray
        mailTextField.layer.borderColor = UIColor.RunnitoColors.lightBlue.cgColor
        mailTextField.backgroundColor = UIColor.RunnitoColors.lightBlue
        mailTextField.tintColor = UIColor.RunnitoColors.darkGray
        mailTextField.setPlaceholder(placeholder: "E-mail", color: UIColor.RunnitoColors.darkGray)
        passwordTextField.textColor = UIColor.RunnitoColors.darkGray
        passwordTextField.layer.borderColor = UIColor.RunnitoColors.lightBlue.cgColor
        passwordTextField.backgroundColor = UIColor.RunnitoColors.lightBlue
        passwordTextField.tintColor = UIColor.RunnitoColors.darkGray
    }
    
    @objc func loginButtonPressed() {
        activityView.startAnimating()
        guard let mail = mailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: mail, password: password) { (user, error) in
            self.activityView.stopAnimating()
            if let err = error {
                self.presentErrorAlert(message: err.localizedDescription)
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
}

extension LoginViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == mailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
}
