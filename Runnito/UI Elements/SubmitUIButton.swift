//
//  SubmitUIButton.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class SubmitUIButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        self.setTitleColor(UIColor.RunnitoColors.darkGray, for: .normal)
        self.backgroundColor = UIColor.RunnitoColors.red
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
