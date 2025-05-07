import Foundation

struct ToDoTask: Identifiable, Codable {
    let id: Int
    let title: String
    let description: String
    let dueDate: String
    let status: TaskStatus
    let ownerId: Int
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case dueDate = "due_date"
        case status
        case ownerId = "owner_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

enum TaskStatus: String, Codable {
    case todo = "ToDo"
    case doing = "Doing"
    case done = "Done"
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        switch rawValue {
        case "ToDo":
            self = .todo
        case "Doing":
            self = .doing
        case "Done":
            self = .done
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid status value: \(rawValue)")
        }
    }
} 