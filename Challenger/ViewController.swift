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

class ViewController: UIViewController, GIDSignInUIDelegate {
   
    
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var signInButtonGoo: GIDSignInButton!
    
    
    
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        backgroundImage.isOpaque = true
        
    }
    
    
    @IBAction func googleButton(_ sender: Any) {
        ManagerRootViewController.root = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    
    
    
    @IBAction func loginButton(_ sender: Any) {
        
        
        Auth.auth().signIn(withEmail: userEmail.text!, password: userPassword.text!) { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
                
            }else {
                self.performSegue(withIdentifier: "userAuthenticated", sender: sender)
            }
            
        }
        
    }
    
    
    
    
}
