//
//  UserProfileHeader.swift
//  Insta
//
//  Created by Mostafa Adel on 6/22/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase

protocol ProfileHeaderDelegate {
    func didSelectList()
    func didSelectGrid()
}

class UserProfileHeader: UICollectionViewCell {
    var delegate: ProfileHeaderDelegate?
    var userData : UserData? {
        didSet{
            
            guard let imageUrl = userData?.userImage else{return}
            userImage.loadPhotoFromData(imageURL: imageUrl)
            guard let userLabelName = userData?.userName else {return}
            userLaber.text = userLabelName
            setEditingButton()
            setUserPost()
        }
    }
    
    
    fileprivate func setUserPost(){
        guard let uid = userData?.uid else{return}
        
        let ref = Database.database().reference().child("postNumber").child(uid)
        ref.observeSingleEvent(of: .value, with: { (dataSnap) in
            
            guard let dic = dataSnap.value as? [String : Any] else {return}
            guard let numberOfPost = dic["numberOfPost"] as? String else{return}
            let attString = NSMutableAttributedString(string: "\(numberOfPost)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attString.append(NSMutableAttributedString(string: "Posts", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
                ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
            self.postLabel.attributedText = attString
            
        }) { (error) in
            print("There is an error in retrive Data from Database : \(error.localizedDescription)")
            return
        }
        
    }
    
    
    fileprivate func setEditingButton(){
        
        guard let loggedUser = Auth.auth().currentUser?.uid else {return}
        guard let followingUser = userData?.uid else {return}
       
                       
        if loggedUser == followingUser {
            editedProfileOrFollowing.setTitle("Edit Profile", for: .normal)
              
            retriveData(id: loggedUser, type: "userFollowers", dataName: "numberOfFollowers")
            retriveData(id: loggedUser, type: "userFollowing", dataName: "numberOfFollowering")
            
        
        }else{
            
            let ref = Database.database().reference().child("following").child(loggedUser).child(followingUser)
            ref.observeSingleEvent(of: .value, with: { (dataSnapShot) in
                if let val = dataSnapShot.value as? Int, val  == 1{
                    
                    self.editedProfileOrFollowing.setTitle("UnFollow", for: .normal)
                }else{
                    self.setFollowColor()
                }
                
                
            }) { (error) in
                print("There is an error in retriving Data \(error.localizedDescription)")
                return
                
            }
          retriveData(id: followingUser, type: "userFollowers", dataName: "numberOfFollowers")
         retriveData(id: followingUser, type: "userFollowing", dataName: "numberOfFollowering")
        }
        
        
       
        
        
    }
    
    fileprivate func setFollowColor(){
        editedProfileOrFollowing.setTitle("Follow", for: .normal)
        editedProfileOrFollowing.setTitleColor(.white, for: .normal)
        editedProfileOrFollowing.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        editedProfileOrFollowing.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func retriveData(id : String , type:String , dataName : String )  {
        let ref = Database.database().reference().child(type).child(id)
        ref.observeSingleEvent(of: .value, with: { (dataSnap) in
            
            guard let dic = dataSnap.value as? [String: Any] else {return}
            
            guard let dataRetrival = dic[dataName] as? String else{return}
            if type == "userFollowers"{
                
                
                let attString = NSMutableAttributedString(string: "\(dataRetrival)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                attString.append(NSMutableAttributedString(string: "Followers", attributes: [
                    NSAttributedString.Key.foregroundColor: UIColor.lightGray
                    ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
                self.followerLabel.attributedText = attString
                
                
            }else{
                let attStringAgain = NSMutableAttributedString(string: "\(dataRetrival)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                       attStringAgain.append(NSMutableAttributedString(string: "Following", attributes: [
                           NSAttributedString.Key.foregroundColor: UIColor.lightGray
                           ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
                self.followingLabel.attributedText = attStringAgain
                
            }
            
            
          
            
        }) { (error) in
            print("There is an error in retriveing Data : \(error.localizedDescription)")
            return
        }
        
       
    }
    
    
    fileprivate func setFollowRelation (id : String , type:String , dataName : String , sign : String)  {
        let ref = Database.database().reference().child(type).child(id)
        ref.observeSingleEvent(of: .value, with: { (dataSnap) in
            guard let retrivedData = dataSnap.value as? [String : Any]else {
                
                let setDataInfo = Database.database().reference().child(type).child(id)
                let value = ["userId" : id ,dataName : "1" ]
                setDataInfo.setValue(value) { (error, ref) in
                    if let error = error {
                        print("There is error in data Founding : \(error.localizedDescription)")
                        return
                    }
                    let attString = NSMutableAttributedString(string: "1\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
                    attString.append(NSMutableAttributedString(string: "Followers", attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.lightGray
                        ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
                    self.followerLabel.attributedText = attString
                }
                
                return
            }
            
            guard var dataFill = retrivedData[dataName] as? String else {return}
            
            guard var number = Int(dataFill) else{return}
            if sign == "+"{
                number += 1
            }else {
                number -= 1
            }
            dataFill = String(number)
            let setDataInfo = Database.database().reference().child(type).child(id)
            let value = ["userId" : id , dataName : dataFill ]
            setDataInfo.setValue(value) { (error, ref) in
                if let error = error {
                    print("There is error in data Founding : \(error.localizedDescription)")
                    return
                }
            }
            if type == "userFollowers"{
            let attString = NSMutableAttributedString(string: "\(dataFill)\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
            attString.append(NSMutableAttributedString(string: "Followers", attributes: [
                NSAttributedString.Key.foregroundColor: UIColor.lightGray
                ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
            self.followerLabel.attributedText = attString
           
            }
            
        }) { (error) in
            print("There is an error in retriving the Data of Information Header : \(error.localizedDescription)")
            
        }
        
    }
    
    @objc func handelEditFollowing(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let followingUser = userData?.uid else {return}
        
        guard let  checkType = editedProfileOrFollowing.currentTitle  else {return}
        if checkType == "UnFollow"{
            let ref = Database.database().reference().child("following").child(uid).child(followingUser)
            ref.removeValue { (error, refra) in
                if let e = error{
                    print("There is an error in changes of Following User \(e.localizedDescription)")
                    return
                }
                self.setFollowColor()
               
            ///
            
            }
             self.setFollowRelation(id: followingUser, type: "userFollowers", dataName: "numberOfFollowers", sign: "-")
                           
                           ///
                         
               self.setFollowRelation(id: uid, type: "userFollowing", dataName: "numberOfFollowering", sign: "-")
                           
              
            
        }
            
        else {
            let ref = Database.database().reference().child("following").child(uid)
            let values = [followingUser : 1]
            ref.updateChildValues(values) { (error, refra) in
                if let e = error {
                    print("There is an error in setting Followin Data \(e.localizedDescription)")
                    return
                }
                self.editedProfileOrFollowing.setTitle("UnFollow", for: .normal)
                self.editedProfileOrFollowing.setTitleColor(.black, for: .normal)
                self.editedProfileOrFollowing.backgroundColor = .white
                
                
                
            }
            
        self.setFollowRelation(id: followingUser, type: "userFollowers", dataName: "numberOfFollowers", sign: "+")
       
        self.setFollowRelation(id: uid, type: "userFollowing", dataName: "numberOfFollowering", sign: "+")
        }
        
    }
    let userImage : photoUIImageView = {
        let image = photoUIImageView()
        image.backgroundColor = .white
        return image
        
        
    }()
    let userLaber : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = UIColor.black
        return label
        
    }()
    
    lazy var gridButton : UIButton = {
        let button = UIButton(type:.system)
        let symbolConfg = UIImage.SymbolConfiguration(pointSize: 27, weight:.ultraLight, scale: .medium)
        let image = UIImage(systemName: "circle.grid.3x3.fill", withConfiguration: symbolConfg)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        button.addTarget(self, action: #selector(handelGridView), for: .touchUpInside)
        return button
        
    } ()
    @objc func handelGridView(){
        gridButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        listButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didSelectGrid()
    }
    lazy var listButton : UIButton = {
        let button = UIButton(type:.system)
        let symbolConfg = UIImage.SymbolConfiguration(pointSize: 27, weight: .heavy, scale: .medium)
        let image = UIImage(systemName: "list.bullet", withConfiguration: symbolConfg)
        
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        button.addTarget(self, action: #selector(handelListView), for: .touchUpInside)
        return button
        
    } ()
    
    @objc func handelListView(){
        listButton.tintColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        gridButton.tintColor = UIColor(white: 0, alpha: 0.2)
        delegate?.didSelectList()
    }
    let bookmarkButton : UIButton = {
        let button = UIButton(type:.system)
        let symbolConfg = UIImage.SymbolConfiguration(pointSize: 27, weight: .regular, scale: .medium)
        let image = UIImage(systemName: "bookmark", withConfiguration: symbolConfg)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        
        return button
        
    } ()
    
    let postLabel : UILabel = {
        let label = UILabel ()
        label.textAlignment = .center
        let attString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attString.append(NSMutableAttributedString(string: "Posts", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attString
        label.numberOfLines = 0
        
        return label
    }()
    let followerLabel : UILabel = {
        let label = UILabel ()
        label.textAlignment = .center
        let attString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attString.append(NSMutableAttributedString(string: "Followers", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attString
        label.numberOfLines = 0
        
        return label
    }()
    let followingLabel : UILabel = {
        let label = UILabel ()
        label.textAlignment = .center
        let attString = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attString.append(NSMutableAttributedString(string: "Following", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)]))
        label.attributedText = attString
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var editedProfileOrFollowing : UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 3
        button.layer.borderWidth = 1
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(handelEditFollowing), for: .touchUpInside)
        
        return button
        
    } ()
    
    
    
    
    override init(frame : CGRect) {
        
        super.init(frame: frame)
        addSubview(userImage)
        userImage.Anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 12, paddingBottom: 0, paddingLeft: 12, paddingRight: 0, width: 100, height: 100)
        userImage.layer.cornerRadius = 100 / 2
        userImage.clipsToBounds = true
        setNavImage()
        addSubview(userLaber)
        userLaber.Anchor(top: userImage.bottomAnchor, bottom: nil, left: self.leftAnchor , right: self.rightAnchor, paddingTop: 15, paddingBottom: 0, paddingLeft: 12, paddingRight: -12, width: 0, height: 20)
        setStatesInfo()
        addSubview(editedProfileOrFollowing)
        editedProfileOrFollowing.Anchor(top: postLabel.bottomAnchor, bottom: nil, left: postLabel.leftAnchor, right: followingLabel.rightAnchor, paddingTop: 14, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 38)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setStatesInfo (){
        
        let stackView = UIStackView(arrangedSubviews: [postLabel,followerLabel,followingLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.Anchor(top: self.topAnchor, bottom: nil, left: userImage.rightAnchor, right: self.rightAnchor, paddingTop: 18, paddingBottom: 0, paddingLeft: 15, paddingRight: -15, width: 0, height: 45)
    }
    
    fileprivate func setNavImage() {
        
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor.lightGray
        
        let bottomBorder = UIView()
        bottomBorder.backgroundColor = UIColor.lightGray
        let stackView = UIStackView (arrangedSubviews: [gridButton,listButton,bookmarkButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.Anchor(top: nil, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        addSubview(topBorder)
        topBorder.Anchor(top: stackView.topAnchor, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        addSubview(bottomBorder)
        bottomBorder.Anchor(top: nil, bottom: stackView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    
    
}
