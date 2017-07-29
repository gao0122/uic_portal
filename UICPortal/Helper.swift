//
//  Helper.swift
//  UICPortal
//
//  Created by 高宇超 on 7/20/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import UIKit
import SystemConfiguration

enum LoginState {
    case loggedOut, loggedIn, loggingIn, loggingOut, checking
}

enum Action {
    case none, login, logout, check, updateMe, updateTimetable
}


// true for student, false for teacher
func checkIsStudentOrTeacher(withUsername username: String) -> Bool {
    return (Int(username.substring(from: 1, to: username.characters.count - 1)) != nil) && username.components(separatedBy: CharacterSet.lowercaseLetters).count == 2
}

// print
func printit(_ any: Any) {
    print("--------------------------------------------")
    print(any)
    print("--------------------------------------------")
    
}

// check if is connected to the network
func connectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}


