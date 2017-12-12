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
        let database = Database.database().reference()
        database.child("group").child(groupKey).child("users").updateChildValues([userID: true])
    }
    class func addGroupToUser(_ userID: String, _ groupKey : String) {
        let database = Database.database().reference()
        database.child("users").child(userID).child("groups").updateChildValues([groupKey : true])
    }
    
}
