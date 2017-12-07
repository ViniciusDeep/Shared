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
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure to ACCEPT this request?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(alert) -> Void in return}))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {alert in
            self.addGroupToUser(index: index)
            self.addUserToGroup(index: index)
            self.removeInvite(index: index)
            self.users.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: UITableViewRowAnimation.fade)
            self.tableView.reloadData()
        }))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    func didTapReject(index: IndexPath) {
        let alert = UIAlertController(title: "Confirmation", message: "Are you sure to REJECT this request?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: {(alert) -> Void in return}))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {alert in self.removeInvite(index: index)
            self.users.remove(at: index.row)
            self.tableView.deleteRows(at: [index], with: UITableViewRowAnimation.fade)
            self.tableView.reloadData()
            
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func addGroupToUser (index: IndexPath) {
        let user = users[index.row]
        if user.groups == nil {
            user.groups = [(group?.key)!]
        } else {
            var array = user.groups
            array?.append((group?.key)!)
            user.groups = array
        }
        let json = user.toJSON()
        Firebase.Database.database().reference(withPath: "users").child(user.userID!).updateChildValues(json!)
    }
    
    func addUserToGroup(index: IndexPath) {
        guard var arrayUsers = group?.users else {
            group?.users = [users[index.row].userID!]
            let json = group?.toJSON()
            Firebase.Database.database().reference(withPath: "group").child((group?.key)!).updateChildValues(json!)
            return
        }
        arrayUsers.append(users[index.row].userID!)
        group?.users = arrayUsers
        let json = group?.toJSON()
        Firebase.Database.database().reference(withPath: "group").child((group?.key)!).updateChildValues(json!)
    }
    
    func removeInvite(index: IndexPath) {
        
        group?.invites = group?.invites?.filter({ (invite) -> Bool in
            if (invite == users[index.row].userID) {
                return false
            }else {
                return true
            }
        })
        let json = group?.toJSON()
        Firebase.Database.database().reference(withPath: "group").child((group?.key)!).setValue(json!)
        
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
