//
//  RealmHelper.swift
//  UICPortal
//
//  Created by 高宇超 on 7/21/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import RealmSwift

class RealmHelper {

    
    // MARK: - User
    static func addUser(_ user: UserRealm) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(user)
        }
    }

    static func updatePassword(_ user: UserRealm, newPassword password: String, last: Bool = true) {
        let realm = try! Realm()
        try! realm.write {
            user.password = password
            user.last = true
        }
    }
    
    static func updateStu(_ user: UserRealm, last: Bool = true, name: String, stuID: String, nameEng: String, program: String, address: String, birthDate: Date, mobilePhone: String, homePhone: String, postcode: String, idCardNo: String, photoData: Data) {
        let realm = try! Realm()
        try! realm.write {
            user.name = name
            user.stuID = stuID
            user.nameEng = nameEng
            user.program = program
            user.address = address
            user.birthDate = birthDate
            user.mobilePhone = mobilePhone
            user.homePhone = homePhone
            user.postcode = postcode
            user.idCardNo = idCardNo
            user.last = true
            user.photoData = photoData
        }
    }
    
    static func updateGender(_ user: UserRealm, _ gender: String) {
        let realm = try! Realm()
        try! realm.write {
            user.gender = gender
        }
    }
    
    static func logoutLastUser(_ user: UserRealm) {
        let realm = try! Realm()
        try! realm.write {
            user.last = false
        }
    }
    
    static func retrieveLastUser() -> UserRealm? {
        let realm = try! Realm()
        return realm.objects(UserRealm.self).filter("#last = true").first
    }
    
    static func retrieveUser(byUsername username: String) -> UserRealm? {
        let realm = try! Realm()
        return realm.object(ofType: UserRealm.self, forPrimaryKey: username)
    }
    
    // MARK: - Class
    static func addClass(_ classToAdd: ClassTableRealm) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(classToAdd)
        }
    }
    
}
