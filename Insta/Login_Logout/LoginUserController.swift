//
//  LoginUserController.swift
//  Insta
//
//  Created by Mostafa Adel on 6/22/20.
//  Copyright © 2020 Mostafa Adel. All rights reserved.
//

import UIKit
import Firebase

class LoginUserController: UIViewController , UITextFieldDelegate {
    
    let backgroundView : UIImageView = {
        
        let imageView = UIImageView()
        
        let image = UIImage(named: "backgroundImage")
        imageView.image = image
        let label = UILabel()
        label.font = UIFont(name: "Billabong", size: 80)
        label.textColor = .white
        label.text = "Instagram"
        label.textAlignment = .center
        imageView.addSubview(label)
        label.Anchor(top: nil, bottom: nil, left: nil, right: nil, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 300, height: 120)
        label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        return imageView
        
    }()
    let emailTextfield : UITextField = {
        let et = UITextField()
        et.borderStyle = .roundedRect
        et.font = UIFont.systemFont(ofSize: 16)
        et.textColor = .black
        et.attributedPlaceholder = NSAttributedString (string: "Email", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        et.backgroundColor = UIColor(white: 0, alpha: 0.03)
        et.addTarget(self, action: #selector(handelDataInput), for: .editingChanged)
        return et
        
    }()
    let passwordTextfield : UITextField = {
        let et = UITextField()
        et.borderStyle = .roundedRect
        et.font = UIFont.systemFont(ofSize: 16)
        et.textColor = .black
        et.attributedPlaceholder = NSAttributedString (string: "Password", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        et.backgroundColor = UIColor(white: 0, alpha: 0.03)
        et.isSecureTextEntry = false
        
        et.addTarget(self, action: #selector(handelDataInput), for: .editingChanged)
        
        return et
        
    }()
    
    @objc func handelDataInput(){
        let formalData = emailTextfield.text?.count ?? 0 > 0 &&  passwordTextfield.text?.count ?? 0 > 0
        if formalData {
            
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 273)
        }else{
            
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    let loginButton : UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 10
        button.setTitle("login", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handelLoginData), for: .touchUpInside)
        
        return button
        
    }()
    @objc func handelLoginData() {
        
        guard let email = emailTextfield.text else {return}
        guard let password = passwordTextfield.text else {return}
        Auth.auth().signIn(withEmail: email, password: password) { (response, error) in
            if let e = error {
                print("There is an error in Logging in : \(e.localizedDescription)")
                    return
            }
            let mainTabBar = MainTabBarController()
            //let navBarr = SettingOfStatusBar(rootViewController: mainTabBar)
            self.view.window?.rootViewController = mainTabBar
            self.present(mainTabBar, animated: true, completion: nil)
            
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == passwordTextfield && !passwordTextfield.isSecureTextEntry){
            passwordTextfield.isSecureTextEntry = true
        }
        return true
    }
    let signuptButton : UIButton = {
        let button = UIButton (type: .system)
        let textAttr = NSMutableAttributedString(string: "Don't have Account?  ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        textAttr.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16),NSAttributedString.Key.foregroundColor : UIColor.rgb(red: 17, green: 154, blue: 237)]))
        button.setAttributedTitle(textAttr, for: .normal)
        button.addTarget(self, action: #selector(handelSignup), for: .touchUpInside)
        return button
    }()
    @objc func handelSignup(){
        
        let signupView = SignupUserController()
        self.view.window?.rootViewController = SignupUserController()
        
        // present(signupView, animated: true, completion: nil)
        navigationController?.pushViewController(signupView, animated: true)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        passwordTextfield.delegate = self
        
        view.addSubview(signuptButton)
        signuptButton.Anchor(top: nil, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: -10, paddingLeft: 0, paddingRight: 0, width: 0, height: 50)
        
        view.addSubview(backgroundView)
        backgroundView.Anchor(top: view.topAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 0, paddingBottom: 0, paddingLeft: 0, paddingRight: 0, width: 0, height: 300)
        
        handelInputData()
    }
    fileprivate func handelInputData(){
        
        let stackView = UIStackView(arrangedSubviews:[emailTextfield,passwordTextfield])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 15
        view.addSubview(stackView)
        stackView.Anchor(top: backgroundView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 80, paddingBottom: 0, paddingLeft: 40, paddingRight: -40, width: 0, height: 115)
        
        view.addSubview(loginButton)
        loginButton.Anchor(top: stackView.bottomAnchor, bottom: nil, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 50, paddingBottom: 0, paddingLeft: 100, paddingRight: -100, width: 0, height: 70)
        
        
    }
    
    
}
