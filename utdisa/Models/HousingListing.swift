import Foundation

struct HousingListing: Identifiable, Codable {
    let id: UUID?
    let user_id: UUID?
    var apartment_name: String
    var apartment_type: String
    var availability: String // "whole" or "room"
    var rent: Double
    var apartment_number: String?
    var lease_type: String // "new" or "existing"
    var lease_months_left: Int?
    var is_temporary: Bool
    var available_from: Date?
    var available_to: Date?
    var rent_per_day: Double?
    var photo_urls: [String]
    var created_at: Date?
} 