//
//  InormationHeader.swift
//  Insta
//
//  Created by Mostafa Adel on 7/1/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import Foundation

struct InformationHeader {
    
    var numberOfPost = "0"
    var numberOfFollowing = "0"
    var numberOfFollwers = "0"
    let uid : String
    
    init(user : UserData , dic : [String: Any]) {
        self.numberOfPost = dic["numberOfPost"] as? String ?? "0"
        self.numberOfFollwers = dic["numberOfFollowes"] as? String ?? "0"
        self.numberOfFollowing = dic["numberOfFollowing"] as? String ?? "0"
        self.uid = user.uid
    }
    
    
}
