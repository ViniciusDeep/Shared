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

    
    var members : [User]  = []
    var group : Group? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        members = UserGroupsManager.loadMembers(group!)
        UserGroupsManager.loadMembers(group!) { (members) in
            self.members.append(contentsOf: members)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        if(group?.admin![members[indexPath.row].userID!]) != nil {
            cell.detailTextLabel?.text = "Admin"
        }else{
            cell.detailTextLabel?.text = "Member"
        }
        cell.email.text = members[indexPath.row].name
        if let stringUrl = members[indexPath.row].profileImage {
            cell.imageView?.sd_setImage(with: URL(string: stringUrl), completed: nil)
        }
       return cell
    }
}
