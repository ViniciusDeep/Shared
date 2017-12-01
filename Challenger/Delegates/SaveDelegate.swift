//
//  SaveDelegate.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 14/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import UIKit

protocol DidAddGroup: class {
    func didAdd( _ name: String, _ imageKey: String, _ admin: [String], _ users: [String],_ imageURL: String)
}

