//
//  UserManager.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 06/12/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class UserGroupsManager : NSObject {
    func leaveGroup(_ userID: String, _ group : Group){
        let ref = Database.database().reference()
        ref.child("users").child(userID).child("groups").child(group.key!).removeValue()
        ref.child("group").child(group.key!).child("users").child(userID).removeValue()
        ref.child("group").child(group.key!).child("admin").child(userID).removeValue()
        
        if(group.users?.count == 1){
            ref.child("group").child(group.key!).removeValue(completionBlock: { (error, ref) in
                print(error?.localizedDescription)
            })
        }else{
            if(group.admin?.count == 1){
                let users = loadMembers(group)
                var admins : [String] = []
                let firstUserID = ref.child("users").child(users[0].userID!).key
                admins.append(firstUserID)
                ref.child("group").child(group.key!).child("admin").setValue(admins)
            }
        }
    }
    func removeGroup(_ group : Group){
        let ref = Database.database().reference()
        let groupRef = ref.child("group").child(group.key!)
        let userRef = ref.child("user")
        var users = loadMembers(group)
        for user in users {
            userRef.child(user.userID!).child("groups").child(group.key!).removeValue()
        }
        groupRef.removeValue()
    }
    func loadMembers(_ group : Group) -> [User] {
        let ref = Database.database().reference()
        let userRef = Database.database().reference()
        var members : [User] = []
        ref.child("group").child((group.key)!).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let users = snapshot.value as? NSArray {
                for user in users {
                    userRef.child("users").child(user as! String).observeSingleEvent(of: .value, with: { (snapshot) in
                        guard let dict = snapshot.value as? NSDictionary else { return }
                        let user = User.deserialize(from: dict)
                        members.append(user!)
                    })
                }
            }
        })
        return members
    }
    func userIsAdmin(_ userID: String, _ group : Group) -> Bool{
        if let admins = group.admin{
            for admin in admins{
                if(userID == admin){
                    return true
                }
            }
        }
        
        return false
    }
}
