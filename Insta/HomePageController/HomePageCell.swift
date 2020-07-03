//
//  HomePageCell.swift
//  Insta
//
//  Created by Mostafa Adel on 6/25/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
protocol HomePageCommentDelegate {
    func didTapComment(post: PostsData)
    func didLike(for cell: HomePageCell)
}

class HomePageCell: UICollectionViewCell {
    
    var delegate: HomePageCommentDelegate?
    
    var post : PostsData? {
        didSet{
            guard let imageUrl = post?.imageUrl else {return}
            postView.loadPhotoFromData(imageURL: imageUrl)
            guard let userNameLabel = post?.user.userName else {return}
            userName.text = userNameLabel
            guard let imageUser = post?.user.userImage else{return}
            userImage.loadPhotoFromData(imageURL: imageUser)
            likedButton.setImage(post?.liked == true ? UIImage(systemName: "suit.heart.fill" , withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .thin, scale: .large))?.withTintColor(.red, renderingMode:.alwaysOriginal): UIImage(systemName: "suit.heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .thin, scale: .large))?.withRenderingMode(.alwaysOriginal), for: .normal)
           
            
            setCaptionData()
            
        }
    }
    
    fileprivate func setCaptionData(){
        
        guard let post = self.post else{return}
        
        let attr = NSMutableAttributedString(string:post.user.userName, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attr.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attr.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 4)]))
        let actualPostTime  = post.postDate.timeAgoDisplay()
        attr.append(NSAttributedString(string: actualPostTime, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.gray]))
        captionLabel.attributedText = attr
        
    }
    
    let userImage : photoUIImageView = {
        let uv = photoUIImageView()
        uv.backgroundColor = .white
        uv.contentMode = .scaleAspectFit
        uv.clipsToBounds = true
        return uv
    }()
    let userName : UILabel = {
        let un = UILabel()
        un.text = "UserName"
        un.font = UIFont.boldSystemFont(ofSize: 14)
        un.textColor = .black
        return un
    }()
    let optionButton : UIButton = {
        let button = UIButton(type: .system)
        let attr = NSAttributedString(string: "•••", attributes: [NSAttributedString.Key.font :UIFont.boldSystemFont(ofSize: 14),NSAttributedString.Key.foregroundColor : UIColor.black])
        button.setAttributedTitle(attr, for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    } ()
    
    let postView : photoUIImageView = {
        
        let image = photoUIImageView()
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    lazy var likedButton : UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin, scale: .large)
        button.setImage(UIImage(systemName: "suit.heart", withConfiguration: symbolConfig)?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelLike), for: .touchUpInside)
        return button
        
    }()
    @objc func handelLike(){
        delegate?.didLike(for: self)
    }
    lazy var commentButton : UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin, scale: .large)
        button.setImage(UIImage(systemName: "message", withConfiguration: symbolConfig)?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        button.addTarget(self, action: #selector(handelCommentTap), for: .touchUpInside)
        
        return button
        
    }()
    @objc func handelCommentTap(){
        guard let actualPost = post else{return}
        delegate?.didTapComment(post: actualPost)
    }
    let messageButton : UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin, scale: .large)
        button.setImage(UIImage(systemName: "paperplane", withConfiguration: symbolConfig)?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
        
    }()
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .thin, scale: .large)
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: symbolConfig)?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
        
    }()
    let captionLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(userImage)
        self.addSubview(userName)
        self.addSubview(optionButton)
        self.addSubview(postView)
        self.addSubview(bookmarkButton)
        self.addSubview(captionLabel)
        userImage.Anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 8, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 40, height: 40)
        userImage.layer.cornerRadius = 40/2
        userName.Anchor(top: self.topAnchor, bottom: postView.topAnchor , left: userImage.rightAnchor, right: optionButton.leftAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 0, width: 0, height: 0)
        optionButton.Anchor(top: self.topAnchor, bottom:postView.topAnchor , left: nil, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 44, height: 0)
        
        postView.Anchor(top: userImage.bottomAnchor, bottom: nil, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        postView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setActionToPost()
        captionLabel.Anchor(top: likedButton.bottomAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: 8, width: 0, height: 0)
        
        
    }
    
    fileprivate func setActionToPost(){
        let stackView = UIStackView(arrangedSubviews: [likedButton,commentButton,messageButton])
        stackView.distribution = .fillEqually
        self.addSubview(stackView)
        stackView.Anchor(top: postView.bottomAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 4, paddingRight: 0, width: 120, height: 50)
        bookmarkButton.Anchor(top: postView.bottomAnchor, bottom: nil, left: nil, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 40, height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
