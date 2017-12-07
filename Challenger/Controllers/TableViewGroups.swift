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

class TableViewGroups: UIViewController, DidAddGroup, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    var groups : [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        loadGroups()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddGroup {
            controller.didCreateGroup = self
        }
        guard let nav = segue.destination as? UINavigationController else { return }
        if let controller = nav.topViewController  as? CalendarController {
            guard let index = sender as? Int else { return }
            controller.group = groups[index]
        }
    }
    func didAdd( _ name: String, _ imageKey: String, _ admin: [String], _ users: [String],_ imageURL: String){
        let group = Group()
        group.name = name
        group.key = imageKey
        group.admin = admin
        group.image = imageURL
        group.users = users
        groups.append(group)
        tableView.reloadData()
    }
    func loadGroups() {
        let user = Firebase.Auth.auth().currentUser
        let userRef = Database.database().reference(withPath: "users/" + user!.uid + "/groups")
        let groupsRef = Database.database().reference(withPath: "group" )
        userRef.observeSingleEvent(of: .value) { (snapshot) in
        
            if let arrayGroups = snapshot.value as? NSArray {
                for i in arrayGroups {
                    groupsRef.child(i as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dict = snapshot.value as? NSDictionary {
                            let group = Group.deserialize(from: dict)
                            if let group = group {
                                self.groups.append(group)
                                self.tableView.reloadData()
                            }
                        }
                    })
                }
            }
            
                if let group = snapshot.value as? String {
                    groupsRef.child(group).observeSingleEvent(of: .value, with: { (snapshot) in
                        if let dict = snapshot.value as? NSDictionary{
                            let group =  Group.deserialize(from: dict)
                            if let group = group {
                                self.groups.append(group)
                                self.tableView.reloadData()
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
        groups.removeAll()
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

