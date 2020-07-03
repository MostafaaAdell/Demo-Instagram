//
//  HomePageController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/24/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase

private let cellid = "cellId"

class HomePageController: UICollectionViewController , UICollectionViewDelegateFlowLayout ,HomePageCommentDelegate {
    
    
    var posts = [PostsData]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.collectionView!.register(HomePageCell.self, forCellWithReuseIdentifier: cellid)
        collectionView.backgroundColor = .white
        
        let refreshHomePage = UIRefreshControl()
        refreshHomePage.addTarget(self, action: #selector(handelRefreshHomePage), for: .valueChanged)
        collectionView.refreshControl = refreshHomePage
        NotificationCenter.default.addObserver(self, selector: #selector(handelNewFeedNotification), name: SharePhotoController.updateFeedNotification, object: nil)
        setNavBarSetting()
        loadAllPosts()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        .darkContent
    }
    @objc func handelNewFeedNotification(){
        handelRefreshHomePage()
        
    }
    @objc func handelRefreshHomePage() {
        
        self.posts.removeAll()
        self.loadAllPosts()
        
        
    }
    fileprivate func loadAllPosts(){
        self.fetchPostFromDatabase()
        
        self.fetchPostOfFollowing()
    
        
        
        
    }
    
    
    fileprivate func fetchPostFromDatabase(){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        FirebaseApp.fetchUsetWithUid(id: uid) { (user) in
            self.fetchUserRelatedPost(user : user)
            
        }
        
    }
    
    fileprivate func refreshData() {
        self.posts.sort { (p1, p2) -> Bool in
            return p1.postDate.compare(p2.postDate) == .orderedDescending
        }
        
        self.collectionView?.reloadData()
        
    }
    
    
    
    ///
    fileprivate func fetchPostOfFollowing (){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let ref = Database.database().reference().child("following").child(uid)
        ref.observeSingleEvent(of: .value, with: { (dataSnapShot) in
            guard let otherUsersPost = dataSnapShot.value as? [String : Int] else {
                return
                
            }
            otherUsersPost.forEach { (key,value) in
                FirebaseApp.fetchUsetWithUid(id: key) { (user) in
                    self.fetchUserRelatedPost(user: user)
                }
            }
            
        }) { (error) in
            print("There is an error in fetching the data of other following users Posts \(error.localizedDescription)")
        }
        
        
    }
    fileprivate func fetchUserRelatedPost(user : UserData){
        let ref = Database.database().reference().child("posts").child(user.uid).queryOrdered(byChild: "creationData")
        ref.observeSingleEvent(of: .value, with: { (dataSnapShot) in
            self.collectionView.refreshControl?.endRefreshing()
            
            guard  let dictionaries = dataSnapShot.value as? [String : Any] else {return}
            
            
            dictionaries.forEach { (key,value) in
                
                guard let dic = value as? [String : Any] else {return}
                var post = PostsData(UserData: user, Data: dic )
                post.postId = key
                
                ////logic 2
                guard let userCurrentID = Auth.auth().currentUser?.uid else {return}
                let likeState = Database.database().reference().child("likes").child(key).child(userCurrentID)
                likeState.observeSingleEvent(of: .value, with: { (dataSnap) in
                    
                    
                    
                    
                    if let  likeValue = dataSnap.value as? Int,  likeValue == 1 {
                        post.liked = true
                    }else{
                        post.liked = false
                    }
                    self.posts.insert(post, at: 0)
                  
                         self.refreshData()
                        
                   
                    
                }) { (error) in
                    print("There is an error in retrive Data Of Liked posts : \(error.localizedDescription)")
                    return
                }
                
                
                
            }
            
            
            
            
        }) { (error) in
            print("Ther is an error in fetching the Posts from Database : \(error.localizedDescription)")
        }
        
    }
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height : CGFloat = 56
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
    
    
    fileprivate func setNavBarSetting(){
        
        navigationItem.titleView = UIImageView (image: UIImage(named:"InstagramLogo"))
        
        let symbolConfj = UIImage.SymbolConfiguration(pointSize: 20, weight: .light, scale: .large)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera",withConfiguration: symbolConfj)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handelCamera))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane",withConfiguration: symbolConfj)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handelChat))
               
        
    }
    @objc func handelChat(){
        
    }
    @objc func handelCamera(){
        let cameraController = CameraViewController()
        cameraController.modalPresentationStyle = .fullScreen
        present(cameraController, animated: true, completion: nil)
        //view.window?.rootViewController = cameraController
    }
    
    // MARK: UICollectionViewDataSource
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath) as! HomePageCell
        
        if !posts.isEmpty && posts.count > indexPath.item{
            cell.post = posts[indexPath.item]
            cell.delegate = self
            
        }
        return cell
    }
    func didTapComment(post: PostsData) {
        let commentTap = CustomCommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentTap.post = post
        navigationController?.pushViewController(commentTap, animated: true)
        
    }
    func didLike(for cell: HomePageCell) {
        
        guard let indexPath = collectionView.indexPath(for: cell) else {return}
        
        var post = posts[indexPath.item]
        guard let postId = post.postId else{return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let values = [uid : post.liked == true ? 0 : 1]
        let ref = Database.database().reference().child("likes").child(postId)
        ref.updateChildValues(values) { (error, ref) in
            if let err = error {
                print("There is an error in the data setting in Database : \(err.localizedDescription)")
                return
            }
        }
        
        post.liked = !post.liked
        posts[indexPath.item] = post
        collectionView.reloadItems(at: [indexPath])
        
        
    }
    
}
