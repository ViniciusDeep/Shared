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

class MyAccountController: UIViewController {

    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var logOut: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = Firebase.Auth.auth().currentUser
        email.text = user?.email
        self.logOut.layer.cornerRadius = self.logOut.frame.size.width / 80
        self.logOut.layer.masksToBounds = true
    }

    @IBAction func logOut(_ sender: Any) {
        try! Firebase.Auth.auth().signOut()
        performSegue(withIdentifier: "Login", sender: nil)
    
    }
}
