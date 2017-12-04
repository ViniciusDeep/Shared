//
//  CalendarInvitesController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class CalendarInviteController: UIViewController{
    var users : [User] = []
    var result : [User] = []
    var group : Group?
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBarView: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBarView.delegate = self
//        searchTableView.estimatedRowHeight = UITableViewAutomaticDimension
        searchTableView.tableFooterView = UIView()
        loadUsers()
        
    }
    func loadUsers() {
        let usersRef = Database.database().reference().child("users")
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            let snapshots = snapshot.children.allObjects.flatMap { $0 as? DataSnapshot }
            var user = (snapshots.flatMap { User.deserialize(from: $0.value as? NSDictionary) })
            self.users = user
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addGroupToUser(_ user: User) {
        var array  : [String] = []
        let database = Database.database().reference()
        let userRef = database.child("users").child(user.userID!)
        userRef.child("groups").observeSingleEvent(of: .value) { (snapshot) in
            if  let id = snapshot.value as? [String] {
                array = id
                array.append(user.userID!)
                userRef.updateChildValues(["groups" : array as NSArray])
                return
            }
            if let idS = snapshot.value as? String {
                if(snapshot.exists()) {
                    array = [idS]
                    array.append(user.userID!)
                    userRef.updateChildValues(["groups" : array as NSArray])
                }
            } else {
                userRef.updateChildValues(["groups":  user.userID])
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    func addUserToGroup(_ user : User){
        var array  : [String] = []
        let database = Database.database().reference()
        let groupRef = database.child("group").child((group?.key)!)
        groupRef.child("users").observeSingleEvent(of: .value) { (snapshot) in
            if  let id = snapshot.value as? [String] {
                array = id
                array.append(user.userID!)
                groupRef.updateChildValues(["users" : array as NSArray])
                return
            }
            if let idS = snapshot.value as? String {
                if(snapshot.exists()) {
                    array = [idS]
                    array.append(user.userID!)
                    groupRef.updateChildValues(["users" : array as NSArray])
                }
            } else {
                groupRef.updateChildValues(["users":  user.userID])
            }
            self.navigationController?.dismiss(animated: true, completion: nil)
        }

    }
}
extension CalendarInviteController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return result.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCellInvites", for: indexPath) as! UserCellInvites
        cell.email?.text = result[indexPath.row].email
        cell.name.text = result[indexPath.row].name
        if let stringUrl = result[indexPath.row].profileImage {
            cell.imageProfile.sd_setImage(with: URL(string: stringUrl), completed: nil)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addGroupToUser(result[indexPath.row])
        addUserToGroup(result[indexPath.row])
    }
}
extension CalendarInviteController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let matchs = users.filter { (user) -> Bool in
            let name = user.name?.lowercased()
            let search = searchText.lowercased()
            if (name?.contains(search))! {
                return true
            }else {
                return false
            }
        }
        result = matchs
        searchTableView.reloadData()
    }
}

