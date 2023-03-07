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
    var date : Date
    var dateString: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM yyyy HH:mm"
            return formatter.string(from: date)
        }
    
    init(email: String, comment: String, imageUrl: String, date: Date) {
        self.email = email
        self.comment = comment
        self.imageUrl = imageUrl
        self.date = date
    }
    
    
    
}
