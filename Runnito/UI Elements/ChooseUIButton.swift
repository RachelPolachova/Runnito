//
//  ChooseUIButton.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit

class ChooseUIButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.RunnitoColors.white.cgColor
        self.setTitleColor(UIColor.RunnitoColors.white, for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        layer.cornerRadius = self.frame.size.height / 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
