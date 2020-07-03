//
//  Color.swift
//  Insta
//
//  Created by Mostafa Adel on 6/21/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb (red: CGFloat, green: CGFloat, blue: CGFloat) ->UIColor{
        
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
//MARK: -  Layout
extension UIView {
    
    func Anchor(top: NSLayoutYAxisAnchor? , bottom: NSLayoutYAxisAnchor? , left: NSLayoutXAxisAnchor? , right: NSLayoutXAxisAnchor? , paddingTop: CGFloat , paddingBottom: CGFloat , paddingLeft: CGFloat , paddingRight: CGFloat , width: CGFloat , height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        if let bottom = bottom {
            
            self.bottomAnchor.constraint(equalTo: bottom, constant: paddingBottom).isActive = true
        }
        if let left = left {
            
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        if let right = right {
            
            self.rightAnchor.constraint(equalTo: right, constant: paddingRight).isActive = true
        }
        if width != 0 {
            
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if height != 0 {
            
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
    
}

