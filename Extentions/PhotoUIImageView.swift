//
//  PhotoUIImageView.swift
//  Insta
//
//  Created by Mostafa Adel on 6/24/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
var cacheImages = [String : UIImage]()

class photoUIImageView : UIImageView {
    
    var actualImageLoaded : String?
    func loadPhotoFromData(imageURL : String){
        actualImageLoaded = imageURL
        self.image = nil
        if let imageFound = cacheImages[imageURL]{
            self.image = imageFound
            return
        }
        guard let url = URL(string: imageURL) else {return }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let err = error {
                print("Ther is an error to fetching Data From Database : \(err)")
                
            }
            if url.absoluteString != self.actualImageLoaded {
                return
            }
            guard let sceureData = data else {return}
            let imageLoaded = UIImage(data: sceureData)
            cacheImages[url.absoluteString] = imageLoaded
            DispatchQueue.main.async {
                self.image = imageLoaded
            }
        }).resume()
        
    }
    
    
}
