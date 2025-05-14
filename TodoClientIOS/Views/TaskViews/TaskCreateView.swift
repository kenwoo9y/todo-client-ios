import SwiftUI

struct TaskCreateView: View {
    @Environment(\.dismiss)
    private var dismiss
    @ObservedObject var taskListViewModel: TaskListViewModel
    @State private var title = ""
    @State private var description = ""
    @State private var dueDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var status: TaskStatus = .todo
    @State private var ownerId = 1
    @State private var isShowingDatePicker = false
    @State private var isSaving = false
    @State private var errorMessage: String?

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func saveTask() async {
        isSaving = true
        errorMessage = nil

        do {
            _ = try await NetworkService.shared.createTask(
                NetworkService.TaskCreateRequest(
                    title: title,
                    description: description,
                    status: status,
                    dueDate: dueDate,
                    ownerId: ownerId
                )
            )
            await MainActor.run {
                taskListViewModel.refreshTasks()
                dismiss()
            }
        } catch {
            await MainActor.run {
                errorMessage = "タスクの作成に失敗しました。"
            }
        }

        await MainActor.run {
            isSaving = false
        }
    }

    var body: some View {
        NavigationStack {
            TaskForm(
                title: $title,
                description: $description,
                dueDate: $dueDate,
                status: $status,
                isShowingDatePicker: $isShowingDatePicker,
                errorMessage: $errorMessage
            )
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
                        Task {
                            await saveTask()
                        }
                    }
                    .disabled(!isFormValid || isSaving)
                }
            }
        }
    }
}

#Preview {
    TaskCreateView(taskListViewModel: TaskListViewModel())
}
