import SwiftUI

struct TaskDetailView: View {
    let task: ToDoTask
    @Environment(\.dismiss)
    private var dismiss
    @ObservedObject var taskListViewModel: TaskListViewModel
    @State private var isShowingDeleteAlert = false

    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Text("項目")
                    .frame(width: 100, alignment: .leading)
                    .font(.headline)
                Text("内容")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.headline)
            }
            .padding()
            .background(Color.gray.opacity(0.1))

            // テーブル内容
            ScrollView {
                VStack(spacing: 0) {
                    DetailRow(title: "タイトル", value: task.title)
                    DetailRow(title: "詳細", value: task.description)
                    DetailRow(title: "期日", value: task.dueDate)
                    DetailRow(title: "ステータス", value: task.status.rawValue)
                    DetailRow(title: "作成日時", value: formattedCreatedAt)
                    DetailRow(title: "更新日時", value: formattedUpdatedAt)
                }
            }

            // 削除ボタン
            Button {
                isShowingDeleteAlert = true
            } label: {
                Text("タスクを削除")
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    taskListViewModel.swipedTaskId = nil
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .accessibilityLabel("戻る")
                        Text("戻る")
                    }
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    TaskUpdateView(task: task, taskListViewModel: taskListViewModel)
                } label: {
                    Text("編集")
                }
            }
        }
        .deleteTaskAlert(
            task: task,
            taskListViewModel: taskListViewModel,
            isShowing: $isShowingDeleteAlert,
            onDismiss: {
                dismiss()
            }
        )
    }

    private var formattedCreatedAt: String {
        DateUtils.formatDateTime(task.createdAt)
    }

    private var formattedUpdatedAt: String {
        DateUtils.formatDateTime(task.updatedAt)
    }
}

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .frame(width: 100, alignment: .leading)
                .foregroundColor(.gray)
            Text(value)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
        .background(Color.white)
        Divider()
    }
}

#Preview {
    TaskDetailView(task: ToDoTask(
        id: 1,
        title: "Task1",
        description: "Description1",
        dueDate: "2025-05-06",
        status: .doing,
        ownerId: 1,
        createdAt: "2025-05-06T16:02:00",
        updatedAt: "2025-05-06T16:02:00"
    ), taskListViewModel: TaskListViewModel())
}
