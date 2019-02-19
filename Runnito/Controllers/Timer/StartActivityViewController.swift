//
//  StartActivityViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 07/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class StartActivityViewController: UIViewController {

//    @IBOutlet weak var chooseActivityButton: UIButton!
//    @IBOutlet weak var notifierButton: UIButton!
//    @IBOutlet weak var startButton: UIButton!
    
    
    var container: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.RunnitoColors.darkGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var shoeImage: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "runner")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        imageView.tintColor = UIColor.RunnitoColors.red
        return imageView
    }()
    
    var chooseActivityButton: ChooseUIButton = {
        let button = ChooseUIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        button.setTitle("Choose activity", for: .normal)
        return button
    }()
    
    var notifierButton: ChooseUIButton = {
        let button = ChooseUIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 55))
        button.setTitle("Notifier", for: .normal)
        return button
    }()
    
    var startButton: SubmitUIButton = {
        let button = SubmitUIButton()
        button.setTitle("START", for: .normal)
        return button
    }()
    
    
    var pickedActivity = ActivitiesEnum(rawValue: 0)
    var notifierValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        
        self.view.addSubview(container)
        self.view.addSubview(shoeImage)
        self.view.addSubview(chooseActivityButton)
        self.view.addSubview(notifierButton)
        self.view.addSubview(startButton)
        
        setupLayout()
        
        startButton.addTarget(self, action: #selector(startButtonPressed(_:)), for: .touchUpInside)
        notifierButton.addTarget(self, action: #selector(notifierButtonPressed(_:)), for: .touchUpInside)
        chooseActivityButton.addTarget(self, action: #selector(activityTypeButtonPressed(_:)), for: .touchUpInside)
    }
    
    //    MARK: - UI Methods
    
    func setUI() {
        self.view.backgroundColor = UIColor.RunnitoColors.darkBlue
        self.navigationController?.navigationBar.tintColor = UIColor.RunnitoColors.darkGray
    }
    
    func setupLayout() {
        
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        
//        container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
//        container.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100).isActive = true
        container.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        container.heightAnchor.constraint(equalToConstant: height * 0.70).isActive = true
        container.layer.cornerRadius = 15
        
        shoeImage.topAnchor.constraint(equalTo: container.topAnchor, constant: 15).isActive = true
        shoeImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        chooseActivityButton.topAnchor.constraint(equalTo: shoeImage.bottomAnchor, constant: 50).isActive = true
        chooseActivityButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        chooseActivityButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chooseActivityButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        notifierButton.topAnchor.constraint(equalTo: chooseActivityButton.bottomAnchor, constant: 15).isActive = true
        notifierButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notifierButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        notifierButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        startButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        startButton.bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        startButton.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        startButton.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        
        
    }


    @objc func startButtonPressed(_ sender: SubmitUIButton) {
        
        let newActivity = NewActivityViewController()
        newActivity.pickedActivity = pickedActivity
        newActivity.notifierValue = notifierValue
        self.navigationController?.pushViewController(newActivity, animated: true)
    }
    
    @objc func notifierButtonPressed(_ sender: ChooseUIButton) {
        
        let detailsOfActivityVC = DetailsOfActivityViewController()
        detailsOfActivityVC.delegate = self
        detailsOfActivityVC.activity = false
        self.navigationController?.pushViewController(detailsOfActivityVC, animated: true)
        
        
    }
    
    @objc func activityTypeButtonPressed(_ sender: ChooseUIButton) {
        let detailsOfActivityVC = DetailsOfActivityViewController()
        detailsOfActivityVC.delegate = self
        detailsOfActivityVC.activity = true
        self.navigationController?.pushViewController(detailsOfActivityVC, animated: true)
    }

}

extension StartActivityViewController: PopupDelegate {
    
    func popupValueSelected(value: Int) {
        print("🐽 popup delegate called")
        notifierValue = value
        notifierButton.setTitle(String(value), for: .normal)
    }
    
    func popupValueSelected(value: ActivitiesEnum) {
        print("🐽 popup delegate called")
        pickedActivity = value
        chooseActivityButton.setTitle(value.description, for: .normal
        )
    }
    
}

