import Foundation

@MainActor
class TaskListViewModel: ObservableObject {
    @Published var tasks: [ToDoTask] = []
    @Published var isLoading = false
    @Published var error: String?
    
    init() {
        loadTasks()
    }
    
    private func loadTasks() {
        isLoading = true
        error = nil
        
        Task {
            do {
                tasks = try await NetworkService.shared.fetchTasks()
            } catch {
                self.error = error.localizedDescription
            }
            isLoading = false
        }
    }
    
    func fetchTasks() async {
        isLoading = true
        error = nil
        
        do {
            tasks = try await NetworkService.shared.fetchTasks()
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
} 