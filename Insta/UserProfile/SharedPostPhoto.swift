//
//  SharedPostPhoto.swift
//  Insta
//
//  Created by Mostafa Adel on 6/24/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit

class SharedPostPhoto: UICollectionViewCell {
    
    
    var post : PostsData? {
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            sharePhotoView.loadPhotoFromData(imageURL: imageUrl)
            
        }
    }
    let sharePhotoView : photoUIImageView = {
        let shView = photoUIImageView()
        shView.backgroundColor = .white
        shView.contentMode = .scaleAspectFill
        shView.clipsToBounds = true
        return shView
        
        
    }()
    
    override init(frame: CGRect) {
      super.init(frame: frame)
        self.addSubview(sharePhotoView)
        sharePhotoView.Anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
