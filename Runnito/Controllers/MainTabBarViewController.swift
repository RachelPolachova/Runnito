//
//  MainTabBarViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 19/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        tabBar.barTintColor = UIColor.RunnitoColors.darkBlue
        tabBar.tintColor = UIColor.RunnitoColors.red
        setupTabBar()
    }
    
    func setupTabBar() {
        
        let startActivityVC = UINavigationController(rootViewController: StartActivityViewController())
        startActivityVC.tabBarItem.image = UIImage(named: "clock")
        startActivityVC.tabBarItem.title = "Timer"
        
        let archiveVC = UINavigationController(rootViewController: ArchiveTableViewController())
        archiveVC.tabBarItem.image = UIImage(named: "list")
        archiveVC.tabBarItem.title = "Archive"
        
        let settingsVC = UINavigationController(rootViewController: SettingsViewController())
        settingsVC.tabBarItem.image = UIImage(named: "cog")
        settingsVC.tabBarItem.title = "Settings"
        
        viewControllers = [startActivityVC, archiveVC, settingsVC]
        
    }

}
