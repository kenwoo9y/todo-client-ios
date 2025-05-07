import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func fetchTasks() async throws -> [ToDoTask] {
        guard let url = URL(string: "\(AppEnvironment.apiURL)/tasks") else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Invalid response")
        }
        
        do {
            let tasks = try JSONDecoder().decode([ToDoTask].self, from: data)
            return tasks
        } catch {
            throw NetworkError.decodingError
        }
    }
} 