//
//  ViewController.swift
//  RingtoneHY
//
//  Created by AFObject on 11/3/22.
//

import AVFoundation
import SwiftUI

fileprivate var audioPlayer: AVAudioPlayer?

extension AVAudioPlayer {
    class func ring(type: Int) {
        let path = Bundle.main.path(forResource: "\(type)", ofType: "mp3")
        let url = URL(fileURLWithPath: path!)
        audioPlayer = try? AVAudioPlayer(contentsOf: url)
        audioPlayer?.volume = 0.5
        audioPlayer?.play()
    }
}

extension String {
    static func audioName(of index: Int) -> Self {
        let names = ["无铃声", "上课铃", "下课铃", "眼保健操音乐"]
        return names[index]
    }
    static func weekdayName(of day: Int) -> Self {
        let names = ["", "日", "一", "二", "三", "四", "五", "六"]
        return names[day]
    }
}

class ViewController: NSViewController, NSUserNotificationCenterDelegate {
    
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var timeLabel: NSTextField!
    @IBOutlet weak var taskLabel: NSTextField!
    var settingsController: NSViewController?
    
    private var queue: [(Time, String, Bool)] = []
    private var storedWeekday = -1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UserDefaults.standard.setValue(TaskStorage.default.data, forKey: .storageKey)
        initializeQueue()
        updateTime()

        let timer = Timer(timeInterval: 2.0, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: .default)
    }
    
    @objc func updateTime() {
        dateLabel.stringValue = "\(DateManager.month) 月 \(DateManager.day) 日 / 周\(String.weekdayName(of: DateManager.weekday))"
        timeLabel.stringValue = String(format: "%d:%02d", DateManager.hour, DateManager.minute)
        
        if DateManager.weekday != storedWeekday {
            initializeQueue()
        }
        
        if let current = queue.first {
            if Time.timeEqual(current.0, .now) {
                AVAudioPlayer.ring(type: current.0.music)
                queue.removeFirst()
            }
        }
        if let current = queue.first {
            taskLabel.stringValue = "下一个日程：\(current.1)\(current.2 ? "开始" : "结束")"
        } else {
            taskLabel.stringValue = "今日无其他日程"
        }
    }
    
    private func initializeQueue() {
        storedWeekday = DateManager.weekday
        let list = TaskStorage.shared.lists[DateManager.weekday]
        queue = []
        for i in list.tasks {
            if i.start.music > 0 && i.start > .now {
                queue.append((i.start, i.name, true))
            }
            if i.end.music > 0 && i.end > .now {
                queue.append((i.end, i.name, false))
            }
        }
        queue.sort(by: { lhs, rhs in
            lhs.0 < rhs.0
        })
    }
    
    @IBAction func showSettings(_ sender: Any?) {
        settingsController = NSHostingController(rootView: SettingsView(onCompletion: {
            self.settingsController?.dismiss(nil)
            self.initializeQueue()
        }))
        self.presentAsSheet(settingsController!)
    }
    
}
