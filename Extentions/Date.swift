//
//  Date.swift
//  Insta
//
//  Created by Mostafa Adel on 6/27/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit

extension Date{
    
    func timeAgoDisplay ()->String{
        let secongAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month =  4 * week
        
        let quotient : Int
        let unit : String
        
        if secongAgo < minute {
            quotient = secongAgo
            unit = "second"
        }
        else if secongAgo < hour{
            quotient = secongAgo / minute
            unit = "minute"
        }
        else if secongAgo < day {
            quotient = secongAgo / hour
            unit = "hour"
        }
        else if secongAgo < week {
            quotient = secongAgo / day
            unit = "day"
        }
        else if secongAgo < month {
            quotient = secongAgo / week
            unit = "week"
        }
        else{
            quotient = secongAgo / month
            unit = "month"
        }
     
        
        return "\(quotient) \(unit) \(quotient == 1 ? "" : "s") ago"
    }
}
