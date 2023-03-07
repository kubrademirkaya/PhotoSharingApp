//
//  User.swift
//  PhotoSharingApp
//
//  Created by Kübra Demirkaya on 25.02.2023.
//

import Foundation

class UserInfo {
    
    var email : String
    var shareCount : Int
    var userCreatedDate: Date
    
    init(email: String, shareCount: Int, userCreatedDate: Date) {
        self.email = email
        self.shareCount = shareCount
        self.userCreatedDate = userCreatedDate
    }
}
