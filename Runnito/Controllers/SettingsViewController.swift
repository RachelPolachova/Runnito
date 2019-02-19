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
    
    var profilePictureImageView : ProfileImageView?
    
    var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.RunnitoColors.white
        label.textAlignment = .center
        label.text = "unknown"
        return label
    }()
    
    var loaded = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profilePictureImageView = ProfileImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.height / 8, height: self.view.frame.height / 8))
        
        if let profPicView = profilePictureImageView {
            view.addSubview(profPicView)
        }
        view.addSubview(usernameLabel)
        
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .done, target: self, action: #selector(logoutButtonPressed(_:)))
        self.navigationItem.rightBarButtonItem = logoutBarButton
        
        setupUI()
        setupLayout()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if !loaded {
            if let user = UserService.currentUserProfile {
                loaded = true
                usernameLabel.text = user.username
                ImageService.downloadImage(withURL: user.photoURL) { (image) in
                    if let profilePicView = self.profilePictureImageView {
                        profilePicView.image = image
                    }
                }
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor.RunnitoColors.darkGray
        self.navigationController?.navigationBar.tintColor = UIColor.RunnitoColors.darkGray
        
        if let user = UserService.currentUserProfile {
            loaded = true
            usernameLabel.text = user.username
            ImageService.downloadImage(withURL: user.photoURL) { (image) in
                if let profilePicView = self.profilePictureImageView {
                    profilePicView.image = image
                }
            }
        }
    }
    
    func setupLayout() {
        
        if let profilePicture = profilePictureImageView {
            profilePicture.isUserInteractionEnabled = true
            
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
            profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profilePicture.widthAnchor.constraint(equalToConstant: self.view.frame.height / 8).isActive = true
            profilePicture.heightAnchor.constraint(equalToConstant: self.view.frame.height / 8).isActive = true
            
            usernameLabel.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 15).isActive = true
        }
        
        usernameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    @objc func logoutButtonPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch let err {
            presentErrorAlert(message: "error while singing out: \(err.localizedDescription)")
        }
    }
    
}


