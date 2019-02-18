//
//  UserService.swift
//  Runnito
//
//  Created by Ráchel Polachová on 18/02/2019.
//  Copyright © 2019 Rachel Polachova. All rights reserved.
//

import Foundation
import Firebase

class UserService {
    
    static var currentUserProfile:UserProfile?
    
    static func observeUser(uid: String, completion: @escaping (_ userProfile:UserProfile?)->()) {
        let userRef = Database.database().reference().child("users/profile/\(uid)")
        var userProfile:UserProfile?
        
        userRef.observe(.value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any],
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string: photoURL) {
                userProfile = UserProfile(username: username, photoURL: url)
            }
            completion(userProfile)
        }
    }
    
}
