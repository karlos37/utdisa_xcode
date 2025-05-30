import Foundation

struct TeamMember: Identifiable {
    let id = UUID()
    var name: String
    var position: String
    var email: String
    var linkedInURL: URL?
    var bio: String
} 