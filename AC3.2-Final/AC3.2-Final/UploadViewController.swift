//
//  UploadViewController.swift
//  AC3.2-Final
//
//  Created by Edward Anchundia on 2/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var databaseReference: FIRDatabaseReference!
    var user: FIRUser?
    var userId: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        setupViewHierarchy()
        configureConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(uploadButtonPressed))
        
        self.databaseReference = FIRDatabase.database().reference().child("posts")
        
        let user = FIRAuth.auth()?.currentUser
        let id = user?.uid
        self.userId = id
    }
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.uploadImageView.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    func uploadButtonPressed() {
        let linkRef = self.databaseReference.childByAutoId()
        let storageRef = FIRStorage.storage().reference().child("images/\(linkRef.key)")
        
        if let uploadData = UIImageJPEGRepresentation(self.uploadImageView.image!, 0.5) {
            
            let metadata = FIRStorageMetadata()
            metadata.cacheControl = "public,max-age=300";
            metadata.contentType = "image/jpeg";
            
            storageRef.put(uploadData, metadata: metadata, completion: { (metadata, error) in
                
                if error != nil {
                    print(error!.localizedDescription)
                    let alert = UIAlertController(title: "Login Failed", message: "Something is wrong with input. Try Again please", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            })
        }
        
        guard let id = userId else {
            return
        }
        
        let link = Photo(key: linkRef.key, userId: id, comment: self.commentTextView.text)
        let dict = link.asDictionary
        
        //put in the databse
        linkRef.setValue(dict) { (error, reference) in
            if let error = error {
                print(error)
            } else {
                print(reference)
                self.tabBarController?.selectedIndex = 0
            }
        }
        
        
    }

    
    
    func setupViewHierarchy()  {
        self.view.addSubview(uploadImageView)
        self.view.addSubview(commentTextView)
    }
    
    private func configureConstraints() {
        self.edgesForExtendedLayout = []
        
        uploadImageView.snp.makeConstraints({ (view) in
            view.top.equalToSuperview()
            view.width.equalToSuperview()
            view.height.equalTo(self.view.snp.width).multipliedBy(0.9)
        })
        
        commentTextView.snp.makeConstraints({ (view) in
            view.top.equalTo(uploadImageView.snp.bottom).offset(5)
            view.width.equalToSuperview().multipliedBy(0.95)
            view.bottom.equalToSuperview().inset(35)
            view.centerX.equalToSuperview()
        })
    }
    
    internal lazy var uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "placeholder")
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    internal lazy var commentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Add a description.."
        textView.textColor = UIColor.lightGray
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.black.cgColor
        
        return textView
    }()

}
