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
    var allUsers : [User] = []
    var group : Group? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
//        members = UserGroupsManager.loadMembers(group!)
       loadMembers()
    }

    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadMembers() {
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            //            let snapshots = snapshot.children.allObjects.flatMap { $0 as? DataSnapshot }
            //            let keys = snapshots.map { $0.key }
            //            var users = (snapshots.flatMap { User.deserialize(from: $0.value as? NSDictionary) })
            //             print(users)
            if let users = snapshot.value as? NSDictionary {
                guard let groupUsers = self.group?.users?.keys else { return }
                guard let allUsers = users as? [String : Any] else { return }
                for user in groupUsers {
                    if let user = User.deserialize(from: allUsers[user] as? NSDictionary) {
                        self.members.append(user)
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UserCell
        let userID = members[indexPath.row].userID!
        if(group?.admins![userID]) != nil {
            cell.admin.text = "Admin"
        }else{
            cell.admin.text = "Member"
        }
        cell.name.text = members[indexPath.row].name
        if let stringUrl = members[indexPath.row].profileImage {
            cell.profileImage.sd_setImage(with: URL(string: stringUrl), completed: nil)
        }
       return cell
    }
}
