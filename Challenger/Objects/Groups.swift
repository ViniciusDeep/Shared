//
//  Groups.swift
//  Challenger
//
//  Created by Vinicius Mangueira Correia on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation

class Groups {
    
    let nome: String
    let image: String
    let Users: [User]
    
    
    init (nome: String, image: String, Users: [User]) {
        self.nome = nome
        self.image = image
        self.Users = Users
    }
    
    
    
}
