//
//  SearchViewController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/25/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class SearchViewController: UICollectionViewController ,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{

    
    

    
    lazy var searchBar : UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter Search text"
        sb.barTintColor = UIColor.gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        sb.delegate = self
        return sb
    }()
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredUsers = users
        }else{
            filteredUsers = users.filter({ (user) -> Bool in
                return user.userName.lowercased().contains(searchText.lowercased())
            })
        }
        collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(SearchCellController.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        let navBar = navigationController?.navigationBar
        navBar?.addSubview(searchBar)
        searchBar.Anchor(top: navBar?.topAnchor, bottom: navBar?.bottomAnchor, left: navBar?.leftAnchor, right: navBar?.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 8, paddingRight: -8, width: 0, height: 0)

        // Do any additional setup after loading the view.
        collectionView.alwaysBounceVertical = true
        
        fetchUserData()
        collectionView.keyboardDismissMode = .onDrag
    }
    override func viewWillAppear(_ animated: Bool) {
        searchBar.isHidden = false
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        let userProfile = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        userProfile.visitorId = filteredUsers[indexPath.item].uid
       navigationController?.pushViewController(userProfile,animated:true)
    }
    var filteredUsers = [UserData]()
    var users = [UserData]()
    fileprivate func fetchUserData(){
        
        
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (dataSnapShot) in
            
            guard let dictionaries = dataSnapShot.value as? [String : Any] else{return}
            dictionaries.forEach { (key,value) in
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                guard let dic = value as? [String : Any ] else {return}
                let user = UserData(userId: key, Dictionary: dic)
                self.users.append(user)
            }
            self.users.sort { (u1, u2) -> Bool in
                return u1.userName.compare(u2.userName) == .orderedAscending
            }
            self.filteredUsers = self.users
            self.collectionView.reloadData()
            
        }) { (error) in
            
            print("There is an error in fetching Data from the Database firebase \(error.localizedDescription)")
            
        }
        
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


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: view.frame.width, height: 66)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return filteredUsers.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCellController
        cell.user = filteredUsers[indexPath.item]
        return cell
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
