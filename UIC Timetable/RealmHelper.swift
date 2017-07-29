//
//  RealmHelper.swift
//  UICPortal
//
//  Created by 高宇超 on 7/24/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import RealmSwift

class RealmHelper {

    static func retrieveLastUser() -> UserRealm? {
        let realm = try! Realm()
        return realm.objects(UserRealm.self).filter("#last = true").first
    }
    
    
}
