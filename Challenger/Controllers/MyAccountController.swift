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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func logOut(_ sender: Any) {
        try! Firebase.Auth.auth().signOut()
        performSegue(withIdentifier: "Login", sender: nil)
    
    }
}
