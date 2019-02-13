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
    
    var imagePicker = UIImagePickerController()
    
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

        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        
        view.addSubview(usernameTextField)
        view.addSubview(mailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(registerButton)
        view.addSubview(profilePictureImageView)
        view.addSubview(changeProfilePictureButton)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(pictureButtonPressed))
        profilePictureImageView.addGestureRecognizer(imageTap)
        changeProfilePictureButton.addTarget(self, action: #selector(pictureButtonPressed), for: .touchUpInside)
        
        
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
        
        profilePictureImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        profilePictureImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profilePictureImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        profilePictureImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        changeProfilePictureButton.topAnchor.constraint(equalTo: profilePictureImageView.bottomAnchor, constant: 15).isActive = true
        changeProfilePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        usernameTextField.topAnchor.constraint(equalTo: changeProfilePictureButton.bottomAnchor, constant: 25).isActive = true
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
    
    @objc func pictureButtonPressed() {
        self.present(imagePicker, animated: true, completion: nil)
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
        guard let email = mailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        guard let image = profilePictureImageView.image else { return }
        
//        setContinueButton(enabled: false)
//        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("🌈 User created!")
                
                
                
                // 1. Upload the profile image to Firebase Storage
                
                self.uploadProfileImage(image) { url in
                    print("🌈 In uploadProfileImage closure")
                    
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                print("User display name changed!")
                                
                                self.saveProfile(username: username, profileImageURL: url!) { success in
                                    if success {
                                        print("🐰 dismiss called")
                                        self.dismiss(animated: true, completion: nil)
                                    }
                                }
                                
                            } else {
                                print("Error: \(error!.localizedDescription)")
                            }
                        }
                    } else {
                        // Error unable to upload profile image
                    }
                    
                }
                
            } else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        print("🌈 uploadProfileImage called")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                storageRef.downloadURL(completion: { (url, error) in
                    if let error = error {
                        print("🔥 url error")
                    } else {
                        completion(url?.absoluteURL)
                    }
                })
//                if let url = metaData?.downloadURL() {
//                    completion(url)
//                } else {
//                    completion(nil)
//                }
//                // success!
//            } else {
//                // failed
//                completion(nil)
//            }
        }
    }
    }
    
    
    
    func saveProfile(username: String, profileImageURL: URL, completion: @escaping (_ success:Bool)->()) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "username": username,
            "photoURL": profileImageURL.absoluteString
            ] as [String:Any]
        
        databaseRef.setValue(userObject) { error, ref in
            completion(error == nil)
        }
        
    }
    

}

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        print("didFinishPicking")
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            print("Did finish picking not nil")
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
