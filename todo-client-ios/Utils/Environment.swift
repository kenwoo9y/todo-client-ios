import Foundation

enum AppEnvironment {
    static func value(for key: String) -> String? {
        guard let path = Bundle.main.path(forResource: ".env", ofType: nil) else {
            return nil
        }
        
        do {
            let content = try String(contentsOfFile: path, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            
            for line in lines {
                let parts = line.components(separatedBy: "=")
                if parts.count == 2 && parts[0].trimmingCharacters(in: .whitespaces) == key {
                    return parts[1].trimmingCharacters(in: .whitespaces)
                }
            }
        } catch {
            print("Error reading .env file: \(error)")
        }
        
        return nil
    }
    
    static var apiURL: String {
        return value(for: "API_URL") ?? "http://localhost:8000"
    }
} 