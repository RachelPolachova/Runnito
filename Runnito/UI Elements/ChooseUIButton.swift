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
        layer.cornerRadius = 0
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexString: "F25652").cgColor
        self.setTitleColor(UIColor(hexString: "F25652"), for: .normal)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
