//
//  UserData.swift
//  Insta
//
//  Created by Mostafa Adel on 6/25/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import Foundation

struct UserData {
    let uid : String
    let userName : String
    let userImage : String
    init(userId : String ,Dictionary : [String : Any]) {
        self.userName = Dictionary["Username"] as? String ?? ""
        self.userImage = Dictionary["Profile_Image"] as? String ?? ""
        self.uid = userId
    }
    
}
