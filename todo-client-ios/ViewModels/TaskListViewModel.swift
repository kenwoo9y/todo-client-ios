import Foundation

class TaskListViewModel: ObservableObject {
    @Published var tasks: [Task] = []
    
    init() {
        // TODO: APIからデータを取得する実装を追加
        let jsonString = """
        [
            {
                "title": "Task1",
                "description": "Description1",
                "due_date": "2025-05-06",
                "status": "Doing",
                "owner_id": 1,
                "id": 1,
                "created_at": "2025-05-06T07:02:19",
                "updated_at": "2025-05-06T07:02:19"
            },
            {
                "title": "Task2",
                "description": "Description2",
                "due_date": "2025-05-10",
                "status": "ToDo",
                "owner_id": 1,
                "id": 2,
                "created_at": "2025-05-06T07:06:37",
                "updated_at": "2025-05-06T07:06:37"
            }
        ]
        """
        
        print("JSON String: \(jsonString)")
        
        if let jsonData = jsonString.data(using: .utf8) {
            print("JSON Data created successfully")
            do {
                tasks = try JSONDecoder().decode([Task].self, from: jsonData)
                print("Decoded tasks count: \(tasks.count)")
                for task in tasks {
                    print("Task: \(task.title), Status: \(task.status.rawValue)")
                }
            } catch {
                print("Error decoding tasks: \(error)")
            }
        } else {
            print("Failed to create JSON data from string")
        }
    }
} 