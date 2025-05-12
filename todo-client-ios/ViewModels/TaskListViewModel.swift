import Foundation

@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasks: [ToDoTask] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var sortKey: SortKey = .none
    @Published var sortOrder: SortOrder = .ascending
    @Published var swipedTaskId: Int?

    private let pageSize = 10
    private var allTasks: [ToDoTask] = []
    private var currentPage = 1

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
        guard !isLoading else { return }

        isLoading = true
        error = nil

        Task {
            do {
                let fetchedTasks = try await NetworkService.shared.fetchTasks()
                await MainActor.run {
                    allTasks = fetchedTasks
                    updateDisplayedTasks()
                }
            } catch {
                await MainActor.run {
                    self.error = error
                }
            }
            await MainActor.run {
                isLoading = false
            }
        }
    }

    func refreshTasks() {
        currentPage = 1
        allTasks = []
        tasks = []
        loadTasks()
    }

    func loadMoreIfNeeded(currentItem: ToDoTask) {
        let thresholdIndex = tasks.index(tasks.endIndex, offsetBy: -5)
        if tasks.firstIndex(where: { $0.id == currentItem.id }) ?? 0 >= thresholdIndex {
            currentPage += 1
            updateDisplayedTasks()
        }
    }

    private func updateDisplayedTasks() {
        let endIndex = min(currentPage * pageSize, allTasks.count)
        let displayedTasks = Array(allTasks[0 ..< endIndex])

        switch sortKey {
        case .none:
            tasks = displayedTasks
        case .title:
            tasks = displayedTasks.sorted { sortOrder == .ascending ? $0.title < $1.title : $0.title > $1.title }
        case .dueDate:
            tasks = displayedTasks.sorted { sortOrder == .ascending ? $0.dueDate < $1.dueDate : $0.dueDate > $1.dueDate }
        case .status:
            tasks = displayedTasks.sorted { sortOrder == .ascending ? $0.status.rawValue < $1.status.rawValue : $0.status.rawValue > $1.status.rawValue }
        }
    }

    func sort(by key: SortKey) {
        if sortKey == key {
            sortOrder = sortOrder == .ascending ? .descending : .ascending
        } else {
            sortKey = key
            sortOrder = .ascending
        }
        updateDisplayedTasks()
    }

    func deleteTask(id: Int) async {
        do {
            try await NetworkService.shared.deleteTask(id: id)
            await MainActor.run {
                refreshTasks()
                swipedTaskId = nil
            }
        } catch {
            await MainActor.run {
                self.error = error
            }
        }
    }
}
