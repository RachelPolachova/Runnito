//
//  NewActivity.swift
//  Runnito
//
//  Created by Ráchel Polachová on 18/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import UIKit
import CoreLocation

struct NewActivity {
    let duration: Int
    let distance: Double
    let locationsList: [CLLocation]
    let pickedActivity: ActivitiesEnum
    
    init(duration: Int, distance: Double, locationsList: [CLLocation], pickedActivity: ActivitiesEnum) {
        self.duration = duration
        self.distance = distance
        self.locationsList = locationsList
        self.pickedActivity = pickedActivity
    }
}
