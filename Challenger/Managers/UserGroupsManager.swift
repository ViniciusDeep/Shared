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
    class func addUserToGroup(_ userID : String, _ groupKey : String){
        var array  = [String : Bool]()
        let database = Database.database().reference()
        let groupRef = database.child("group").child(groupKey)
        groupRef.child("users").updateChildValues([userID: true])
//        groupRef.child("users").observeSingleEvent(of: .value) { (snapshot) in
//            if  let id = snapshot.value as? [String] {
//                let user = [id : true]
//
//                groupRef.updateChildValues(["users" : user])
//                return
//            } else {
//                groupRef.updateChildValues(["users":  userID])
//            }
    }
    class func addGroupToUser(_ userID: String, _ groupKey : String) {
        var array  : [String] = []
        let database = Database.database().reference()
        let userRef = database.child("users").child(userID)
        userRef.child("groups").updateChildValues([groupKey : true])
//        userRef.child("groups").observeSingleEvent(of: .value) { (snapshot) in
//            if  let id = snapshot.value as? [String] {
//                array = id
//                array.append(groupKey)
//                userRef.updateChildValues(["groups" : array as NSArray])
//                return
//            }
//            if let idS = snapshot.value as? String {
//                if(snapshot.exists()) {
//                    array = [idS]
//                    array.append(groupKey)
//                    userRef.updateChildValues(["groups" : array as NSArray])
//                }
//            } else {
//                userRef.updateChildValues(["groups":  groupKey])
//            }
//        }
        
    }
    
    
    
    class func leaveGroup(_ userID: String, _ group : Group){
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
//                let users = loadMembers(group)
                loadMembers(group, completionHandler: { (members) in
                    print(members)
                    var admins : [String] = []
                    let firstUserID = ref.child("users").child(members[0].userID!).key
                    admins.append(firstUserID)
                    ref.child("group").child(group.key!).child("admin").setValue(admins)
                })
            }
        }
    }
    class func removeGroup(_ group : Group){
        let ref = Database.database().reference()
        let groupRef = ref.child("group").child(group.key!)
        let userRef = ref.child("user")
        //var users = loadMembers(group)
//        for user in users {
//            userRef.child(user.userID!).child("groups").child(group.key!).removeValue()
//        }
//        groupRef.removeValue()
    }
    class func loadMembers(_ group : Group, completionHandler: @escaping ([User]) -> Void) {
        let ref = Database.database().reference()
        let userRef = Database.database().reference(withPath: "users")
        let groupsRef = Database.database().reference(withPath: "group" + group.key! + "/users")
        var members : [User] = []
        ref.child("group").child((group.key)!).child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            let dataSnapshot = snapshot.children.allObjects as! [DataSnapshot]
            dataSnapshot.forEach({
                userRef.child($0.key).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dict = snapshot.value as? NSDictionary {
                        let user = User.deserialize(from: dict)
                        if let user = user {
                            members.append(user)
                        }
                    }
                })
            })
            completionHandler(members)
//            if let users = snapshot.value as? NSDictionary {
//                for user in users {
//                    userRef.child("users").child(user as! String).observeSingleEvent(of: .value, with: { (snapshot) in
//                        guard let dict = snapshot.value as? NSDictionary else { return }
//                        let user = User.deserialize(from: dict)
//                        members.append(user!)
//                    })
//                }
//            }
        })
    }
    class func userIsAdmin(_ userID: String, _ group : Group) -> Bool{
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
