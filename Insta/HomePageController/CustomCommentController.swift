//
//  CustomCommentController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/28/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class CustomCommentController: UICollectionViewController  ,UICollectionViewDelegateFlowLayout , CustomCommentViewDelegate {
    
    
    var post: PostsData?
    let placeholderText = " Enter Comment"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        navigationItem.title =  "Comments"
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0)
        // Register cell classes
        self.collectionView!.register(CustomCommentCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        loadCommentData()
        
        
        
        // Do any additional setup after loading the view.
    }
    var comments = [Comment]()
    fileprivate func loadCommentData(){
        guard let postId = post?.postId else{return}
        let ref = Database.database().reference().child("comments").child(postId)
        ref.observe(.childAdded, with: { (dataSnap) in
            guard let dictionaries = dataSnap.value as? [String: Any] else {return }
            guard let uid = dictionaries["userId"] as? String else {return}
            FirebaseApp.fetchUsetWithUid(id: uid) { (user) in
                let comment = Comment(user: user, dic: dictionaries)
                self.comments.append(comment)
                self.collectionView.reloadData()
            }
            
        }) { (error) in
            print("There is an error in load the Data from Database : \(error.localizedDescription)")
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    lazy var containerView : CustomCommentView = {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 60)
        let customView = CustomCommentView(frame: frame)
        customView.delegate = self
        
        return customView
        
    }()
    
    func didSubmitComment(for comment: String) {
        guard let uid = Auth.auth().currentUser?.uid else{ return}
        
        guard let actualPostId = post?.postId else{return}
        let values = ["text" : comment , "creationDate" : Date().timeIntervalSince1970 , "userId" : uid] as [String : Any]
        let ref = Database.database().reference().child("comments").child(actualPostId).childByAutoId()
        ref.updateChildValues(values) { (error, ref) in
            if let error = error {
                print("There is an error in inserting comment : \(error.localizedDescription)")
                return
            }
            self.containerView.clearDataNotNeeded()
        }
    }
    
    
    
    
    
    override var inputAccessoryView: CustomCommentView?{
        
        return containerView
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CustomCommentCell
        
        cell.comment = comments[indexPath.item]
        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect (x: 0, y: 0, width: view.frame.width, height: 56)
        let commentCell = CustomCommentCell(frame: frame)
        commentCell.comment = comments[indexPath.item]
        commentCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatingSize = commentCell.systemLayoutSizeFitting(targetSize)
        let height = max(56,estimatingSize.height)
        return CGSize (width: view.frame.width, height: height)
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}
