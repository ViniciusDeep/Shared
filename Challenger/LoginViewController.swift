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

class LoginViewController: UIViewController, GIDSignInUIDelegate, UITextFieldDelegate {
   
    
    
    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var userPassword: UITextField!
    
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        userPassword.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.signUpBtn.layer.cornerRadius =
            self.signUpBtn.frame.size.width / 10
        self.signUpBtn.layer.masksToBounds = true
        self.loginBtn.layer.cornerRadius =
            self.loginBtn.frame.size.width / 10
        self.loginBtn.layer.masksToBounds = true
    }
    
    @IBAction func googleButton(_ sender: Any) {
        ManagerRootViewController.root = self
        GIDSignIn.sharedInstance().signIn()
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userPassword.resignFirstResponder()
        loginButton(userPassword)
        return true
    }
    
    @IBAction func forgotPass(_ sender: Any) {
        let alert = UIAlertController(title: "Forgot Password?", message: "Type your email", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default, handler: {(_) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(_) -> Void in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            Auth.auth().sendPasswordReset(withEmail: text) { error in
                if error == nil {
                    let alert = UIAlertController(title: "Sucess", message: "Password has been sent to your email", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(_) -> Void in
                       return
                    }))
                    self.present(alert, animated: true, completion: nil)
                }else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(_) -> Void in
                       return
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
}
