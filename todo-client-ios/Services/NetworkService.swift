import Foundation

struct TaskData: Codable {
    let title: String
    let description: String
    let status: TaskStatus
    let dueDate: Date
    let ownerId: Int

    enum CodingKeys: String, CodingKey {
        case title
        case description
        case status
        case dueDate = "due_date"
        case ownerId = "owner_id"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(status, forKey: .status)
        try container.encode(ownerId, forKey: .ownerId)

        // 日付をYYYY-MM-DD形式でエンコード（JST）
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        let dateString = dateFormatter.string(from: dueDate)
        try container.encode(dateString, forKey: .dueDate)
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
    case serverError(String)
    case invalidResponse
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
        let requestBody = try encoder.encode(taskData)
        urlRequest.httpBody = requestBody

        // デバッグ用：リクエストの内容を出力
        print("Request URL: \(url)")
        if let requestString = String(data: requestBody, encoding: .utf8) {
            print("Request Body: \(requestString)")
        }

        let (data, response) = try await URLSession.shared.data(for: urlRequest)

        // デバッグ用：レスポンスの内容を出力
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard httpResponse.statusCode == 201 else {
            throw NetworkError.serverError(String(httpResponse.statusCode))
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
        let url = baseURL.appendingPathComponent("tasks/\(request.id)")
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
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
        let requestBody = try encoder.encode(taskData)
        urlRequest.httpBody = requestBody
        
        // デバッグ用：リクエストの内容を出力
        print("Request URL: \(url)")
        if let requestString = String(data: requestBody, encoding: .utf8) {
            print("Request Body: \(requestString)")
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        // デバッグ用：レスポンスの内容を出力
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }
        }
        
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
