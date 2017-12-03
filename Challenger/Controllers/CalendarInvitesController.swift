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
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBarView: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBarView.delegate = self
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
    
    @IBAction func done(_ sender: Any) {
    }
    
}
extension CalendarInviteController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return result.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InviteCell", for: indexPath)
        cell.textLabel?.text = result[indexPath.row].name
        return cell
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

