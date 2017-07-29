//
//  ClassRealm.swift
//  UICPortal
//
//  Created by 高宇超 on 7/21/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import RealmSwift

class ClassRealm: Object {
    
    dynamic var id: String = ""
    dynamic var title: String = ""
    dynamic var teacher: String = ""
    dynamic var classroom: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
