import Foundation

@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasks: [ToDoTask] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var currentPage = 1
    @Published var hasMorePages = true
    private let pageSize = 10
    
    init() {
        loadTasks()
    }
    
    private func loadTasks() {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        error = nil
        
        Task {
            do {
                let newTasks = try await NetworkService.shared.fetchTasks(page: currentPage, pageSize: pageSize)
                if newTasks.isEmpty {
                    hasMorePages = false
                } else {
                    tasks.append(contentsOf: newTasks)
                    currentPage += 1
                }
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func fetchTasks() async {
        guard !isLoading && hasMorePages else { return }
        
        isLoading = true
        error = nil
        
        do {
            let newTasks = try await NetworkService.shared.fetchTasks(page: currentPage, pageSize: pageSize)
            if newTasks.isEmpty {
                hasMorePages = false
            } else {
                tasks.append(contentsOf: newTasks)
                currentPage += 1
            }
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadMoreIfNeeded(currentItem: ToDoTask) {
        let thresholdIndex = tasks.index(tasks.endIndex, offsetBy: -5)
        if tasks.firstIndex(where: { $0.id == currentItem.id }) ?? 0 >= thresholdIndex {
            loadTasks()
        }
    }
} 