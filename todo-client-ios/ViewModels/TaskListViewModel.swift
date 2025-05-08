import Foundation

@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasks: [ToDoTask] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var currentPage = 1
    @Published var hasMorePages = true
    @Published var sortKey: SortKey = .none
    @Published var sortOrder: SortOrder = .ascending
    
    private let pageSize = 10
    private var originalTasks: [ToDoTask] = []
    
    enum SortKey {
        case none
        case title
        case dueDate
        case status
    }
    
    enum SortOrder {
        case ascending
        case descending
    }
    
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
                    let uniqueNewTasks = newTasks.filter { newTask in
                        !originalTasks.contains { $0.id == newTask.id }
                    }
                    originalTasks.append(contentsOf: uniqueNewTasks)
                    currentPage += 1
                    applySort()
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
                let uniqueNewTasks = newTasks.filter { newTask in
                    !originalTasks.contains { $0.id == newTask.id }
                }
                originalTasks.append(contentsOf: uniqueNewTasks)
                currentPage += 1
                applySort()
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
    
    func sort(by key: SortKey) {
        if sortKey == key {
            sortOrder = sortOrder == .ascending ? .descending : .ascending
        } else {
            sortKey = key
            sortOrder = .ascending
        }
        applySort()
    }
    
    private func applySort() {
        switch sortKey {
        case .none:
            tasks = originalTasks
        case .title:
            tasks = originalTasks.sorted { sortOrder == .ascending ? $0.title < $1.title : $0.title > $1.title }
        case .dueDate:
            tasks = originalTasks.sorted { sortOrder == .ascending ? $0.dueDate < $1.dueDate : $0.dueDate > $1.dueDate }
        case .status:
            tasks = originalTasks.sorted { sortOrder == .ascending ? $0.status.rawValue < $1.status.rawValue : $0.status.rawValue > $1.status.rawValue }
        }
    }
} 