//
//  Comment.swift
//  Insta
//
//  Created by Mostafa Adel on 6/29/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import Foundation
struct Comment{
    let text : String
    let user : UserData
    let uid : String
    
    init(user: UserData , dic : [String : Any]) {
        self.user = user
        self.text = dic["text"] as? String ?? ""
        self.uid = dic["userId"] as? String ?? ""
    }
}
