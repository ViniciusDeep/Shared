//
//  RedirectViewController.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 22/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class RedirectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(_ animated: Bool) {
        verifyIfSessionExists()
    }
    func verifyIfSessionExists() {
        let user = Firebase.Auth.auth().currentUser
        if user != nil {
            performSegue(withIdentifier: "userAuthenticated", sender: nil)
        }else {
            performSegue(withIdentifier: "userNotAuthenticated", sender: nil)
        }
    }
}
