import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
}

class NetworkService {
    static let shared = NetworkService()

    private let baseURL = URL(string: AppEnvironment.apiURL)!

    func fetchTasks() async throws -> [ToDoTask] {
        guard let url = URL(string: "\(AppEnvironment.apiURL)/tasks") else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200 ... 299).contains(httpResponse.statusCode)
        else {
            throw NetworkError.serverError("Invalid response")
        }

        do {
            return try JSONDecoder().decode([ToDoTask].self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }

    struct TaskCreateRequest {
        let title: String
        let description: String
        let status: TaskStatus
        let dueDate: Date
        let ownerId: Int
    }

    func createTask(_ request: TaskCreateRequest) async throws -> ToDoTask {
        let url = baseURL.appendingPathComponent("tasks")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let taskData = TaskData(
            title: request.title,
            description: request.description,
            status: request.status,
            dueDate: request.dueDate,
            ownerId: request.ownerId
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        urlRequest.httpBody = try encoder.encode(taskData)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard httpResponse.statusCode == 201 else {
            throw NetworkError.serverError(httpResponse.statusCode)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(ToDoTask.self, from: data)
    }

    struct TaskUpdateRequest {
        let id: Int
        let title: String
        let description: String
        let status: TaskStatus
        let dueDate: Date
        let ownerId: Int
    }

    func updateTask(_ request: TaskUpdateRequest) async throws -> ToDoTask {
        let url = URL(string: "\(AppEnvironment.apiURL)/tasks/\(request.id)")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "PUT"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let taskData = TaskData(
            title: request.title,
            description: request.description,
            status: request.status,
            dueDate: request.dueDate,
            ownerId: request.ownerId
        )

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        urlRequest.httpBody = try encoder.encode(taskData)

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw NetworkError.serverError(String(httpResponse.statusCode))
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode(ToDoTask.self, from: data)
    }

    func deleteTask(id: Int) async throws {
        guard let url = URL(string: "\(AppEnvironment.apiURL)/tasks/\(id)") else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200 ... 299).contains(httpResponse.statusCode)
        else {
            throw NetworkError.serverError("Invalid response")
        }

        // デバッグ用：レスポンスの内容を出力
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
        }
    }
}
