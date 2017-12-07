//
//  MyAccountController.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 21/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage
import FirebaseDatabase
import FirebaseStorage


class MyAccountController: UIViewController {

    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logOut: UIButton!
    var imageUrl: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let database = Database.database().reference()
        let user = Firebase.Auth.auth().currentUser
        database.child("users").child(user!.uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let result = snapshot.value as? NSDictionary else { return }
            guard let userInfo = User.deserialize(from: result) else { return }
            guard let stringURL = userInfo.profileImage else { return }
            DispatchQueue.main.async {
                self.profileImage.sd_setImage(with: URL(string: stringURL), completed: nil)
            }
            self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width / 2
            self.profileImage.layer.masksToBounds = true
        }
        
        email.text = user?.email
        
        //let url = URL(_ string : user)
        //profileImage
        //let url = URL(string: archives[indexPath.row].archive!)
        self.logOut.layer.cornerRadius = self.logOut.frame.size.width / 80
        self.logOut.layer.masksToBounds = true
    }

    @IBAction func logOut(_ sender: Any) {
        try! Firebase.Auth.auth().signOut()
        performSegue(withIdentifier: "Login", sender: nil)
    
    }
    
    @IBAction func changeImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}


extension MyAccountController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let imagesFilesManager = FilesManager()
        
    
        
        
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            let imagesFilesManager = FilesManager()
            imagesFilesManager.uploadImage(image, completionBlock: { (url,id, error) in
                print(url?.absoluteString)
                self.imageUrl = (url?.absoluteString)!
            })
            
            
            
            profileImage.image = image
            
            picker.dismiss(animated: true, completion: nil)
            
        }
    }
}


