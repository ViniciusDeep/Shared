//
//  CalendarMemberController.swift
//  Challenger
//
//  Created by Vinicius Mangueira Correia on 01/12/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseDatabase

class CalendarMemberController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }


    
    
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func loadUser() {
        
        
        
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

   

}
