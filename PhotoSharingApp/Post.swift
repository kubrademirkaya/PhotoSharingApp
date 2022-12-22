//
//  Post.swift
//  PhotoSharingApp
//
//  Created by Kübra Demirkaya on 22.12.2022.
//

import Foundation

class Post {
    
    var email : String
    var comment : String
    var imageUrl : String
    
    init(email: String, comment: String, imageUrl: String) {
        self.email = email
        self.comment = comment
        self.imageUrl = imageUrl
    }
    
}
