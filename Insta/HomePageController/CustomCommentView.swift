//
//  CustomCommentView.swift
//  Insta
//
//  Created by Mostafa Adel on 7/2/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
protocol CustomCommentViewDelegate {
    func didSubmitComment(for comment : String)
}
class CustomCommentView : UIView {
    
    var delegate : CustomCommentViewDelegate?
    
    func clearDataNotNeeded(){
        inputComment.text = nil
        inputComment.showPlaceHolder()
    }
    private let submitButton : UIButton = {
        let sb = UIButton(type: .system)
        
        
        sb.setTitle("Submit", for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        sb.setTitleColor(.black, for: .normal)
        sb.addTarget(self, action: #selector(handelSubmitComment), for: .touchUpInside)

        return sb
        
    }()
    private let inputComment : CustomTextView = {
        let inputText = CustomTextView()
       // inputText.placeholder = " Enter Comment"
        inputText.isScrollEnabled = false
        inputText.font = UIFont.systemFont(ofSize: 16)
        inputText.backgroundColor = .white
        inputText.layer.cornerRadius = 10
        inputText.layer.borderColor = UIColor.gray.cgColor
        inputText.layer.borderWidth = 0.5
        
        
        return inputText
    }()
    @objc private  func handelSubmitComment(){
        guard let comment = inputComment.text else{return}
        delegate?.didSubmitComment(for: comment)
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        autoresizingMask = .flexibleHeight
        backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        addSubview(submitButton)
        submitButton.Anchor(top: topAnchor, bottom: nil, left: nil, right: rightAnchor, paddingTop: 4, paddingBottom: 0, paddingLeft: 0, paddingRight: -14, width: 80, height: 50)
        setupLineSeprator()
        addSubview(inputComment)
        inputComment.Anchor(top: topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: leftAnchor, right: submitButton.leftAnchor, paddingTop: 8, paddingBottom: -8, paddingLeft: 14, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate func setupLineSeprator(){
        let seprator = UIView()
              seprator.backgroundColor = UIColor.gray
          self.addSubview(seprator)
              seprator.Anchor(top: topAnchor, bottom: nil, left: leftAnchor, right: rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 1)
    }
    override var intrinsicContentSize: CGSize{
        return . zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

