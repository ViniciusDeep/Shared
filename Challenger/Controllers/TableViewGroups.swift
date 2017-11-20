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

class TableViewGroups: UIViewController, DidAddGroup {

    @IBOutlet weak var tableView: UITableView!
    var groups : [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddGroup {
            controller.didCreateGroup = self
        }
    }
    func didAdd(_ nome: String, _ image: UIImageView) {
        let group = Group(name: nome, image: image.image!)
        groups.append(group)
        tableView.reloadData()
    }
}

extension TableViewGroups : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as!  CellGroups
        cell.nameGroup.text = groups[indexPath.row].name
       cell.imageGroup.image = groups[indexPath.row].image
        cell.imageGroup.layer.cornerRadius = cell.imageGroup.frame.size.width / 2
        cell.imageGroup.layer.masksToBounds = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 126
    }
    
    
}

