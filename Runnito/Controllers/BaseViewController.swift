//
//  BaseViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 20/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

/**
    Theme settings
*/
class BaseViewController: UIViewController {

    var darkMode = UserDefaults.standard.bool(forKey: "darkMode")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeEnabled(_:)), name: .darkModeEnabled, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(darkModeDisabled(_:)), name: .darkModeDisabled, object: nil)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.darkMode = UserDefaults.standard.bool(forKey: "darkMode")
        self.darkMode ? enableDarkMode() : disableDarkMode()
    }

    @objc func darkModeEnabled(_ notification: Notification) {
        enableDarkMode()
    }
    
    @objc func darkModeDisabled(_ notification: Notification) {
        disableDarkMode()
        
    }
    
    open func enableDarkMode() {
        self.view.backgroundColor = UIColor.RunnitoColors.darkBlue
        self.tabBarController?.tabBar.barTintColor = UIColor.RunnitoColors.darkBlue
        self.navigationController?.navigationBar.barTintColor = UIColor.RunnitoColors.darkBlue
        self.navigationController?.navigationBar.tintColor = UIColor.RunnitoColors.white
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    open func disableDarkMode() {
        self.view.backgroundColor = UIColor.RunnitoColors.white
        self.tabBarController?.tabBar.barTintColor = UIColor.RunnitoColors.white
        self.navigationController?.navigationBar.barTintColor = UIColor.RunnitoColors.white
        self.navigationController?.navigationBar.tintColor = UIColor.RunnitoColors.darkGray
        self.navigationController?.navigationBar.barStyle = .default
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return darkMode ? .lightContent : .default
    }
    
    //    MARK: - Dark mode methods
    
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .darkModeEnabled, object: nil)
        NotificationCenter.default.removeObserver(self, name: .darkModeDisabled, object: nil)
    }
    
}
