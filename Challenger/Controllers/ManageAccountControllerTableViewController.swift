//
//  ManageAccountControllerTableViewController.swift
//  Challenger
//
//  Created by Yuri Saboia Felix Frota on 12/12/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class ManageAccountControllerTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    func changeName(){
        let alert = UIAlertController(title: "Change Name?", message: "Type your new name", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.default, handler: {(_) -> Void in
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(_) -> Void in
            guard let text = alert.textFields?.first?.text else {
                return
            }
            
            let ref = Database.database().reference()
            let UserRef = ref.child("users")
            UserRef.child((Auth.auth().currentUser?.uid)!).child("name").setValue(text)
            let alert = UIAlertController(title: "Sucess", message: "Password has been sent to your email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(_) -> Void in
                return
            }))
            self.present(alert, animated: true, completion: nil)
            }))
        }

    func changePassword(){
        
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else {
            return
        }
        if identifier == "changeName" {
            changeName()
        }
        if identifier == "resetPassword"{
            
        }
    }

}
