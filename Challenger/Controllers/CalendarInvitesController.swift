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
    var members : [User] = []
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
        loadMembersGroup()
    }
    func loadUsers() {
        let usersRef = Database.database().reference().child("users")
        usersRef.observeSingleEvent(of: .value) { (snapshot) in
            let snapshots = snapshot.children.allObjects.flatMap { $0 as? DataSnapshot }
            let user = (snapshots.flatMap { User.deserialize(from: $0.value as? NSDictionary) })
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
    func loadMembersGroup(){
        let ref = Database.database().reference()
        let userRef = Database.database().reference()
        ref.child("group").child((group?.key)!).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            //            let snapshots = snapshot.children.allObjects.flatMap { $0 as? DataSnapshot }
            //            let keys = snapshots.map { $0.key }
            //            var users = (snapshots.flatMap { User.deserialize(from: $0.value as? NSDictionary) })
            //             print(users)
            if let users = snapshot.value as? NSArray {
                for user in users {
                    userRef.child("users").child(user as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dict = snapshot.value as? NSDictionary else { return }
                        let user = User.deserialize(from: dict)
                        self.members.append(user!)
                    })
                }
            }
        })
    }
    func isAMember(_ user: User) -> Bool {
        for users in members {
            if user.userID ==  users.userID {
                return true
            }
        }
        
        return false
        
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
        cell.imageProfile.layer.cornerRadius = cell.imageProfile.frame.size.width / 2
        cell.imageProfile.layer.masksToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserGroupsManager.addGroupToUser(result[indexPath.row].userID!, (group?.key!)!)
        UserGroupsManager.addUserToGroup(result[indexPath.row].userID!, (group?.key!)!)
        group?.users![result[indexPath.row].userID!] = true
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}
extension CalendarInviteController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let matchs = users.filter { (user) -> Bool in
            let name = user.name?.lowercased()
            let search = searchText.lowercased()
            if ((name?.contains(search))! && (!isAMember(user))) {
                return true
            }else {
                return false
            }
        }
        result = matchs
        searchTableView.reloadData()
    }
}

