//
//  SettingOfStatusBar.swift
//  Insta
//
//  Created by Mostafa Adel on 6/23/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
class SettingOfStatusBar : UINavigationController {
    
    
    
    override var childForStatusBarStyle: UIViewController?{
        topViewController
    }
    override var childForStatusBarHidden: UIViewController?{
        topViewController
    }
}
