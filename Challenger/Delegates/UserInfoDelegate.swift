//
//  UserInfoDelegate.swift
//  Challenger
//
//  Created by João Luiz dos Santos Albuquerque on 20/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//
import UIKit
import FirebaseAuth

protocol UserInfoDelegate {
   func didLogin (user: User)
}
