//
//  ProfileImageView.swift
//  Runnito
//
//  Created by Ráchel Polachová on 19/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation
import UIKit

class ProfileImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        tintColor = UIColor.RunnitoColors.white
        layer.borderWidth = 2.0
        layer.borderColor = UIColor(hexString: "F25652").cgColor
        layer.masksToBounds = false
        clipsToBounds = true
        layer.cornerRadius = self.frame.size.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
