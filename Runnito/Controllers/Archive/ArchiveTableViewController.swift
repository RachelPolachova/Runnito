//
//  ArchiveTableViewController.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ArchiveTableViewController: UIViewController {
    
    var selectedTypeOfActivity: ActivitiesEnum?
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.RunnitoColors.darkGray
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(ArchiveTableViewCell.self, forCellReuseIdentifier: "archiveCell")
        self.view.addSubview(tableView)
        setupUI()
        setupLayout()
        
        
    }
    
    func setupUI() {
        
    }
    
    func setupLayout() {
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

    

}

// MARK: - TableView delegate methods

extension ArchiveTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let guide = view.safeAreaLayoutGuide
        let height = guide.layoutFrame.size.height
        return CGFloat(height / CGFloat(ActivitiesEnum.allCases.count))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ActivitiesEnum.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "archiveCell", for: indexPath) as! ArchiveTableViewCell
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        if let type = ActivitiesEnum(rawValue: indexPath.row) {
            cell.title.text = type.description
            cell.setImage(activityType: type)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTypeOfActivity = ActivitiesEnum(rawValue: indexPath.row)
        let selectedTypeVC = SelectedTypeActivityTableViewController()
        selectedTypeVC.selectedTypeOfActivity = selectedTypeOfActivity
        self.navigationController?.pushViewController(selectedTypeVC, animated: true)
    }
}
