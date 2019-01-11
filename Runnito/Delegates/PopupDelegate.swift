//
//  PopupDelegate.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation

protocol PopupDelegate {
    func popupValueSelected(value: Int)
    func popupValueSelected(value: ActivitiesEnum)
}
