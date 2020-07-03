//
//  PreviewImageController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/28/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Photos

class PreviewImageController: UIView {
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .orange
        return iv
    }()
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .regular, scale: .medium))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handelCancelButton), for: .touchUpInside)
        return button
    }()
    @objc func handelCancelButton(){
        self.removeFromSuperview()
    }
    let saveButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.down", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35, weight: .regular, scale: .medium))?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self , action: #selector(handelSaveImage), for: .touchUpInside)
        return button
    }()
    @objc func handelSaveImage(){
        guard let savedImage = imageView.image else {return}
        
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: savedImage)
        }) { (bool, error) in
            if let error = error {
                print("There is an error in saving the image in the library : \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                
                let savedLabel = UILabel()
                savedLabel.numberOfLines = 0
                savedLabel.text = "Saved Successfuly"
                savedLabel.font = UIFont.boldSystemFont(ofSize: 18)
                savedLabel.textColor = .white
                savedLabel.backgroundColor = UIColor(white: 0, alpha: 0.3)
                savedLabel.frame = CGRect(x: 0, y: 0, width: 150, height: 80)
                savedLabel.center = self.center
                savedLabel.textAlignment = .center
                self.addSubview(savedLabel)
                savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0 )
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }) { (bool) in
                    UIView.animate(withDuration: 0.5, delay: 0.75, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
                        savedLabel.alpha = 0
                    }) { (_) in
                        savedLabel.removeFromSuperview()
                    }
                }
            }
        }
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
        
    }
    fileprivate func setViews(){
        self.addSubview(imageView)
        imageView.Anchor(top: self.topAnchor, bottom: self.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0 )
        self.addSubview(cancelButton)
        cancelButton.Anchor(top: self.topAnchor, bottom: nil, left: self.leftAnchor, right: nil, paddingTop: 40, paddingBottom: 0, paddingLeft: 24, paddingRight: 0, width: 50, height: 50)
        self.addSubview(saveButton)
        saveButton.Anchor(top: nil, bottom: self.bottomAnchor, left: self.leftAnchor, right: nil, paddingTop: 0, paddingBottom: -60, paddingLeft: 24, paddingRight: 0, width: 50, height: 50)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
