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
    
    var profilePictureImageView : UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "user-circle-b")!
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = true
        imageView.tintColor = .lightGray
        imageView.layer.borderWidth = 2.0
        imageView.layer.borderColor = UIColor(hexString: "F25652").cgColor
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = image.size.width / 2
        imageView.clipsToBounds = true
        imageView.image = image
        return imageView
    }()
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .lightGray
        label.text = "unknown"
        return label
    }()

    
    var logOutButton : SubmitUIButton = {
        let button = SubmitUIButton()
        button.setTitle("Log out", for: .normal)
        return button
    }()
    
    var loaded = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profilePictureImageView)
        view.addSubview(usernameLabel)
        view.addSubview(logOutButton)
        
        logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        
        if let user = UserService.currentUserProfile {
            loaded = true
            usernameLabel.text = user.username
            ImageService.downloadImage(withURL: user.photoURL) { (image) in
                self.profilePictureImageView.image = image
            }
        }
        
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !loaded {
            if let user = UserService.currentUserProfile {
                loaded = true
                usernameLabel.text = user.username
                ImageService.downloadImage(withURL: user.photoURL) { (image) in
                    self.profilePictureImageView.image = image
                }
            }
        }
    }
    
    
    func setupLayout() {
        
        profilePictureImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profilePictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePictureImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profilePictureImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        usernameLabel.topAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor, constant: 15).isActive = true
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        logOutButton.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 50).isActive = true
        logOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    @objc func logOutButtonPressed() {
        do {
            try Auth.auth().signOut()
        } catch let err {
            presentErrorAlert(message: "error while singing out: \(err.localizedDescription)")
        }
    }
    
}


