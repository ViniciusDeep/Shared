//
//  SingUpViewController.swift
//  Challenger
//
//  Created by Vinicius Mangueira Correia on 13/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseStorage


class SingUpViewController: UIViewController {
    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userName: UITextField!
    var imageUrl : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //saveButton.isEnabled = false
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2;
        self.imgProfile.layer.masksToBounds = true
        
    }
    
    
    @IBAction func imgSelected(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func BackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBAction func signButton(_ sender: Any) {
        guard let email = userEmail.text, let password = userPassword.text else {
            print("form is not valid")
            return
        }
        guard let name = userName.text else {
            return
        }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            guard let user = user else {
                return print("Usuário inexiste")
            }
            if error != nil {
                return print(error?.localizedDescription ?? "Empty")
            }
            let ref = Database.database().reference()
            let usersReference = ref.child("users")
            let uid = user.uid
            guard let email = user.email else {
                return print("Email inexiste")
            }
            let dict = ["userID" : uid, "email" : email, "name" : name, "profileImage" : self.imageUrl]
            usersReference.child(uid).updateChildValues(dict, withCompletionBlock: { (error, reference) in
                if let error = error {
                    print(error.localizedDescription)
                }
                print("Usuário salvo")
            })
            Auth.auth().signIn(withEmail: "fsfs", password: "fdfsf", completion: { (user, error) in
                
            })
        }
        
        //successfully autheticated
        
        
        //
        //        let values = ["email": email]
        //        ref.onDisconnectUpdateChildValues(values) { (err, ref) in
        //            if err != nil {
        //                print(err)
        //                return
        //            }
        //            print("Saved user sucessfully into the FIREBASE DB")
        //        }
        //
        //        usersReference.childByAutoId().setValue(values)
        self.dismiss(animated: true, completion: nil)
    }
}


extension SingUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagesFilesManager = FilesManager()
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let imagesFilesManager = FilesManager()
            imagesFilesManager.uploadImage(image, completionBlock: { (url,id, error) in
                print(url?.absoluteString)
                self.imageUrl = url?.absoluteString
            })
            imgProfile.image = image
            //saveButton.isEnabled = true
            picker.dismiss(animated: true, completion: nil)
//
//        let image = info[UIImagePickerControllerEditedImage] as? UIImage
//
//        imgProfile.image = image
//        picker.dismiss(animated: true, completion: nil)
//
        }
    }
}
