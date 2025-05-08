import SwiftUI

struct TaskTableView: View {
    @ObservedObject var taskListViewModel: TaskListViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // ヘッダー
            HStack {
                Button(action: { taskListViewModel.sort(by: .title) }) {
                    HStack {
                        Text("タイトル")
                        if taskListViewModel.sortKey == .title {
                            Image(systemName: taskListViewModel.sortOrder == .ascending ? "chevron.up" : "chevron.down")
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: { taskListViewModel.sort(by: .dueDate) }) {
                    HStack {
                        Text("期日")
                        if taskListViewModel.sortKey == .dueDate {
                            Image(systemName: taskListViewModel.sortOrder == .ascending ? "chevron.up" : "chevron.down")
                        }
                    }
                }
                .frame(width: 100)
                
                Button(action: { taskListViewModel.sort(by: .status) }) {
                    HStack {
                        Text("ステータス")
                        if taskListViewModel.sortKey == .status {
                            Image(systemName: taskListViewModel.sortOrder == .ascending ? "chevron.up" : "chevron.down")
                        }
                    }
                }
                .frame(width: 80)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            
            // タスク一覧
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(taskListViewModel.tasks) { task in
                        TaskRow(task: task, taskListViewModel: taskListViewModel)
                    }
                    
                    if taskListViewModel.isLoading {
                        ProgressView()
                            .padding()
                    }
                }
            }
        }
    }
}

struct TaskRow: View {
    let task: ToDoTask
    @ObservedObject var taskListViewModel: TaskListViewModel
    
    var body: some View {
        NavigationLink {
            TaskDetailView(task: task)
        } label: {
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
            .onAppear {
                taskListViewModel.loadMoreIfNeeded(currentItem: task)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .background(Color.white)
        if task.id != taskListViewModel.tasks.last?.id {
            Divider()
        }
    }
}

#Preview {
    NavigationStack {
        TaskTableView(taskListViewModel: TaskListViewModel())
    }
} 