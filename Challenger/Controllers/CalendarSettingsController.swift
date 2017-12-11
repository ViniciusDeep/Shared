//
//  CalendarSettingsController.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 22/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//
import UIKit
import Foundation
import Firebase
import FirebaseAuth

class CalendarSettingsController: UITableViewController{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var groupImage: UIButton!
    @IBOutlet weak var groupName: UILabel!
    
    @IBOutlet weak var leaveGroupOutlet: UIView!
    @IBOutlet weak var deleteTableViewCell: UITableViewCell!
    
    @IBOutlet weak var RequestTableViewCell: UITableViewCell!
    var group : Group? = nil
    let currentUser = Firebase.Auth.auth().currentUser
    let userRef = Database.database().reference(withPath: "users")
    
    @IBOutlet var settingsTableCalendarView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        groupName.text = group?.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: (group?.image)!)
        imageView.sd_setImage(with: url, completed: nil)
        self.imageView.layer.cornerRadius =
            self.imageView.frame.size.width / 2
        self.imageView.layer.masksToBounds = true
        let currentUserId = currentUser?.uid
        if(userIsAdmin(currentUserId!, group!)){
            RequestTableViewCell.isHidden = false
            deleteTableViewCell.isHidden = false
        }else{
            RequestTableViewCell.isHidden = true
            deleteTableViewCell.isHidden = true
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeimage(_ sender: UIButton) {
        let imagepicker = UIImagePickerController()
        imagepicker.allowsEditing = true
        imagepicker.sourceType = .photoLibrary
        imagepicker.delegate = self
        
        self.present(imagepicker, animated: true, completion: nil)
    }
    func loadMembers() -> [User]{
        var members : [User] = []
        let ref = Database.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let users = snapshot.value as? NSDictionary {
                guard let groupUsers = self.group?.users?.keys else { return }
                guard let allUsers = users as? [String : Any] else { return }
                for user in groupUsers {
                    if let user = User.deserialize(from: allUsers[user] as? NSDictionary) {
                        members.append(user)
                    }
                }
            }
        })
        return members
    }
    
    //Leave Group
    func leaveGroup(_ userID: String, _ group : Group){
        let ref = Database.database().reference()
        ref.child("users").child(userID).child("groups").child(group.key!).removeValue()
        ref.child("group").child(group.key!).child("users").child(userID).removeValue()
        ref.child("group").child(group.key!).child("admin").child(userID).removeValue()
        group.admins?.removeAll()
        if(group.users?.count == 1){
            ref.child("group").child(group.key!).removeValue(completionBlock: { (error, ref) in
                print(error?.localizedDescription)
            })
        }else{
            if(group.admins?.count == 1){
                let members = loadMembers()
                print(members)
                var admins : [String:Bool] = [:]
                let firstUserID = ref.child("users").child(members[0].userID!)
                group.admins = [members[0].userID! : true]
                ref.child("group").child(group.key!).child("admin").setValue([firstUserID:true])
            }
        }
    }
    //remove group
    func removeGroup(){
        let ref = Database.database().reference()
        let members = loadMembers()
        for user in members {
            userRef.child(user.userID!).child("groups").child((group?.key)!).removeValue()
        }
        ref.child("group").child((group?.key!)!).removeValue(completionBlock: { (error, ref) in
            print(error?.localizedDescription)
        })
    }
    func userIsAdmin(_ userID: String, _ group : Group) -> Bool{
        if let admins = group.admins{
            for admin in admins{
                if(userID == admin.key){
                    return true
                }
            }
        }
        
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nav = segue.destination as? UINavigationController else {
            return
        }
        if let controller = nav.topViewController as? CalendarMemberController {
            controller.group = self.group
        }
        if let controller = nav.topViewController as? CalendarInviteController{
            controller.group = self.group
        }
        if let controller = nav.topViewController as? CalendarRequestController {
            controller.group = self.group
        }
    }
}
extension CalendarSettingsController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        //tirar isso dpos
        groupImage.setTitle("", for: UIControlState.normal)
        groupImage.setBackgroundImage(image, for: UIControlState.normal)
        picker.dismiss(animated: true, completion: nil)
        
        
        
    }
}
extension CalendarSettingsController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return CGFloat.leastNormalMagnitude
        }
        return CGFloat.init(3)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else {
            return
    }
        if identifier == "showMembers" {
            performSegue(withIdentifier: "showMembers", sender: nil)
        }
        if identifier == "calendarRequests"{
            performSegue(withIdentifier: "calendarInvites", sender: nil)
        }
        if identifier == "leaveGroup" {
            let currentUserId = currentUser?.uid
            leaveGroup(currentUserId!, group!)
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
        if identifier == "deleteGroup" {
            let currentUserId = currentUser?.uid
            removeGroup()
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}
