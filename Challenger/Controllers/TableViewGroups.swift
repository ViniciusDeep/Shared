//
//  TableViewGroups.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 16/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase
import SDWebImage
import HandyJSON

class TableViewGroups: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var groups : [Group] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    let user = Firebase.Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddGroup {
            //controller.didCreateGroup = self
        }
        guard let nav = segue.destination as? UINavigationController else { return }
        if let controller = nav.topViewController  as? CalendarController {
            guard let index = sender as? Int else { return }
            controller.group = groups[index]
        }
    }
//    func didAdd( _ name: String, _ imageKey: String, _ admin: String, _ users: String,_ imageURL: String){
//        let group = Group()
//        group.name = name
//        group.key = imageKey
//        group.admins = [admin: true]
//        group.image = imageURL
//        group.users = [users: true]
//        groups.append(group)
//        tableView.reloadData()
//    }
    func loadGroups() {
        let user = Firebase.Auth.auth().currentUser
        guard let uid = user?.uid else {
            return
        }
       let userRef = Database.database().reference(withPath: "users/" + uid + "/groups")
        let groupsRef = Database.database().reference(withPath: "group" )
        userRef.observeSingleEvent(of: .value) { (snapshot) in
            let dataSnapshot = snapshot.children.allObjects as! [DataSnapshot]
            self.groups.removeAll()
            dataSnapshot.forEach {
                groupsRef.child($0.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? NSDictionary {
                        let group = Group.deserialize(from: dict)
                        if let group = group {
                            self.groups.append(group)
                        }
                    }
                })
            }
        }
     }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
   
    @IBAction func reloadButton(_ sender: Any) {
        loadGroups()
    }
    override func viewWillAppear(_ animated: Bool) {
        loadGroups()
    }
}

extension TableViewGroups : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as!  CellGroups
        cell.nameGroup.text = groups[indexPath.row].name
        let url = URL(string: groups[indexPath.row].image!)
        cell.imageGroup.sd_setImage(with: url, completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "groupSelected", sender: indexPath.row)
    }
}

