//
//  Group.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 28/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import HandyJSON

class Group: HandyJSON {
    
    var name: String?
    var image: String?
    var key: String?
    var users: [String]?
    var admin: [String]?
    required init() {}
}
