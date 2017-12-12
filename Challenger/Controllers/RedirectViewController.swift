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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidAppear(_ animated: Bool) {
        verifyIfSessionExists()
    }
    func verifyIfSessionExists() {
        guard let currentUser =  Auth.auth().currentUser else {
            self.performSegue(withIdentifier: "userNotAuthenticated", sender: nil)
            return
        }
        currentUser.reload(completion: { (error) in
            if error != nil {
                try! Firebase.Auth.auth().signOut()
                let storyboard = UIStoryboard(name: "Cadastro", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "ViewController")
                self.present(controller, animated: true, completion: nil)
            }else {
                self.performSegue(withIdentifier: "userAuthenticated", sender: nil)
            }
        })
}
}
