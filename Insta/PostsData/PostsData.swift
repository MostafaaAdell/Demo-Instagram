//
//  PostsData.swift
//  Insta
//
//  Created by Mostafa Adel on 6/24/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import Foundation
struct PostsData {
    var postId : String?
    let imageUrl : String
    let user :  UserData
    let caption : String
    let postDate: Date
    var liked = false
    init(UserData : UserData,Data : [String : Any]) {
        self.imageUrl = Data["imageUrl"] as? String ?? ""
        self.caption = Data["caption"] as? String ?? ""
        self.user = UserData
        
        let timeInDouble = Data["creationDate"] as? Double ?? 0
        self.postDate = Date(timeIntervalSince1970: timeInDouble)
    }
}
