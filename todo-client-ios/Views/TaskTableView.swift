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
                LazyVStack(spacing: 0) {
                    ForEach(taskListViewModel.tasks) { task in
                        TaskRow(task: task, taskListViewModel: taskListViewModel)
                        if task.id != taskListViewModel.tasks.last?.id {
                            Divider()
                        }
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
    @State private var offset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // スワイプアクションボタン
            HStack {
                Spacer()
                NavigationLink {
                    TaskUpdateView(task: task, taskListViewModel: taskListViewModel)
                } label: {
                    Image(systemName: "pencil")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 44)
                }
                .background(Color.yellow)
                
                Button {
                    // 削除アクションは後で実装
                } label: {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 44)
                }
                .background(Color.red)
            }
            
            // メインコンテンツ
            HStack {
                NavigationLink {
                    TaskDetailView(task: task, taskListViewModel: taskListViewModel)
                } label: {
                    Text(task.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.primary)
                }
                Text(task.dueDate)
                    .frame(width: 100)
                Text(task.status.rawValue)
                    .frame(width: 80)
            }
            .padding()
            .frame(height: 44)
            .background(Color.white)
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            offset = gesture.translation.width
                        }
                    }
                    .onEnded { gesture in
                        withAnimation {
                            if gesture.translation.width < -100 {
                                offset = -100
                                taskListViewModel.swipedTaskId = task.id
                            } else {
                                offset = 0
                                taskListViewModel.swipedTaskId = nil
                            }
                        }
                    }
            )
        }
        .onAppear {
            taskListViewModel.loadMoreIfNeeded(currentItem: task)
            // スワイプ状態をリセット
            if taskListViewModel.swipedTaskId != task.id {
                offset = 0
            }
        }
        .onChange(of: taskListViewModel.swipedTaskId) { oldValue, newValue in
            if newValue != task.id {
                withAnimation {
                    offset = 0
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TaskTableView(taskListViewModel: TaskListViewModel())
    }
} 