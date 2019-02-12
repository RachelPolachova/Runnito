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
    
    var changeProfilePictureButton : SubmitUIButton = {
        let button = SubmitUIButton()
        button.setTitle("Tap to change", for: .normal)
        button.tintColor = .lightGray
        return button
    }()
    
    
    var logOutButton : SubmitUIButton = {
        let button = SubmitUIButton()
        button.setTitle("Log out", for: .normal)
        return button
    }()
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(profilePictureImageView)
        view.addSubview(changeProfilePictureButton)
        view.addSubview(logOutButton)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(pictureButtonPressed))
        profilePictureImageView.addGestureRecognizer(imageTap)
        logOutButton.addTarget(self, action: #selector(logOutButtonPressed), for: .touchUpInside)
        changeProfilePictureButton.addTarget(self, action: #selector(pictureButtonPressed), for: .touchUpInside)
        setupLayout()
        
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    @objc func pictureButtonPressed() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func setupLayout() {
        
        profilePictureImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profilePictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePictureImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profilePictureImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        changeProfilePictureButton.topAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor, constant: 15).isActive = true
        changeProfilePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        logOutButton.topAnchor.constraint(equalTo: changeProfilePictureButton.bottomAnchor, constant: 50).isActive = true
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

extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePictureImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

extension UIImageView {
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIView.ContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        
        // make square(* must to make circle),
        // resize(reduce the kilobyte) and
        // fix rotation.
        self.image = anyImage
    }
}
