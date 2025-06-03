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

extension Event {
    static let sampleEvents: [Event] = [
        Event(
            title: "ISA Independence Day",
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 15, hour: 10))!,
            description: "Join us in celebrating India's Independence Day with cultural performances, flag hoisting ceremony, and traditional Indian refreshments.",
            location: "UTD Plinth",
            locationURL: URL(string: "https://maps.app.goo.gl/U2Y7igWRTvVXF1N1A"),
            registrationURL: nil,
            posterImageName: "independence_day_poster"
        ),
        Event(
            title: "ISA Ganesh Chaturthi",
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 27, hour: 9))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 28, hour: 17))!,
            description: "Celebrate the auspicious festival of Ganesh Chaturthi with ISA. Join us for aarti, prasad distribution, and cultural activities.",
            location: "UTD Chess Plaza",
            locationURL: URL(string: "https://maps.app.goo.gl/mnujc6rGEETHx1S87"),
            registrationURL: nil,
            posterImageName: "ganesh_chaturthi_poster"
        )
    ]
} 