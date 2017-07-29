//
//  ClassTableRealm.swift
//  UICPortal
//
//  Created by 高宇超 on 7/21/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import RealmSwift

class ClassTableRealm: Object {
    
    dynamic var user: UserRealm?
    
    dynamic var weekday: String = ""
    dynamic var _8: ClassRealm?
    dynamic var _9: ClassRealm?
    dynamic var _10: ClassRealm?
    dynamic var _11: ClassRealm?
    dynamic var _12: ClassRealm?
    dynamic var _13: ClassRealm?
    dynamic var _14: ClassRealm?
    dynamic var _15: ClassRealm?
    dynamic var _16: ClassRealm?
    dynamic var _17: ClassRealm?
    dynamic var _18: ClassRealm?
    dynamic var _19: ClassRealm?
    dynamic var _20: ClassRealm?
    dynamic var _21: ClassRealm?
    
    dynamic var isOffical: Bool = true
    
    override static func primaryKey() -> String? {
        return "weekday"
    }
    
}
