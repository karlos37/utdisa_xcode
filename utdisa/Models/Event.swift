import Foundation

struct Event: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var date: Date
    var location: String
    var imageURL: URL?
    var registrationLink: URL?
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
} 