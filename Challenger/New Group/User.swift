//
//  User.swift
//  Challenger
//
//  Created by Vinicius Mangueira Correia on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//
import HandyJSON
class User : HandyJSON {
    var userID: String?
    var name: String?
    var email: String?
    var profileImage: String?
    var groups : [String]?
    var pendingInvitations : [String]?
    required init() {
    }
}
