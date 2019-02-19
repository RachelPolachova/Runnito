//
//  TimeLabel.swift
//  Runnito
//
//  Created by Ráchel Polachová on 19/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation
import UIKit

class TimeLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        textAlignment = .justified
        textColor = UIColor.RunnitoColors.red
        font = UIFont.boldSystemFont(ofSize: 16.0).withSize(40)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
