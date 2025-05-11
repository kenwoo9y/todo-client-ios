import SwiftUI

struct TaskForm: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var dueDate: Date
    @Binding var status: TaskStatus
    @Binding var isShowingDatePicker: Bool
    @Binding var errorMessage: String?
    
    var body: some View {
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
    }
}

#Preview {
    TaskForm(
        title: .constant(""),
        description: .constant(""),
        dueDate: .constant(Date()),
        status: .constant(.todo),
        isShowingDatePicker: .constant(false),
        errorMessage: .constant(nil)
    )
} 