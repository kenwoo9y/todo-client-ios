import SwiftUI

struct TaskUpdateView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var taskListViewModel: TaskListViewModel
    let task: ToDoTask
    
    @State private var title: String
    @State private var description: String
    @State private var dueDate: Date
    @State private var status: TaskStatus
    @State private var ownerId: Int
    @State private var isShowingDatePicker = false
    @State private var isSaving = false
    @State private var errorMessage: String?
    
    init(task: ToDoTask, taskListViewModel: TaskListViewModel) {
        self.task = task
        self.taskListViewModel = taskListViewModel
        
        // 日付文字列をDate型に変換
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        let date = dateFormatter.date(from: task.dueDate) ?? Date()
        
        _title = State(initialValue: task.title)
        _description = State(initialValue: task.description)
        _dueDate = State(initialValue: date)
        _status = State(initialValue: task.status)
        _ownerId = State(initialValue: task.ownerId)
    }
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func updateTask() async {
        isSaving = true
        errorMessage = nil
        
        do {
            _ = try await NetworkService.shared.updateTask(
                id: task.id,
                title: title,
                description: description,
                status: status,
                dueDate: dueDate,
                ownerId: ownerId
            )
            await MainActor.run {
                taskListViewModel.refreshTasks()
                dismiss()
            }
        } catch {
            await MainActor.run {
                errorMessage = "タスクの更新に失敗しました。"
            }
        }
        
        await MainActor.run {
            isSaving = false
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("タイトル *")) {
                    TextField("タイトル", text: $title)
                        .textInputAutocapitalization(.never)
                }
                
                Section(header: Text("詳細")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                
                Section(header: Text("期日")) {
                    Button(action: {
                        isShowingDatePicker.toggle()
                    }) {
                        HStack {
                            Text("期日")
                            Spacer()
                            Text(dueDate.formatted(date: .long, time: .omitted))
                                .foregroundColor(.gray)
                        }
                    }
                    if isShowingDatePicker {
                        DatePicker("", selection: $dueDate, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .padding(.vertical, 8)
                    }
                }
                
                Section(header: Text("ステータス *")) {
                    Picker("ステータス", selection: $status) {
                        ForEach(TaskStatus.allCases, id: \.self) { status in
                            Text(status.rawValue).tag(status)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                if let errorMessage = errorMessage {
                    Section {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("タスク更新")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("更新") {
                        Task {
                            await updateTask()
                        }
                    }
                    .disabled(!isFormValid || isSaving)
                }
            }
        }
    }
}

#Preview {
    TaskUpdateView(
        task: ToDoTask(
            id: 1,
            title: "Task1",
            description: "Description1",
            dueDate: "2025-05-06",
            status: .doing,
            ownerId: 1,
            createdAt: "2025-05-06T16:02:00",
            updatedAt: "2025-05-06T16:02:00"
        ),
        taskListViewModel: TaskListViewModel()
    )
} 