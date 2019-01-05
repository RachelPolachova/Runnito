//
//  Location.swift
//  Runnito
//
//  Created by Ráchel Polachová on 05/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation
import RealmSwift

class Location: Object {
    @objc dynamic var timeStamp = Date()
    @objc dynamic var longitude = 0.0
    @objc dynamic var latitude = 0.0
}
