//
//  PlusPhotoControllerCollectionViewController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/23/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Photos

private let cellid = "Cell"
private let headerid = "Header"

class PlusPhotoController: UICollectionViewController ,UICollectionViewDelegateFlowLayout {
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    var SelectedHeaderImage : UIImage?
    var loadedImages = [UIImage]()
    var assets = [PHAsset]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        collectionView.backgroundColor = .white
        
        // Register cell classes
        //        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        self.collectionView.register(CustomPhotoHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerid)
        self.collectionView.register(CustomPhotoCell.self, forCellWithReuseIdentifier: cellid)
        // Do any additional setup after loading the view.
        setBarButton()
        fetchPhoto()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        SelectedHeaderImage = loadedImages[indexPath.row]
        collectionView.reloadData()
        
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    fileprivate func fetchOtions ()-> PHFetchOptions{
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 29
        let fetchSorting = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [fetchSorting]
        return fetchOptions
    }
    fileprivate func fetchPhoto() {
        
        
        DispatchQueue.global(qos: .background).async {
            let allPhotos = PHAsset.fetchAssets(with: .image, options: self.fetchOtions())
            
            allPhotos.enumerateObjects { (asset, count, stop) in
                let imageManger = PHImageManager.default()
                let targetSize = CGSize(width: 200 , height: 200)
                let option = PHImageRequestOptions()
                option.isSynchronous = true
                imageManger.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: option) { (image, info) in
                    if let image = image {
                        self.loadedImages.append(image)
                        self.assets.append(asset)
                        
                        if self.SelectedHeaderImage == nil {
                            self.SelectedHeaderImage = image
                        }
                        
                    }
                    if count == allPhotos.count-1 {
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    var header : CustomPhotoHeader?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerid, for: indexPath) as!CustomPhotoHeader
        self.header = header
        header.photoView.image = SelectedHeaderImage
        if let SelectedHeaderImage = SelectedHeaderImage{
            if let indexies = loadedImages.firstIndex(of: SelectedHeaderImage){
                let assetIndex = assets[indexies]
                let imageManager = PHImageManager.default()
                imageManager.requestImage(for: assetIndex, targetSize: CGSize(width: 600  , height: 600), contentMode: .default, options: nil) { (image, info) in
                    header.photoView.image = image
                }
            }
            
        }
        
        
        return header
    }
    
    fileprivate func setBarButton() {
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handelCancelButton))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handelNext))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)], for: .normal)
        
    }
    @objc func handelCancelButton() {
        let mainTabBar = MainTabBarController()
        view.window?.rootViewController = mainTabBar
        present(mainTabBar, animated: true, completion: nil)
    }
    @objc func handelNext(){
        
        let sharePhotoController = SharePhotoController()
        sharePhotoController.customImage = header?.photoView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
  
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return loadedImages.count
    }
    //
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! CustomPhotoCell
        cell.photoView.image = loadedImages[indexPath.item]
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3) / 4
        return CGSize(width: width, height: width)
    }
    
    
}
