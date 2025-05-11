import Foundation

struct DateUtils {
    static func formatDateTime(_ dateString: String) -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
            return formatter.string(from: date)
        }
        return dateString
    }
} 