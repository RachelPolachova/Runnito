//
//  Activity.swift
//  Runnito
//
//  Created by Ráchel Polachová on 18/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation

class Activity {
    var key: String
    var timestamp: Double
    var distance: Double
    var duration: Int
    var latitudes: [Double]?
    var longitudes: [Double]?
    var activityTimestamps: [String]?
    
    init(key: String, timestamp: Double, distance: Double, duration: Int, latitudes: [Double], longitudes: [Double], activityTimestamps: [String]) {
        self.key = key
        self.timestamp = timestamp
        self.distance = distance
        self.duration = duration
        self.latitudes = latitudes
        self.longitudes = longitudes
        self.activityTimestamps = activityTimestamps
    }
    
    init(key: String, timestamp: Double, distance: Double, duration: Int) {
        self.key = key
        self.timestamp = timestamp
        self.distance = distance
        self.duration = duration
        self.latitudes = nil
        self.longitudes = nil
        self.activityTimestamps = nil
    }
    
}
