//
//  Date+Extension.swift
//  UICPortal
//
//  Created by 高宇超 on 7/23/17.
//  Copyright © 2017 Yuchao. All rights reserved.
//

import Foundation

extension Date {
    
    func daysBetweenFromDate(toDate: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: self, to: toDate).day ?? 0
    }
    
    func secondsBetweenFromDate(toDate: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: self, to: toDate).second ?? 0
    }
    
}
