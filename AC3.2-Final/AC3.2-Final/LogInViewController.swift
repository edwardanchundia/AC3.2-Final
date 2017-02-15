//
//  LogInViewController.swift
//  AC3.2-Final
//
//  Created by Edward Anchundia on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    var currentUser: User?
    var currenUserId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        setupViewHierarchy()
        configureConstraints()
        
        buttonFunctions()
    }

    func buttonFunctions() {
        loginButton.addTarget(self, action: #selector(tappedLoginButton(sender:)), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(tappedRegisterButton(sender:)), for: .touchUpInside)
    }
    
    internal func tappedLoginButton(sender: UIButton) {
        guard let userName = emailTextField.text, let password = passwordTextField.text else {
            print("cannot validate username/password")
            return
        }

        FIRAuth.auth()?.signIn(withEmail: userName, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error!)
                let alert = UIAlertController(title: "Login Failed", message: "Something is wrong with input. Try Again please", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            if user != nil {
                print("signed in")
                guard let uid = user?.uid else {
                    return
                }
                self.currenUserId = uid
                let feedViewController = FeedTableViewController()
                feedViewController.currentUserUid = self.currenUserId
                let uploadViewController = UploadViewController()
                uploadViewController.userId = self.currenUserId
                
//                let alert = UIAlertController(title: "Login Successful", message: "", preferredStyle: .alert)
//                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alert.addAction(action)
//                self.present(alert, animated: true, completion: nil)
                
                self.dismiss(animated: true, completion: nil)
                
            }
        })
    }
    
    internal func tappedRegisterButton(sender: UIButton) {
        print("Register pressed")
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("cannot validate username/password")
            return
        }

        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            
            if error != nil {
                print("error adding user \(error)")
                return
            }
            
            let changeRequest = FIRAuth.auth()!.currentUser!.profileChangeRequest()
            changeRequest.commitChanges(completion: nil)
        })
    }
    
    func touchedTextField(textField: UITextField) {
        if textField == emailTextField {
            emailTextField.text = ""
            emailTextField.textColor = UIColor.black
        }
        if textField == passwordTextField {
            passwordTextField.text = ""
            passwordTextField.textColor = UIColor.black
        }
    }
    
    func setupViewHierarchy() {
        self.view.addSubview(logo)
        self.view.addSubview(emailTextField)
        self.view.addSubview(passwordTextField)
        self.view.addSubview(loginButton)
        self.view.addSubview(registerButton)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        logo.snp.makeConstraints({ (view) in
            view.centerX.equalToSuperview()
            view.top.equalToSuperview().offset(50)
            view.width.equalToSuperview().multipliedBy(0.5)
            view.height.equalTo(self.view.snp.width).multipliedBy(0.5)
        })
        
        emailTextField.snp.makeConstraints({ (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(logo.snp.bottom).offset(50)
            view.width.equalToSuperview().multipliedBy(0.7)
        })
        
        passwordTextField.snp.makeConstraints({ (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(emailTextField.snp.bottom).offset(30)
            view.width.equalTo(emailTextField.snp.width)
        })
        
        loginButton.snp.makeConstraints({ (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(passwordTextField.snp.bottom).offset(30)
            view.width.equalToSuperview().multipliedBy(0.2)
        })
        
        registerButton.snp.makeConstraints({ (view) in
            view.centerX.equalToSuperview()
            view.top.equalTo(loginButton.snp.bottom).offset(10)
            view.width.equalToSuperview().multipliedBy(0.3)
        })
        
        
    }

    internal lazy var logo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "meatly_logo")
        return imageView
    }()
    
    internal lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        textField.text = "Email..."
        textField.textColor = UIColor(red:0.84, green:0.84, blue:0.86, alpha:1.0)
        textField.addTarget(self, action: #selector(touchedTextField), for: .touchDown)
        return textField
    }()
    
    internal lazy var passwordTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        textField.text = "Password..."
        textField.textColor = UIColor(red:0.84, green:0.84, blue:0.86, alpha:1.0)
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(touchedTextField), for: .touchDown)
        return textField
    }()
    
    internal lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.setTitleColor(UIColor(red:0.00, green:0.51, blue:1.00, alpha:1.0), for: .normal)
        return button
    }()
    
    internal lazy var registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("REGISTER", for: .normal)
        button.setTitleColor(UIColor(red:0.00, green:0.51, blue:1.00, alpha:1.0), for: .normal)
        return button
    }()
    

}
