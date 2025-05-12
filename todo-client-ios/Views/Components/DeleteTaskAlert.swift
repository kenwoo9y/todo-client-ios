import SwiftUI

struct DeleteTaskAlert: ViewModifier {
    let task: ToDoTask
    let taskListViewModel: TaskListViewModel
    @Binding var isShowing: Bool
    let onDismiss: () -> Void
    @Environment(\.dismiss) private var dismiss

    func body(content: Content) -> some View {
        content
            .alert("タスクの削除", isPresented: $isShowing) {
                Button("キャンセル", role: .cancel) {
                    onDismiss()
                }
                Button("削除", role: .destructive) {
                    Task {
                        await taskListViewModel.deleteTask(id: task.id)
                        await MainActor.run {
                            dismiss()
                        }
                    }
                }
            } message: {
                Text("以下のタスクを削除しますか？\n\n\(task.title)")
            }
    }
}

extension View {
    func deleteTaskAlert(
        task: ToDoTask,
        taskListViewModel: TaskListViewModel,
        isShowing: Binding<Bool>,
        onDismiss: @escaping () -> Void
    ) -> some View {
        modifier(DeleteTaskAlert(
            task: task,
            taskListViewModel: taskListViewModel,
            isShowing: isShowing,
            onDismiss: onDismiss
        ))
    }
}
