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

class MyAccountController: UIViewController {

    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var logOut: UIButton!
    
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
}
