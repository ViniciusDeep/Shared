//
//  CalendarRequestsController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class CalendarRequestController: UITableViewController{
    var users : [User] = []
    var group : Group?
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    func loadUsers() {
        let groupRef = Database.database().reference(withPath: "group").child((group?.key)!).child("invites")
        groupRef.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                return
            }
            guard let users = snapshot.value as? NSArray else{
                return
            }
            let usersRef = Database.database().reference()
            for user in users {
                usersRef.child("users").child(user as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                    guard let dict = snapshot.value as? NSDictionary else { return }
                    let user = User.deserialize(from: dict)
                    self.users.append(user!)
                    self.tableView.reloadData()
                })
            }
            
        }
        
    }
    
}

extension CalendarRequestController: CellDelegate {
    func didTapAccept(index: IndexPath) {
        let user = users[index.row]
        if user.groups == nil {
            user.groups = [(group?.key)!]
        }
        else if (user.groups?.isEmpty)! {
            user.groups = [(group?.key)!]
        } else {
            var array = user.groups
            array?.append((group?.key)!)
            user.groups = array
        }
        let json = user.toJSON()
        Firebase.Database.database().reference(withPath: "users").child(user.userID!).updateChildValues(json!)
        
    }
    func didTapReject(index: IndexPath) {
        
    }
    
    
}
extension CalendarRequestController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "requestCell", for: indexPath) as! RequestsCell
        let url = URL(string: users[indexPath.row].profileImage!)
        cell.profileImage.sd_setImage(with: url, completed: nil)
        cell.name.text = users[indexPath.row].name
        cell.email.text = users[indexPath.row].email
        cell.indexPath = indexPath
        cell.delegateCell = self
        return cell
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}
