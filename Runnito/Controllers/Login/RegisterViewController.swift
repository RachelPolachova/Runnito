//
//  RegisterViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import Firebase


class RegisterViewController: BaseViewController {

    var profilePictureImageView : ProfileImageView?
    
    var changeProfilePictureButton : UIButton = {
        let button = UIButton()
        button.setTitle("Tap to change", for: .normal)
        button.titleLabel?.font = button.titleLabel?.font.withSize(18)
        button.titleLabel?.textColor = UIColor.RunnitoColors.red
        button.tintColor = UIColor.RunnitoColors.red
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var usernameTextField : LoginUITextField = {
        let textField = LoginUITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        textField.setIcon(UIImage(named: "user")!)
        textField.returnKeyType = UIReturnKeyType.next
        return textField
    }()
    
    var mailTextField : LoginUITextField = {
        let textField = LoginUITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        textField.setIcon(UIImage(named: "envelope")!)
        textField.returnKeyType = UIReturnKeyType.next
        return textField
    }()
    
    var passwordTextField : LoginUITextField = {
        let textField = LoginUITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        textField.isSecureTextEntry = true
        textField.setIcon(UIImage(named: "key")!)
        textField.returnKeyType = UIReturnKeyType.done
        return textField
    }()
    
    var imagePicker = UIImagePickerController()
    var activityView:UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        setupUI()
        profilePictureImageView = ProfileImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.height / 8, height: self.view.frame.height / 8))
        
        view.addSubview(usernameTextField)
        view.addSubview(mailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(profilePictureImageView!)
        view.addSubview(changeProfilePictureButton)
        view.addSubview(activityView)
        usernameTextField.delegate = self
        mailTextField.delegate = self
        passwordTextField.delegate = self
        
        setLayout()
        
        let signUpButton = UIBarButtonItem(title: "Sign up", style: .done, target: self, action: #selector(signUpButtonPressed))
        self.navigationItem.rightBarButtonItem = signUpButton
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(changePictureButtonPressed))
        profilePictureImageView!.addGestureRecognizer(imageTap)
        changeProfilePictureButton.addTarget(self, action: #selector(changePictureButtonPressed), for: .touchUpInside)
        self.hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //    MARK: - UI and Layout methods
    
    func setupUI() {
        self.view.backgroundColor = UIColor.RunnitoColors.darkGray
        self.navigationController?.navigationBar.tintColor = UIColor.RunnitoColors.darkGray
        
        activityView = UIActivityIndicatorView(style: .whiteLarge)
        activityView.color = UIColor.RunnitoColors.red
        activityView.frame = CGRect(x: 0, y: 0, width: 150.0, height: 150.0)
        activityView.center = self.view.center
    }
    
    func setLayout() {
        
        
        let image = UIImage(named: "user-circle-b")!
        
        if let profilePicture = profilePictureImageView {
            profilePicture.image = image
            print("🐮 Picture added!")
            profilePicture.isUserInteractionEnabled = true
            
            profilePicture.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
            profilePicture.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            profilePicture.widthAnchor.constraint(equalToConstant: self.view.frame.height / 8).isActive = true
            profilePicture.heightAnchor.constraint(equalToConstant: self.view.frame.height / 8).isActive = true
            
            changeProfilePictureButton.topAnchor.constraint(equalTo: profilePicture.bottomAnchor, constant: 10).isActive = true
        }
        changeProfilePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        usernameTextField.topAnchor.constraint(equalTo: changeProfilePictureButton.bottomAnchor, constant: 25).isActive = true
        usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        usernameTextField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        mailTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 25).isActive = true
        mailTextField.centerXAnchor.constraint(equalTo: usernameTextField.centerXAnchor).isActive = true
        mailTextField.leadingAnchor.constraint(equalTo: usernameTextField.leadingAnchor).isActive = true
        mailTextField.trailingAnchor.constraint(equalTo: usernameTextField.trailingAnchor).isActive = true
        mailTextField.heightAnchor.constraint(equalTo: usernameTextField.heightAnchor).isActive = true
        
        passwordTextField.topAnchor.constraint(equalTo: mailTextField.bottomAnchor, constant: 25).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: mailTextField.centerXAnchor).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: mailTextField.leadingAnchor).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: mailTextField.trailingAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: mailTextField.heightAnchor).isActive = true
        
    }
    
    override func enableDarkMode() {
        super.enableDarkMode()
        changeProfilePictureButton.setTitleColor(UIColor.RunnitoColors.white, for: .normal)
        profilePictureImageView?.tintColor = UIColor.RunnitoColors.darkGray
        usernameTextField.textColor = UIColor.RunnitoColors.white
        usernameTextField.layer.borderColor = UIColor.RunnitoColors.darkGray.cgColor
        usernameTextField.backgroundColor = UIColor.RunnitoColors.darkGray
        usernameTextField.tintColor = UIColor.RunnitoColors.white
        usernameTextField.setPlaceholder(placeholder: "Username", color: UIColor.RunnitoColors.white)
        mailTextField.textColor = UIColor.RunnitoColors.white
        mailTextField.layer.borderColor = UIColor.RunnitoColors.darkGray.cgColor
        mailTextField.backgroundColor = UIColor.RunnitoColors.darkGray
        mailTextField.tintColor = UIColor.RunnitoColors.white
        mailTextField.setPlaceholder(placeholder: "E-mail", color: UIColor.RunnitoColors.white)
        passwordTextField.textColor = UIColor.RunnitoColors.white
        passwordTextField.layer.borderColor = UIColor.RunnitoColors.darkGray.cgColor
        passwordTextField.backgroundColor = UIColor.RunnitoColors.darkGray
        passwordTextField.tintColor = UIColor.RunnitoColors.white
    }
    
    override func disableDarkMode() {
        super.disableDarkMode()
        changeProfilePictureButton.setTitleColor(UIColor.RunnitoColors.darkGray, for: .normal)
        profilePictureImageView?.tintColor = UIColor.RunnitoColors.lightBlue
        usernameTextField.textColor = UIColor.RunnitoColors.darkGray
        usernameTextField.layer.borderColor = UIColor.RunnitoColors.lightBlue.cgColor
        usernameTextField.backgroundColor = UIColor.RunnitoColors.lightBlue
        usernameTextField.tintColor = UIColor.RunnitoColors.darkGray
        usernameTextField.setPlaceholder(placeholder: "Username", color: UIColor.RunnitoColors.darkGray)
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
    
    
    @objc func changePictureButtonPressed() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    //    MARK: - Firebase methods
    
    @objc func signUpButtonPressed() {
        
        print("😱 login pressed")
        
        guard let username = usernameTextField.text else { return }
        guard let email = mailTextField.text else { return }
        guard let pass = passwordTextField.text else { return }
        guard let image = profilePictureImageView!.image else { return }
        
        activityView.startAnimating()
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                
                self.uploadProfileImage(image) { url in
                    
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = username
                        changeRequest?.photoURL = url
                        
                        changeRequest?.commitChanges { error in
                            if error == nil {
                                
                                self.saveProfile(username: username, profileImageURL: url!) { success in
                                    if success {
                                        print("🌈 success")
                                    }
                                }
                                
                            } else {
                                self.activityView.stopAnimating()
                                self.presentErrorAlert(message: "unable to commit changes.")
                                print("Error: \(error!.localizedDescription)")
                            }
                        }
                    } else {
                        self.activityView.stopAnimating()
                        self.presentErrorAlert(message: "unable to upload profile image")
                    }
                }
                
            } else {
                self.activityView.stopAnimating()
                if let err = error {
                    self.presentErrorAlert(message: "\(err.localizedDescription)")
                } else {
                    self.presentErrorAlert(message: "please try again.")
                }
                
            }
        }
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("🔥 jpeg compress")
            return
        }
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        
        storageRef.putData(imageData, metadata: metaData) { metaData, error in
            if error == nil, metaData != nil {
                if let url = metaData?.downloadURL() {
                    completion(url)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    func saveProfile(username:String, profileImageURL:URL, completion: @escaping ((_ success:Bool)->())) {
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

    // MARK: - UIImagePicker delegate methods

extension RegisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profilePictureImageView!.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}

//    MARK: - Keyboard methods

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if textField == usernameTextField {
            mailTextField.becomeFirstResponder()
        }
        if textField == mailTextField {
            passwordTextField.becomeFirstResponder()
        }
        return true
    }
    
}
