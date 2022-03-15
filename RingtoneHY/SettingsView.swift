//
//  SettingsView.swift
//  RingtoneHY
//
//  Created by AFObject on 12/3/22.
//

import SwiftUI

extension NSNotification.Name {
    static let didChangeSettingsNotification = NSNotification.Name("RingtoneHYDidChangeSettingsNotification")
}

struct SettingsView: View {
    var onCompletion: () -> () = {}
    @State private var taskStorage: TaskStorage = .default
    
    var body: some View {
        VStack {
            ScrollView {
                Form {
                    ForEach(1...7, id: \.self) { i in
                        Section("周" + .weekdayName(of: i)) {
                            TaskListView(taskList: $taskStorage.lists[i])
                        }
                        Divider()
                    }
                }.padding()
            }.frame(width: 540, height: 360)
                .onAppear {
                    taskStorage = .shared
                }
                .onChange(of: taskStorage) { newValue in
                    UserDefaults.standard.set(taskStorage.data, forKey: .storageKey)
                }
            HStack {
                Spacer()
                Button("完成") {
                    onCompletion()
                }
            }.padding()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
