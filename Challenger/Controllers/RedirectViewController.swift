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
//        if Auth.auth().currentUser != nil {
//          performSegue(withIdentifier: "userAuthenticated", sender: nil)
//        } else {
//            performSegue(withIdentifier: "userNotAuthenticated", sender: nil)
//        }
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
//        
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user == nil {
//               
//            } else {
//            }
////        if user != nil {
////
////        }else {
////
////        }
//    }
}
}
