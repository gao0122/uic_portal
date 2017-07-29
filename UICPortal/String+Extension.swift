//
//  String+Extension.swift
//  UICPortal
//
//  Created by 高宇超 on 7/17/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import Foundation

extension String {

    // parse html
    func percentEncoding() -> String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
    }

    // substring
    func substring(from: Int, to: Int) -> String {
        if to > characters.count || from >= to { return "" }
        let fromIndex = self.index(startIndex, offsetBy: from)
        let toIndex = self.index(startIndex, offsetBy: to + 1)
        return substring(with: fromIndex..<toIndex)
    }

    
    static let portalURL = "http://mis.uic.edu.hk/"
    static let mainURL = "http://mis.uic.edu.hk/portal/student/index.do"
    static let misURL = "http://mis.uic.edu.hk/mis/usr/index.do"
    static let timetableURL = "http://mis.uic.edu.hk/mis/student/tts/timetable.do"
    static let iSpaceURL = "https://ispace.uic.edu.hk/my/"
    static let lrcURL = "http://mis.uic.edu.hk/wrc/student/wrcIndex.do"
    static let meURL = "http://mis.uic.edu.hk/si/student/index.do"
    static let photoURL = "http://mis.uic.edu.hk/si/student/getAvatar.do"
    static let gradeReportURL = "http://mis.uic.edu.hk/mis/student/ssm/gradepublish/report.do"
    
    static let logoutURL = "http://mis.uic.edu.hk/mis/logout.sec"
    static let loggedOut = "login_error"
    
    static let monday = "Monday"
    static let tuesday = "Tuesday"
    static let wednesday = "Wednesday"
    static let thursday = "Thursday"
    static let friday = "Friday"
    static let saturday = "Saturday"
    static let sunday = "Sunday"
    
    // html class name in me profile page
    static let sidClassMe = "studentid"
    static let nameClassMe = "name"
    static let programClassMe = "programme"
    static let otherClassMe = "other"
}
