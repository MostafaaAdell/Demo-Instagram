//
//  SearchCellController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/25/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit

class SearchCellController: UICollectionViewCell {
    
    var user : UserData? {
        didSet{
            guard let nameOfUser = user?.userName else {return}
            guard let imageOfUser = user?.userImage else {return}
            userName.text = nameOfUser
            userImage.loadPhotoFromData(imageURL: imageOfUser)
        }
    }
    let userImage : photoUIImageView = {
        let ui = photoUIImageView()
        ui.backgroundColor = .white
        ui.contentMode = .scaleAspectFill
        ui.clipsToBounds = true
        return ui
    } ()
    let userName : UILabel = {
        let label = UILabel()
        label.text = "UserName"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(userImage)
        userImage.Anchor(top: nil, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 50, height: 50)
        userImage.layer.cornerRadius = 50/2
        userImage.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.addSubview(userName)
        userName.Anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: userImage.rightAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        let seprator = UIView()
        seprator.backgroundColor = UIColor.gray
        self.addSubview(seprator)
        seprator.Anchor(top: nil, bottom: self.bottomAnchor, left: userName.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
