//
//  UserRealm.swift
//  UICPortal
//
//  Created by 高宇超 on 7/21/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import RealmSwift

class UserRealm: Object {
    
    dynamic var avID: String = ""
    
    dynamic var username: String = ""
    dynamic var password: String = ""
    dynamic var last = false
    
    dynamic var gender: String = ""
    dynamic var stuID: String = ""
    dynamic var name: String = ""
    dynamic var nameEng: String = ""
    dynamic var program: String = ""
    dynamic var birthDate: Date?
    dynamic var idCardNo: String = ""
    dynamic var mobilePhone: String = ""
    dynamic var homePhone: String = ""
    dynamic var address: String = ""
    dynamic var postcode: String = ""
    dynamic var photoData: Data?
    
    override static func primaryKey() -> String? {
        return "username"
    }
    
}
