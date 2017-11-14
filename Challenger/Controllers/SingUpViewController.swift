//
//  SingUpViewController.swift
//  Challenger
//
//  Created by Vinicius Mangueira Correia on 13/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit

class SingUpViewController: UIViewController {

   
    
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    

    @IBAction func BackButton(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
        }
    
    
    @IBAction func signButton(_ sender: Any) {
   
    
    }
    
    
    
}
