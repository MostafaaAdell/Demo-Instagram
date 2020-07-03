//
//  CustomPhotoHeader.swift
//  Insta
//
//  Created by Mostafa Adel on 6/23/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit

class CustomPhotoHeader: UICollectionViewCell {
    
    let photoView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .white
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(photoView)
        photoView.Anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
