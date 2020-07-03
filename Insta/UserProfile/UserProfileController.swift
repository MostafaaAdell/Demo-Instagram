//
//  UserProfileController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/21/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase


class UserProfileController: UICollectionViewController ,UICollectionViewDelegateFlowLayout , ProfileHeaderDelegate{
    
    
    
    let cellid = "cellId"
    let cellListId = "cellListId"
    var postsData = [PostsData]()
    var userData : UserData?
    var visitorId : String?
    var GridView = true
    var isPaginationFinish = false
    var finishLoading = true
    var counting = 0
    var allChild = 0
    var countingToReturn : TimeInterval?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        collectionView.backgroundColor = .white
        loadUsername()
        collectionView.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader , withReuseIdentifier: "HeaderId")
        collectionView.register(SharedPostPhoto.self, forCellWithReuseIdentifier: cellid)
        collectionView.register(HomePageCell.self, forCellWithReuseIdentifier: cellListId)
        //        loadPostsToProfile()
        navigationController?.navigationBar.tintColor = .black
        setupLogoutButton()
       
        
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
    
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
    }
    
    
    fileprivate func paginationOfUserProfile(){
        
        if allChild == counting {
            
            counting = 0
            guard let uid  = userData?.uid else{return}
            let ref = Database.database().reference().child("posts").child(uid)
            var query = ref.queryOrdered(byChild: "creationDate")
            if postsData.count > 0 {
                guard let actualValue = postsData.last?.postDate.timeIntervalSince1970 else{return}
                if countingToReturn == actualValue{
                    return
                }
                let val = actualValue
                countingToReturn = val
                query = query.queryEnding(atValue: val)
            }
            query.queryLimited(toLast: 4).observe(.value, with: { (datasnap) in
                guard var allNodes = datasnap.children.allObjects as? [DataSnapshot]else{
                    return}
                allNodes.reverse()
                if allNodes.count < 4 {
                    self.isPaginationFinish = true
                    
                }
                if self.postsData.count > 0  && allNodes.count > 0 {
                    allNodes.removeFirst()
                }
                self.allChild = allNodes.count
                guard let user = self.userData else{return}
                
                allNodes.forEach { (dataSnap) in
                    guard let dics = dataSnap.value as? [String : Any] else{return}
                    
                    var post = PostsData(UserData: user, Data: dics)
                    post.postId = dataSnap.key
                    self.postsData.append(post)
                    
                }
                
                self.collectionView.reloadData()
                
            }) { (error) in
                print("There is an error in retriving Data : \(error.localizedDescription)")
            }
            
            
        }
        
    }
    
    //    func loadPostsToProfileCorrectly(){
    //
    //        let uid = userData?.uid ?? ""
    //        let ref = Database.database().reference().child("posts").child(uid)
    //        ref.queryOrdered(byChild: "creationData").observe(.childAdded, with: { (dataSnapShot) in
    //            guard let user = self.userData else {return}
    //            guard let Dictionary = dataSnapShot.value as? [String : Any] else {return}
    //            let post = PostsData(UserData: user, Data: Dictionary )
    //            self.postsData.insert(post, at: 0)
    //            self.collectionView.reloadData()
    //
    //        }) { (error) in
    //            print("The is an error in fetching Data from Firebase : \(error.localizedDescription)")
    //        }
    //
    //    }
    
    
    fileprivate func setupLogoutButton() {
        
        let confj = UIImage.SymbolConfiguration(pointSize: 23, weight: .bold, scale: .large)
        let image = UIImage(systemName: "gear", withConfiguration: confj)
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action:#selector(handelLogout))
        
        
    }
    @objc func handelLogout() {
        
        let alert = UIAlertController (title: nil, message: nil, preferredStyle: .actionSheet)
        
        let alertLogoutAction = UIAlertAction(title: "Log Out", style: .destructive) { (_) in
            do{
                
                try Auth.auth().signOut()
                let userLogin = LoginUserController()
                self.view.window?.rootViewController = LoginUserController()
                self.present(userLogin, animated: true, completion: nil)
                
            }catch let logoutErr{
                print("There is an in Logout : \(logoutErr)")
            }
        }
        let alertLogoutCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(alertLogoutAction)
        alert.addAction(alertLogoutCancel)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if GridView{
            let width = (view.frame.width - 2) / 3
            return CGSize(width: width, height: width)
        }
        else{
            var height : CGFloat = 56
            height += view.frame.width
            height += 50
            height += 60
            return CGSize(width: view.frame.width, height: height)
        }
    }
    func didSelectList() {
        GridView = false
        collectionView.reloadData()
    }
    
    func didSelectGrid() {
        GridView = true
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderId", for: indexPath) as! UserProfileHeader
        header.backgroundColor = .white
        header.userData = userData
        header.delegate = self
        
        
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 250)
    }
    
    
    
    fileprivate func loadUsername() {
        
        let uid = visitorId ?? (Auth.auth().currentUser?.uid ?? "")
        FirebaseApp.fetchUsetWithUid(id: uid) { (userInfo) in
            self.userData = userInfo
            guard let username = self.userData?.userName else {return}
            self.navigationController?.navigationBar.titleTextAttributes = [ NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 20)]
            self.navigationItem.title = username
            
            self.collectionView.reloadData()
            self.paginationOfUserProfile()
            
        }
        
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postsData.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         counting += 1
       
        if indexPath.item < postsData.count  && !isPaginationFinish {
            
            paginationOfUserProfile()
        }
        
        if GridView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! SharedPostPhoto
            cell.post = postsData[indexPath.item]
            return cell
            
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellListId, for: indexPath) as! HomePageCell
            cell.post = postsData[indexPath.item]
            return cell
        }
    }
    
    
    
}

