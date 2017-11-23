//
//  User.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation


class User {
    let email: String
    let password: String
    let image: Data
    let id: String
    
    init(email: String, password: String, image: Data, id: String) {
        self.email = email
        self.image = image
        self.password = password
        self.id = id
    }
    
    
}
