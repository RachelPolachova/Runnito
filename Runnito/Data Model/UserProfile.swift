//
//  UserProfile.swift
//  Runnito
//
//  Created by Ráchel Polachová on 18/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation

class UserProfile {
    var username: String
    var photoURL: URL
    
    init(username: String, photoURL: URL) {
        self.username = username
        self.photoURL = photoURL
    }
}
