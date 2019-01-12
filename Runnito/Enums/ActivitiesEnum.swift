//
//  ActivitiesEnum.swift
//  Runnito
//
//  Created by Ráchel Polachová on 11/01/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation

enum ActivitiesEnum: Int, CaseIterable {
    case walking = 0
    case running = 1
    case cycling = 2
    case hiking = 3
    
    var description: String {
        switch self {
        case .walking: return "Walking"
        case .running: return "Running"
        case .cycling: return "Cycling"
        case .hiking: return "Hiking"
        }
    }
    
}
