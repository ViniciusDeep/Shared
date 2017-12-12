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
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    var image : UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
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
    saveButton.isEnabled = false
    cancelButton.isEnabled = false
        if userEmail.text == "" {
            self.saveButton.isEnabled = true
            self.cancelButton.isEnabled = true
            return
        }
        if userPassword.text == "" {
            self.saveButton.isEnabled = true
            self.cancelButton.isEnabled = true
            return
        }
        if  userName.text == "" {
            self.saveButton.isEnabled = true
            self.cancelButton.isEnabled = true
            return
        }
        guard let email = userEmail.text, let password = userPassword.text, let name = userName.text else {
            self.saveButton.isEnabled = true
            self.cancelButton.isEnabled = true
            return
        }
        let imagesFilesManager = FilesManager()
        var imageUrl : String?
        imagesFilesManager.uploadImage(imgProfile.image!, completionBlock: { (url,id, error) in
            print(url?.absoluteString)
            imageUrl = url?.absoluteString
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                if let error = error {
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) -> Void in
                        self.saveButton.isEnabled = true
                        self.cancelButton.isEnabled = true
                        return}))
                    self.present(alert, animated: true, completion: nil)
                }
                guard let user = user else {
                    self.saveButton.isEnabled = true
                    self.cancelButton.isEnabled = true
                    return
                }
                if error != nil {
                    self.saveButton.isEnabled = true
                    self.cancelButton.isEnabled = true
                    return print(error?.localizedDescription ?? "Empty")
                }
                let ref = Database.database().reference()
                let usersReference = ref.child("users")
                let uid = user.uid
                guard let email = user.email else {
                    self.saveButton.isEnabled = true
                    self.cancelButton.isEnabled = true
                    return
                }
                let dict = ["userID" : uid, "email" : email, "name" : name, "profileImage" : imageUrl]
                usersReference.child(uid).updateChildValues(dict, withCompletionBlock: { (error, reference) in
                    if let error = error {
                        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) -> Void in return}))
                        self.present(alert, animated: true, completion: nil)
                        self.saveButton.isEnabled = true
                        self.cancelButton.isEnabled = true
                    } else {
                   
                    Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(_) -> Void in
                                self.saveButton.isEnabled = true
                                self.cancelButton.isEnabled = true
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            return
                        }else {
                            self.performSegue(withIdentifier: "userAuthenticated", sender: sender)
                        }
                    }
                    
                    }})
            }
        })
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}


extension SingUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            imgProfile.image = image
            self.image = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
