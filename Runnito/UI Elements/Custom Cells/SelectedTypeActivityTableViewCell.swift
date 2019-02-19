//
//  SelectedTypeActivityTableViewCell.swift
//  Runnito
//
//  Created by Ráchel Polachová on 12/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class SelectedTypeActivityTableViewCell: UITableViewCell {
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.RunnitoColors.red
        label.font = label.font.withSize(35)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.RunnitoColors.white.withAlphaComponent(0.7)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var distanceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = UIColor.RunnitoColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(timeLabel)
        self.addSubview(dateLabel)
        self.addSubview(distanceLabel)
        self.setupLayout()
    }
    
    func setupLayout() {
        timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 25).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        dateLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        distanceLabel.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor).isActive = true
        distanceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        distanceLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
