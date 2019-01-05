//
//  Run.swift
//  Runnito
//
//  Created by Ráchel Polachová on 05/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation
import RealmSwift

class Run: Object {
    @objc dynamic var timeStamp = Date()
    @objc dynamic var duration = 0
    @objc dynamic var distance = 0.0
    @objc dynamic var activityType = ""
    let locations = List<Location>()
}
