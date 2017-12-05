//
//  ViewController.swift
//  Challenger
//IDSignInButton
//  Created by Vinicius Mangueira Correia on 13/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import GoogleSignIn

class ViewController: UIViewController, GIDSignInDelegate {
    
    
    

    
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var signInButtonGoo: GIDSignInButton!
    
    
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImage.isOpaque = true
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    
    
    @IBAction func googleButton(_ sender: Any) {
   
    }
    

    
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }

    
    
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        
        Auth.auth().signIn(withEmail: userEmail.text!, password: userPassword.text!) { (user, error) in
            if error != nil {
                
                return
                
            }else {
                self.performSegue(withIdentifier: "userAuthenticated", sender: sender)
            }
            
        }
        
    }
    
}
