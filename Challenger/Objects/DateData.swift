//
//  DateData.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation

class DateData {
    let date : Data
    var images : Data
    var archives : Data
    
    init(date: Data, images: Data, archives: Data){
        self.date = date
        self.images = images
        self.archives = archives
    }
}
