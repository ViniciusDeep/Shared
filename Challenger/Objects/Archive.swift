//
//  DateData.swift
//  Challenger
//
//  Created by Yago Saboia Felix Frota on 23/11/17.
//  Copyright © 2017 Vinicius Mangueira Correia. All rights reserved.
//

import Foundation
import HandyJSON
class Archive : HandyJSON{
    
    var archiveID: String?
    var groupID : String?
    var date : Double?
    var name :  String?
    var archive : String?
    var type : String?
    init(name:String?,groupID: String?,date: Double?, archive: String?, type: String?){
        self.name = name
        self.groupID = groupID
        self.date = date
        self.archive = archive
        self.type = type
    }
     required init() {}
    
}
