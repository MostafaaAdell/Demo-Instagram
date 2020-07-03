//
//  CustomTextView.swift
//  Insta
//
//  Created by Mostafa Adel on 7/2/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {

    fileprivate let placeHolderLabel : UILabel = {
        let lab = UILabel()
        lab.text = "Enter Comment"
        lab.font = UIFont.systemFont(ofSize: 16)
        lab.textColor = UIColor.lightGray
        return lab
    }()
 
    func showPlaceHolder(){
        placeHolderLabel.isHidden = false
    }
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handelPlaceHolder), name: UITextView.textDidChangeNotification, object: nil)
        addSubview(placeHolderLabel)
        placeHolderLabel.Anchor(top: topAnchor, bottom: bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0 )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handelPlaceHolder(){
        placeHolderLabel.isHidden = !self.text.isEmpty
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
