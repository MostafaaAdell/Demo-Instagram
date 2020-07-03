//
//  MainTabBarController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/21/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController ,UITabBarControllerDelegate{
    
    var window: UIWindow?
    let homePage =  HomePageController(collectionViewLayout: UICollectionViewFlowLayout())
    var lastView = 0
    var doubleTab = 0
    
    let userImage : UIImage = {
        let image = UIImage()
        
        return image
    }()
  
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let index = viewControllers?.firstIndex(of:viewController) else {fatalError("There is error in index")}
        
        if index == 2{
            let layout = UICollectionViewFlowLayout()
            let plusView = PlusPhotoController(collectionViewLayout: layout)
            let plusNavController = SettingOfStatusBar(rootViewController: plusView)
           view.window?.rootViewController = plusNavController
           present(plusNavController, animated: true, completion: nil)
            
        }
        if index == 0 && lastView == index {
            let indexPath = IndexPath(item: 0, section: 0)
          homePage.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        }
        lastView = index
      
        return true
    }
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        /////
        ///
       
        
        ////
        // Do any additional setup after loading the view.
        self.delegate = self
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
                let userLogin = LoginUserController()
                let navLoginController = SettingOfStatusBar(rootViewController: userLogin)
                self.view.window?.rootViewController = navLoginController
                self.present(navLoginController, animated: true, completion: nil)
                return
            }
        }
        
        setupDataOfMainController()
    }
    func setupDataOfMainController(){
        
        

     
        
        //home
        let homeNavBar = setTabBarItems(NotFill: "house", Fill: "houseFill",DefaultViewController: homePage)
        //search
        let searchNavBar = setTabBarItems(NotFill: "magnifyingglass.circle", Fill: "magnifyingglass.circle.fill",DefaultViewController: SearchViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        //Plus
        let plusNavBar = setTabBarItems(NotFill: "plus.app", Fill: "plus.app.fill")
        //like
        let likeNavBar = setTabBarItems(NotFill: "suit.heart", Fill: "suit.heart.fill")
        
        //profile
        let profileNavBar = setTabBarItems(NotFill: "person", Fill: "person.fill", DefaultViewController: UserProfileController(collectionViewLayout: UICollectionViewFlowLayout()))
            tabBar.tintColor = .black
        
        
        viewControllers = [homeNavBar,searchNavBar,plusNavBar,likeNavBar,profileNavBar]
        guard let items = tabBar.items else {return}
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 97, left: 0, bottom: 97, right: 0)
        }
    }
    
    
    
    fileprivate func setTabBarItems (NotFill : String , Fill :String , DefaultViewController  :UIViewController  = UIViewController() ) -> UINavigationController {
        
        let uiViewController = DefaultViewController
        let navController = UINavigationController(rootViewController: uiViewController)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .large)
        var image : UIImage?
        var selectedImage : UIImage?
        if NotFill == "house"{
            image = UIImage(named: NotFill)
             selectedImage = UIImage(named: Fill)
        }
        else{
        image = UIImage(systemName: NotFill,withConfiguration: symbolConfig)
        selectedImage = UIImage(systemName: Fill, withConfiguration: symbolConfig)
            
        }
        
        navController.tabBarItem.image = image
        
        navController.tabBarItem.selectedImage = selectedImage
        
        return navController
    }
    
    
    
}
