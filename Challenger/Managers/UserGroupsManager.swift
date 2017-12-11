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
        database.child("group").child(groupKey).child("users").updateChildValues([userID: true])
    }
    class func addGroupToUser(_ userID: String, _ groupKey : String) {
        var array  : [String] = []
        let database = Database.database().reference()
        database.child("users").child(userID).child("groups").updateChildValues([groupKey : true])
    }
    
    
    
//    class func leaveGroup(_ userID: String, _ group : Group){
//        let ref = Database.database().reference()
//        ref.child("users").child(userID).child("groups").child(group.key!).removeValue()
//        ref.child("group").child(group.key!).child("users").child(userID).removeValue()
//        ref.child("group").child(group.key!).child("admin").child(userID).removeValue()
//        
//        if(group.user?.count == 1){
//            ref.child("group").child(group.key!).removeValue(completionBlock: { (error, ref) in
//                print(error?.localizedDescription)
//            })
//        }else{
//            if(group.admin?.count == 1){
////                let users = loadMembers(group)
//                loadMembers(group, completionHandler: { (members) in
//                    print(members)
//                    var admins : [String] = []
//                    let firstUserID = ref.child("users").child(members[0].userID!).key
//                    admins.append(firstUserID)
//                    ref.child("group").child(group.key!).child("admin").setValue(admins)
//                })
//            }
//        }
//    }
//    class func removeGroup(_ group : Group){
//        let ref = Database.database().reference()
//        let groupRef = ref.child("group").child(group.key!)
//        let userRef = ref.child("user")
//        //var users = loadMembers(group)
////        for user in users {
////            userRef.child(user.userID!).child("groups").child(group.key!).removeValue()
////        }
////        groupRef.removeValue()
//    }
    class func userIsAdmin(_ userID: String, _ group : Group) -> Bool{
        if let admins = group.admin{
            for admin in admins{
                if(userID == admin.key){
                    return true
                }
            }
        }
        
        return false
    }
    
}
