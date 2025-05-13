import SwiftUI

struct TaskTableView: View {
    @ObservedObject var taskListViewModel: TaskListViewModel

    var body: some View {
        VStack(spacing: 0) {
            TaskTableHeader(taskListViewModel: taskListViewModel)
            TaskListContent(taskListViewModel: taskListViewModel)
        }
    }
}

private struct TaskTableHeader: View {
    @ObservedObject var taskListViewModel: TaskListViewModel

    var body: some View {
        HStack {
            Button(
                action: { taskListViewModel.sort(by: .title) },
                label: {
                    HStack {
                        Text("タイトル")
                        if taskListViewModel.sortKey == .title {
                            Image(systemName: taskListViewModel.sortOrder == .ascending ? "chevron.up" : "chevron.down")
                                .accessibilityLabel(taskListViewModel.sortOrder == .ascending ? "昇順" : "降順")
                        }
                    }
                }
            )
            .frame(maxWidth: .infinity, alignment: .leading)

            Button(
                action: { taskListViewModel.sort(by: .dueDate) },
                label: {
                    HStack {
                        Text("期日")
                        if taskListViewModel.sortKey == .dueDate {
                            Image(systemName: taskListViewModel.sortOrder == .ascending ? "chevron.up" : "chevron.down")
                                .accessibilityLabel(taskListViewModel.sortOrder == .ascending ? "昇順" : "降順")
                        }
                    }
                }
            )
            .frame(width: 100)

            Button(
                action: { taskListViewModel.sort(by: .status) },
                label: {
                    HStack {
                        Text("ステータス")
                        if taskListViewModel.sortKey == .status {
                            Image(systemName: taskListViewModel.sortOrder == .ascending ? "chevron.up" : "chevron.down")
                                .accessibilityLabel(taskListViewModel.sortOrder == .ascending ? "昇順" : "降順")
                        }
                    }
                }
            )
            .frame(width: 80)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
    }
}

private struct TaskListContent: View {
    @ObservedObject var taskListViewModel: TaskListViewModel

    var body: some View {
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

struct TaskRow: View {
    let task: ToDoTask
    @ObservedObject var taskListViewModel: TaskListViewModel
    @State private var offset: CGFloat = 0
    @State private var isShowingDeleteAlert = false

    var body: some View {
        ZStack {
            SwipeActionButtons(
                task: task,
                taskListViewModel: taskListViewModel,
                isShowingDeleteAlert: $isShowingDeleteAlert
            )
            TaskRowContent(
                task: task,
                taskListViewModel: taskListViewModel,
                offset: $offset
            )
        }
        .onAppear {
            taskListViewModel.loadMoreIfNeeded(currentItem: task)
            if taskListViewModel.swipedTaskId != task.id {
                offset = 0
            }
        }
        .onChange(of: taskListViewModel.swipedTaskId) { _, newValue in
            if newValue != task.id {
                withAnimation {
                    offset = 0
                }
            }
        }
        .deleteTaskAlert(
            task: task,
            taskListViewModel: taskListViewModel,
            isShowing: $isShowingDeleteAlert,
            onDismiss: {
                taskListViewModel.swipedTaskId = nil
            }
        )
    }
}

private struct SwipeActionButtons: View {
    let task: ToDoTask
    let taskListViewModel: TaskListViewModel
    @Binding var isShowingDeleteAlert: Bool

    var body: some View {
        HStack {
            Spacer()
            NavigationLink {
                TaskUpdateView(task: task, taskListViewModel: taskListViewModel)
            } label: {
                Image(systemName: "pencil")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 44)
                    .accessibilityLabel("編集")
            }
            .background(Color.yellow)

            Button {
                isShowingDeleteAlert = true
            } label: {
                Image(systemName: "trash")
                    .foregroundColor(.white)
                    .frame(width: 40, height: 44)
                    .accessibilityLabel("削除")
            }
            .background(Color.red)
        }
    }
}

private struct TaskRowContent: View {
    let task: ToDoTask
    let taskListViewModel: TaskListViewModel
    @Binding var offset: CGFloat

    var body: some View {
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
}

#Preview {
    NavigationStack {
        TaskTableView(taskListViewModel: TaskListViewModel())
    }
}
