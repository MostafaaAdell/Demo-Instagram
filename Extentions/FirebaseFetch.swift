//
//  FirebaseFetch.swift
//  Insta
//
//  Created by Mostafa Adel on 6/25/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase
extension FirebaseApp{
    
    
    static func fetchUsetWithUid(id:String , complition : @escaping (UserData)->()){
        
        
        let fetch = Database.database().reference().child("users").child(id)
        fetch.observeSingleEvent(of: .value, with: { (datasnap) in
            
            guard let userData = datasnap.value as? [String : Any]else {return}
            let user = UserData(userId : id ,Dictionary: userData)
            complition(user)
            
        }) { (error) in
            print("There is an error in fetching user Data for given posts \(error.localizedDescription)")
        }
        
        
        
    }
    
}
