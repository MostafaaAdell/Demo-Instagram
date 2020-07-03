//
//  ViewController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/21/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase

class SignupUserController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextFieldDelegate{
    
    
    let backgraoundImage : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "backgroundImage")
        return imageView
        
        
    }()
    
    let titleLogo : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Billabong", size: 80)
        label.text = "Instagram"
        label.textAlignment = .center
        label.textColor = .white
        return label
        
    }()
    let desLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        label.text = "Sign up to see photos and videos of your friends"
        label.textAlignment = .center
        return label
    }()
    
    let addPlusButton : UIButton = {
        let aB = UIButton(type: .system)
        let iconImage = UIImage(named: "addingPhoto")
        let tintedIconImage = iconImage?.withRenderingMode(.alwaysTemplate)
        aB.setImage(tintedIconImage , for: .normal)
        aB.tintColor = .black
        aB.layer.cornerRadius = 5
        aB.addTarget(self, action: #selector(handelAddPhoto), for: .touchUpInside)
        return aB
        
    }()
    @objc func handelAddPhoto (){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage{
            addPlusButton.setImage(image.withRenderingMode(.alwaysOriginal) , for: .normal)
        }else if let image = info[.originalImage] as? UIImage {
            
            addPlusButton.setImage(image.withRenderingMode(.alwaysOriginal) , for: .normal)
        }
        addPlusButton.layer.cornerRadius = addPlusButton.frame.width/2
        addPlusButton.layer.masksToBounds = true
        addPlusButton.layer.borderColor = UIColor.black.cgColor
        addPlusButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
        
    }
    
    let emailTextfield : UITextField = {
        let et = UITextField()
        et.borderStyle = .roundedRect
        et.font = UIFont.systemFont(ofSize: 16)
        et.textColor = .white
        et.attributedPlaceholder = NSAttributedString (string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        et.backgroundColor = UIColor(white: 0, alpha: 0.3)
        et.addTarget(self, action: #selector(handelDataInput), for: .editingChanged)
        return et
        
    }()
    @objc func handelDataInput(){
        let formalData = emailTextfield.text?.count ?? 0 > 0 && userTextfield.text?.count ?? 0 > 0 && passwordTextfield.text?.count ?? 0 > 0
        if formalData {
            
            signupButton.isEnabled = true
            signupButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 273)
        }else{
            
            signupButton.isEnabled = false
            signupButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    let userTextfield : UITextField = {
        let et = UITextField()
        et.borderStyle = .roundedRect
        et.font = UIFont.systemFont(ofSize: 16)
        et.textColor = .white
        et.attributedPlaceholder = NSAttributedString (string: "Username", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        et.backgroundColor = UIColor(white: 0, alpha: 0.3)
        et.addTarget(self, action: #selector(handelDataInput), for: .editingChanged)
        
        return et
        
    }()
    let passwordTextfield : UITextField = {
        let et = UITextField()
        et.borderStyle = .roundedRect
        et.font = UIFont.systemFont(ofSize: 16)
        et.textColor = .white
        et.attributedPlaceholder = NSAttributedString (string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        et.backgroundColor = UIColor(white: 0, alpha: 0.3)
        et.isSecureTextEntry = false
        
        et.addTarget(self, action: #selector(handelDataInput), for: .editingChanged)
        
        return et
        
    }()
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == self.passwordTextfield ) {
               self.passwordTextfield.isSecureTextEntry = true;
           }
           
           return true;
    }
    
    let signupButton : UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.setTitle("Sign up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handelSignup), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc func handelSignup(){
        guard let email = emailTextfield.text , email.count > 0  else {return}
        guard let username = userTextfield.text , username.count > 0 else {return}
        guard let password = passwordTextfield.text ,password.count > 0 else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (response, error) in
            if let e = error{
                print("There is an error an Creation of the email \(e.localizedDescription)")
            }
            
            guard let image = self.addPlusButton.imageView?.image else {return}
            guard let imageFormat = image.jpegData(compressionQuality: 0.3) else {return}
            let filename = NSUUID().uuidString
            
            
            
            let storageRef = Storage.storage().reference()
            
            
            // Create a reference to the file you want to upload
            let riversRef = storageRef.child("Profile_Images").child(filename)
            
            // Upload the file to the path "images/rivers.jpg"
            let _ = riversRef.putData(imageFormat, metadata: nil) { (metadata, error) in
                if let e = error{
                    print("There is an error here \(e.localizedDescription)")
                }
                // Metadata contains file metadata such as size, content-type.
                riversRef.downloadURL { (url, error) in
                    
                    if let err = error{
                        print ("There is an error in the url \(err.localizedDescription)")
                    }
                    guard let downloadURL = url else {return}
                    
                    let imageUrl = downloadURL.absoluteString
                    guard let userId = response?.user.uid else {return}
                    let user = ["Username":username , "Profile_Image":imageUrl]
                    let userInfo = [userId:user]
                    Database.database().reference().child("users").updateChildValues(userInfo) { (error, DatabaseReference) in
                        if let errr = error {
                            print("There is an error here \(errr.localizedDescription)")
                        }
                        let userLogin = MainTabBarController()
                        self.view.window?.rootViewController = MainTabBarController()
                        self.present(userLogin, animated: true, completion: nil)
                    }
                    
                    
                }
            }
           
            
            
            
        }
    }
    
    let logintButton : UIButton = {
        let button = UIButton (type: .system)
        let textAttr = NSMutableAttributedString(string: "Already have Account  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor : UIColor.white])
        textAttr.append(NSMutableAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(textAttr, for: .normal)
        button.addTarget(self, action: #selector(handelLogin), for: .touchUpInside)
        return button
    }()
    @objc func handelLogin(){
        
        self.view.window?.rootViewController = LoginUserController()
        navigationController?.popViewController(animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextfield.delegate = self
        view.addSubview(backgraoundImage)
        view.addSubview(titleLogo)
        view.addSubview(desLabel)
        view.addSubview(addPlusButton)
        backgraoundImage.Anchor(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 0)
        
        titleLogo.Anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 40, paddingBottom: 0, paddingLeft: 60, paddingRight: -60, width: 0, height: 105)
        desLabel.Anchor(top: titleLogo.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 10, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 70)
        addPlusButton.Anchor(top: desLabel.bottomAnchor, bottom: nil, left: nil, right: nil, paddingTop: 20, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 140, height: 140)
        addPlusButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadDataStack ()
        view.addSubview(logintButton)
        logintButton.Anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        
    }
    
    
    func loadDataStack () {
        
        let userDataStack = UIStackView(arrangedSubviews: [emailTextfield,userTextfield,passwordTextfield])
        userDataStack.distribution = .fillEqually
        userDataStack.spacing = 15
        userDataStack.axis = .vertical
        view.addSubview(userDataStack)
        userDataStack.Anchor(top: addPlusButton.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 180)
        view.addSubview(signupButton)
        signupButton.Anchor(top: userDataStack.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 70, paddingBottom: 0, paddingLeft: 100, paddingRight: -100, width: 0, height: 70)
        
    }
    
}



