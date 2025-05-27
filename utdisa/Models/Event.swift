import Foundation
import MapKit

struct Event: Identifiable {
    let id = UUID()
    var title: String
    var startDate: Date
    var endDate: Date?
    var description: String
    var location: String
    var locationURL: URL?
    var registrationURL: URL?
    var posterImageName: String
    
    var isMultiDayEvent: Bool {
        guard let endDate = endDate else { return false }
        return !Calendar.current.isDate(startDate, inSameDayAs: endDate)
    }
    
    var dateRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        
        if let endDate = endDate, isMultiDayEvent {
            return "\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))"
        }
        return formatter.string(from: startDate)
    }
    
    var timeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: startDate)
    }
} 