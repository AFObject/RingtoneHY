//
//  TaskListView.swift
//  RingtoneHY
//
//  Created by AFObject on 12/3/22.
//

import SwiftUI

protocol TaskViewManager {
    func remove(task: Task)
}

struct TaskView: View {
    @Binding var task: Task
    var manager: TaskViewManager
    @State private var editing = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(task.name)
                    .font(.system(size: 16, weight: .bold))
                Spacer()
                Button(action: requestRemoval) {
                    Image(systemName: "trash.fill")
                }
                Button(action: edit) {
                    Image(systemName: "slider.horizontal.3")
                }
            }.padding([.leading, .top, .trailing])
                .buttonStyle(.borderless)
            VStack(alignment: .leading) {
                Text(task.start.description)
                Text(task.end.description)
            }.padding([.leading])
                .padding([.top], 6)
        }.frame(width: 155, height: 100, alignment: .topLeading)
            .background(Color(red: 88 / 255, green: 86 / 255, blue: 214 / 255))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .shadow(radius: 3)
            .sheet(isPresented: $editing) {
                TaskEditView(task: $task)
            }
    }
    
    func edit() {
        editing = true
    }
    func requestRemoval() {
        manager.remove(task: task)
    }
}

struct TimeEditView: View {
    var label: String
    @Binding var time: Time
    var body: some View {
        HStack {
            DatePicker(label, selection:
                Binding(get: {
                    Calendar.current.date(from: DateComponents(hour: time.hour, minute: time.minute))!
                }, set: { date in
                    let components = Calendar.current.dateComponents([.hour, .minute], from: date)
                    time.hour = components.hour!
                    time.minute = components.minute!
                }), displayedComponents: .hourAndMinute
            )
            Picker("??????", selection: $time.music) {
                ForEach(0...3, id: \.self) { i in
                    Text(verbatim: .audioName(of: i)).tag(i)
                }
            }
        }
    }
}

struct TaskEditView: View {
    @Binding var task: Task
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            TextField("????????????", text: $task.name)
            TimeEditView(label: "????????????", time: $task.start)
            TimeEditView(label: "????????????", time: $task.end)
            Spacer()
            HStack {
                Spacer()
                Button("??????") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }.frame(width: 300, height: 120).padding()
    }
}

struct TaskListView: View, TaskViewManager {
    @Binding var taskList: TaskList
    @State private var newTask: Task = Task("08001", "08402", "?????????")
    @State private var editing = false
    
    let rows = Array(repeating: GridItem(), count: 3)
    var body: some View {
        LazyVGrid(columns: rows) {
            ForEach($taskList.tasks) { i in
                TaskView(task: i, manager: self)
            }
            Button(action: addItem) {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 45, height: 45)
                    
            }.frame(width: 155, height: 100)
                .background(Color(white: 50, opacity: 0.2))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .buttonStyle(.borderless)
                .shadow(radius: 3)
        }.frame(width: 500, alignment: .leading)
            .sheet(isPresented: $editing, onDismiss: {
                taskList.tasks.append(newTask)
                newTask = Task("08001", "08402", "?????????")
            }) {
                TaskEditView(task: $newTask)
            }
    }
    
    func addItem() {
        editing = true
    }
    func remove(task: Task) {
        if let index = taskList.tasks.firstIndex(of: task) {
            taskList.tasks.remove(at: index)
        }
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView(taskList: .constant(TaskStorage.default.lists[2]))
    }
}
