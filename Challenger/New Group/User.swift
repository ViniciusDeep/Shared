//
//  User.swift
//  Challenger
//
//  Created by Vinicius Mangueira Correia on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//
import HandyJSON


class User : HandyJSON {
    var email: String?
    var groups : [String]?
    
    required init() {
    }
}
