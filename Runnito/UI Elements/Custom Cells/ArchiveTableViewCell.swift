//
//  ActivityTypesTableViewCell.swift
//  Runnito
//
//  Created by Ráchel Polachová on 19/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ArchiveTableViewCell: UITableViewCell {

    var title: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(20)
        label.textColor = UIColor.RunnitoColors.white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var activityImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubview(activityImage)
        self.addSubview(title)
        self.setupLayout()
    }
    
    func setupLayout() {
        activityImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        activityImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        activityImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        title.leadingAnchor.constraint(equalTo: activityImage.trailingAnchor, constant: 10).isActive = true
        title.centerYAnchor.constraint(equalTo: activityImage.centerYAnchor).isActive = true
        title.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    func setImage(activityType: ActivitiesEnum) {
        self.imageView?.image = activityType.image
        self.tintColor = UIColor.RunnitoColors.red
    }
    
}
