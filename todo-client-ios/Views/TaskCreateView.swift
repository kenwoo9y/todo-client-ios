import SwiftUI

struct TaskCreateView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var dueDate: Date = Date()
    @State private var status: TaskStatus = .todo
    @State private var isShowingDatePicker = false
    
    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
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
            }
            .navigationTitle("新規タスク作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("保存") {
                        // TODO: タスクの保存処理を実装
                        dismiss()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
}

#Preview {
    TaskCreateView()
} 