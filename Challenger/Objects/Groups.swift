//
//  Groups.swift
//  Challenger
//
<<<<<<< HEAD
//  Created by João Luiz dos Santos Albuquerque on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import HandyJSON

struct Groups {
    let name: String
    let imageKey: String?
    let users: [User]?
    let admin: [User]?
    let imageURL: URL
    
    init (name: String, imageKey: String?, admin: [User]?, users: [User]?, imageURL: URL) {
        self.name = name
        self.imageKey = imageKey
        self.users = users
        self.admin = admin
        self.imageURL = imageURL
    }

}


=======
>>>>>>> master
