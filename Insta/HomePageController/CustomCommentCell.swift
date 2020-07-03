//
//  CustomCommentCell.swift
//  Insta
//
//  Created by Mostafa Adel on 6/29/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit

class CustomCommentCell: UICollectionViewCell {
    
    
    
    
    var comment : Comment?{
        didSet{
            guard let comment = comment else{return}
            userImage.loadPhotoFromData(imageURL: comment.user.userImage)
            let attrCong = NSMutableAttributedString (string: comment.user.userName, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16)])
            attrCong.append(NSAttributedString(string: " \(comment.text)", attributes: [NSAttributedString.Key.font  : UIFont.systemFont(ofSize: 16)]))
            commentText.attributedText = attrCong
        }
    }
    
    let userImage : photoUIImageView = {
        let imageView = photoUIImageView()
        imageView.clipsToBounds = true
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    let commentText : UITextView = {
        let text = UITextView()
        text.backgroundColor = .white
        text.isScrollEnabled = false
        return text
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addSubview(userImage)
        userImage.Anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        userImage.layer.cornerRadius = 40/2
        self.addSubview(commentText)
        commentText.Anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: userImage.rightAnchor, right: self.rightAnchor, paddingTop: 4, paddingBottom: -4, paddingLeft: 4, paddingRight: -4, width: 0, height: 0)
        let seprator = UIView()
        seprator.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        self.addSubview(seprator)
        seprator.Anchor(top: nil, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
