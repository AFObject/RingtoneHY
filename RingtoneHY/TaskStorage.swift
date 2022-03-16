//
//  TaskStorage.swift
//  RingtoneHY
//
//  Created by AFObject on 11/3/22.
//

import SwiftUI

struct Time: Codable, Comparable, Equatable, CustomStringConvertible, Hashable {
    var hour: Int
    var minute: Int
    var music: Int
    
    init(_ string: String) {
        hour = Int(string.prefix(2)) ?? 0
        minute = Int((string as NSString).substring(with: NSMakeRange(2, 2))) ?? 0
        music = Int(string.suffix(1)) ?? 0
    }
    static func < (_ lhs: Time, _ rhs: Time) -> Bool {
        if lhs.hour == rhs.hour {
            if lhs.minute == rhs.minute {
                return lhs.music < rhs.music
            }
            return lhs.minute < rhs.minute
        }
        return lhs.hour < rhs.hour
    }
    static func == (_ lhs: Time, _ rhs: Time) -> Bool {
        return lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.music == rhs.music
    }
    static func timeEqual(_ lhs: Time, _ rhs: Time) -> Bool {
        return lhs.hour == rhs.hour && lhs.minute == rhs.minute
    }
    
    static var now: Time {
        Time(String(format: "%02d%02d%1d", DateManager.hour, DateManager.minute, 0))
    }
    
    var description: String {
        String(format: "%d:%02d ", hour, minute) + .audioName(of: music)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hour)
        hasher.combine(minute)
        hasher.combine(music)
    }
}

struct Task: Codable, Equatable, Hashable {
    var start: Time
    var end: Time
    var name: String
    let id = UUID()
    
    init(_ start: String, _ end: String, _ name: String) {
        self.start = Time(start)
        self.end = Time(end)
        self.name = name
    }
    static func == (lhs: Task, rhs: Task) -> Bool {
        // 大家好，下面这行我边看 A-SOUL 边写成了 lhs.start == lhs.start 调了一整天，一个魂屁用没有，望周知。
        lhs.start == rhs.start && lhs.end == rhs.end && lhs.name == rhs.name
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(start)
        hasher.combine(end)
        hasher.combine(name)
    }
}

struct TaskList: Codable, Equatable {
    var tasks: [Task]
    
    static var empty: TaskList {
        TaskList(tasks: [])
    }
    static func == (lhs: TaskList, rhs: TaskList) -> Bool {
        lhs.tasks == rhs.tasks
    }
}

extension String {
    static let storageKey = "taskStorage"
}

struct TaskStorage: Codable, Equatable {
    var lists: [TaskList]
    
    init(lists: [TaskList]) {
        self.lists = lists
    }
    
    static var shared: TaskStorage {
        return .from(data: UserDefaults.standard.value(forKey: .storageKey) as? Data)
    }
    static var empty: TaskStorage {
        TaskStorage(lists: [])
    }
    static var `default`: TaskStorage {
        let ver1 = TaskList(tasks: [
            Task("07401", "07450", "点名"),
            Task("08001", "08402", "第 1 节课"),
            Task("08501", "09302", "第 2 节课"),
            Task("10003", "10040", "眼保健操"),
            Task("10051", "10452", "第 3 节课"),
            Task("10551", "11352", "第 4 节课"),
            Task("12201", "12352", "午会"),
            Task("12401", "13202", "第 5 节课"),
            Task("13301", "14102", "第 6 节课"),
            Task("14203", "14240", "眼保健操"),
            Task("14251", "15052", "第 7 节课"),
            Task("15151", "15552", "第 8 节课"),
            Task("16051", "16452", "第 9 节课")
        ])
        let ver2 = TaskList(tasks: [
            Task("07401", "07450", "点名"),
            Task("08001", "08402", "第 1 节课"),
            Task("08501", "09302", "第 2 节课"),
            Task("09401", "10202", "第 3 节课"),
            Task("10303", "10340", "眼保健操"),
            Task("10351", "11152", "第 4 节课"),
            Task("11251", "12052", "第 5 节课"),
            Task("12451", "13002", "午会"),
            Task("13101", "13502", "第 6 节课"),
            Task("14001", "14402", "第 7 节课"),
            Task("14503", "14540", "眼保健操"),
            Task("14551", "15352", "第 8 节课"),
            Task("15451", "16252", "第 9 节课")
        ])
        return TaskStorage(lists: [.empty, .empty, ver1, ver1, ver1, ver1, ver2, .empty])
    }
    
    var data: Data {
        return try! JSONEncoder().encode(self)
    }
    
    static func from(data: Data?) -> TaskStorage {
        if let data = data {
            do {
                return try JSONDecoder().decode(TaskStorage.self, from: data)
            } catch {
                print(error)
            }
        }
        return .default
    }
    
    static func == (lhs: TaskStorage, rhs: TaskStorage) -> Bool {
        lhs.lists == rhs.lists
    }
}
