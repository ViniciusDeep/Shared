//
//  Groups.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation

class Groups {
    
    let name: String
    let image: String
    let users: [User]
    let admin: [User]
    
    
    init (name: String, image: String, admin: [User], users: [User]) {
        self.name = name
        self.image = image
        self.users = users
        self.admin = admin
    }
    
    
    
}
