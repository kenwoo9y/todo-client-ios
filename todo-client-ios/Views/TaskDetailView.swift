import SwiftUI

struct TaskDetailView: View {
    let task: ToDoTask
    @StateObject private var sideMenuViewModel = SideMenuViewModel()
    
    var body: some View {
        // メインコンテンツ
        CommonLayout(isShowingSideMenu: $sideMenuViewModel.isShowingSideMenu) {
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
                        DetailRow(title: "作成日時", value: formatDate(task.createdAt))
                        DetailRow(title: "更新日時", value: formatDate(task.updatedAt))
                    }
                }
            }
        }
    }
    
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            return formatter.string(from: date)
        }
        return dateString
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
    ))
} 