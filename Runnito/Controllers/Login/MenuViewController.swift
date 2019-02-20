//
//  MenuViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import Firebase

class MenuViewController: BaseViewController {

    var loginButton : ChooseUIButton = {
        let button = ChooseUIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        button.setTitle("Login", for: .normal)
        return button
    }()
    var registerButton : ChooseUIButton = {
        let button = ChooseUIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        button.setTitle("Register", for: .normal)
        return button
    }()
    
    var logoImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "runner")!
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
//        imageView.tintColor = UIColor.RunnitoColors.white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Runnito."
        label.textColor = UIColor.RunnitoColors.red
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 16.0).withSize(45)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerButtonPressed(sender:)), for: .touchUpInside)
        self.view.addSubview(logoImageView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //    MARK: - UI methods
    
    func setupUI() {
        view.backgroundColor = UIColor.RunnitoColors.darkGray
        self.navigationController?.navigationBar.tintColor = UIColor.RunnitoColors.darkGray
    }
    
    func setupLayout() {
        
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        loginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 55).isActive = true

        registerButton.bottomAnchor.constraint(equalTo: loginButton.topAnchor, constant: -25).isActive = true
        registerButton.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalTo: loginButton.widthAnchor).isActive = true
        registerButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
    
    override func enableDarkMode() {
        super.enableDarkMode()
        logoImageView.tintColor = UIColor.RunnitoColors.white
        loginButton.setTitleColor(UIColor.RunnitoColors.white, for: .normal)
        loginButton.layer.borderColor = UIColor.RunnitoColors.white.cgColor
        registerButton.setTitleColor(UIColor.RunnitoColors.white, for: .normal)
        registerButton.layer.borderColor = UIColor.RunnitoColors.white.cgColor
    }
    
    override func disableDarkMode() {
        super.disableDarkMode()
        logoImageView.tintColor = UIColor.RunnitoColors.darkGray
        loginButton.setTitleColor(UIColor.RunnitoColors.darkGray, for: .normal)
        loginButton.layer.borderColor = UIColor.RunnitoColors.darkGray.cgColor
        registerButton.setTitleColor(UIColor.RunnitoColors.darkGray, for: .normal)
        registerButton.layer.borderColor = UIColor.RunnitoColors.darkGray.cgColor
    }
    
    
    @objc func loginButtonPressed(sender: ChooseUIButton) {
        sender.pulsate()
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
        
    }
    
    @objc func registerButtonPressed(sender: ChooseUIButton) {
        sender.pulsate()
        let registerVC = RegisterViewController()
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
    

}
