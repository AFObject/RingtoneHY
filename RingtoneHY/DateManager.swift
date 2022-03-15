//
//  DateManager.swift
//  RingtoneHY
//
//  Created by AFObject on 11/3/22.
//

import Cocoa

struct DateManager {
    static var month: Int {
        let components = Calendar.current.dateComponents([.month], from: Date())
        return components.month!
    }
    static var day: Int {
        let components = Calendar.current.dateComponents([.day], from: Date())
        return components.day!
    }
    static var weekday: Int {
        let components = Calendar.current.dateComponents([.weekday], from: Date())
        return components.weekday!
    }
    static var hour: Int {
        let components = Calendar.current.dateComponents([.hour], from: Date())
        return components.hour!
    }
    static var minute: Int {
        let components = Calendar.current.dateComponents([.minute], from: Date())
        return components.minute!
    }
    static var second: Int {
        let components = Calendar.current.dateComponents([.second], from: Date())
        return components.second!
    }
}
