//
//  SharePhotoController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/24/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    static let updateFeedNotification = NSNotification.Name("UpdateNewFeed")
    var customImage : UIImage?{
        didSet{
            imageSelectedImage.image = customImage
        }
    }
    let customView : UIView = {
        let cv = UIView()
        cv.backgroundColor = .white
        return cv
    }()
    let imageSelectedImage : UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .blue
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
        
    }()
    let shareMessage : UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.textColor = .black
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "share", style: .plain, target: self, action: #selector(handelShareButton))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)], for: .normal)
        navigationController?.navigationBar.tintColor = .black
        
        view.addSubview(customView)
        customView.Anchor(top: view.safeAreaLayoutGuide.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0 , paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0 , height: 120)
        customView.addSubview(imageSelectedImage)
        imageSelectedImage.Anchor(top: customView.topAnchor, bottom: customView.bottomAnchor, left: customView.leftAnchor, right: nil, paddingTop: 8, paddingBottom: -8, paddingLeft: 8, paddingRight: 0, width: 104, height: 0)
        
        customView.addSubview(shareMessage)
        shareMessage.Anchor(top: customView.topAnchor, bottom: customView.bottomAnchor, left: imageSelectedImage.rightAnchor, right: customView.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
    }
    @objc func handelShareButton(){
        guard let message = shareMessage.text , message.count > 0 else {return}
        let uid = NSUUID().uuidString
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let actualImage = customImage else{return}
        guard let storeimage = actualImage.jpegData(compressionQuality: 0.5) else {return}
        let ref =  Storage.storage().reference().child("posts").child(uid)
        ref.putData(storeimage, metadata: nil) { (metadata, error) in
            if let e = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("There is an error in storing Image \(e.localizedDescription)")
                return
            }
            
            ref.downloadURL(completion: { (url, error) in
                if let e = error {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    print("There is an error in url loaded \(e.localizedDescription)")
                    return
                }
                
                self.setInformationHeader()
                guard let downloadUrl = url?.absoluteString else {return}
                self.setDatabaseStorage(imageUrl: downloadUrl)
            })
        }
        
        
        
        
    }
    
    fileprivate func setInformationHeader (){
        guard let uid =  Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("postNumber").child(uid)
        ref.observeSingleEvent(of: .value, with: { (dataSnap) in
            guard let retrivedData = dataSnap.value as? [String : Any]else {
                
                let setDataInfo = Database.database().reference().child("postNumber").child(uid)
                let value = ["userId" : uid , "numberOfPost" : "1" ]
                setDataInfo.setValue(value) { (error, ref) in
                    if let error = error {
                        print("There is error in data Founding : \(error.localizedDescription)")
                        return
                    }
                }
                
                return
            }
            
            guard var numberOfPost = retrivedData["numberOfPost"] as? String else {return}
             
            guard var IntNumber = Int(numberOfPost) else{return}
            IntNumber += 1
            numberOfPost = String(IntNumber)
            let setDataInfo = Database.database().reference().child("postNumber").child(uid)
                           let value = ["userId" : uid , "numberOfPost" : numberOfPost ]
                           setDataInfo.setValue(value) { (error, ref) in
                               if let error = error {
                                   print("There is error in data Founding : \(error.localizedDescription)")
                                   return
                               }
                           }
            
            
        }) { (error) in
            print("There is an error in retriving the Data of Information Header : \(error.localizedDescription)")
            
        }
        
    }
    
    func setDatabaseStorage(imageUrl: String){
        guard let imageDB = customImage else {return}
        guard let message = shareMessage.text , message.count > 0 else {return}
        guard let id = Auth.auth().currentUser?.uid else {return}
        let dataPostStore = ["imageUrl" : imageUrl , "caption" : message , "imageWidth": imageDB.size.width ,"imageHeight" : imageDB.size.height , "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        let ref = Database.database().reference().child("posts").child(id)
        let storeDataPosts = ref.childByAutoId()
        storeDataPosts.updateChildValues(dataPostStore) { (error, metadata) in
            if let e = error {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Faild to store data of post in data base : \(e.localizedDescription)")
                return
            }
            
            let mainTabBar = MainTabBarController()
            self.view.window?.rootViewController = mainTabBar
            self.present(mainTabBar, animated: true, completion: nil)
            
            NotificationCenter.default.post(name: SharePhotoController.updateFeedNotification, object: nil)
            
            
        }
        
        
    }
    
    override var prefersStatusBarHidden: Bool{
        return true	
    }
    
    
}
