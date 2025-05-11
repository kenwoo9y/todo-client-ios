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
    
    func createTask(title: String, description: String, status: TaskStatus, dueDate: Date, ownerId: Int) async throws -> ToDoTask {
        guard let url = URL(string: "\(AppEnvironment.apiURL)/tasks") else {
            throw NetworkError.invalidURL
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let requestBody: [String: Any] = [
            "title": title,
            "description": description,
            "status": status.rawValue,
            "due_date": dateFormatter.string(from: dueDate),
            "owner_id": ownerId
        ]
        
        // デバッグ用：リクエストボディの内容を出力
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Request URL: \(url)")
            print("Request Body: \(jsonString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // デバッグ用：レスポンスの内容を出力
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Invalid response")
        }
        
        do {
            let task = try JSONDecoder().decode(ToDoTask.self, from: data)
            return task
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func updateTask(id: Int, title: String, description: String, status: TaskStatus, dueDate: Date, ownerId: Int) async throws -> ToDoTask {
        guard let url = URL(string: "\(AppEnvironment.apiURL)/tasks/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        let requestBody: [String: Any] = [
            "title": title,
            "description": description,
            "status": status.rawValue,
            "due_date": dateFormatter.string(from: dueDate),
            "owner_id": ownerId
        ]

        // デバッグ用：リクエストボディの内容を出力
        if let jsonData = try? JSONSerialization.data(withJSONObject: requestBody, options: .prettyPrinted),
            let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Request URL: \(url)")
            print("Request Body: \(jsonString)")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        
        let (data, response) = try await URLSession.shared.data(for: request)

        // デバッグ用：レスポンスの内容を出力
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
            if let responseString = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseString)")
            }
        }

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Invalid response")
        }
        
        do {
            let task = try JSONDecoder().decode(ToDoTask.self, from: data)
            return task
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func deleteTask(id: Int) async throws {
        guard let url = URL(string: "\(AppEnvironment.apiURL)/tasks/\(id)") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.serverError("Invalid response")
        }

        // デバッグ用：レスポンスの内容を出力
        if let httpResponse = response as? HTTPURLResponse {
            print("Response Status Code: \(httpResponse.statusCode)")
        }
    }
} 