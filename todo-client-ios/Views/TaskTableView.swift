import SwiftUI

struct TaskTableView: View {
    @ObservedObject var taskListViewModel: TaskListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Text("タイトル")
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("期日")
                    .frame(width: 100)
                Text("ステータス")
                    .frame(width: 80)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            
            // タスク一覧
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(taskListViewModel.tasks) { task in
                        NavigationLink(destination: TaskDetailView(task: task)) {
                            HStack {
                                Text(task.title)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(task.dueDate)
                                    .frame(width: 100)
                                Text(task.status.rawValue)
                                    .frame(width: 80)
                            }
                            .padding()
                            .background(Color.white)
                        }
                        Divider()
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        TaskTableView(taskListViewModel: TaskListViewModel())
    }
} 