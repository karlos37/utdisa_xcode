import Foundation
import Supabase

// MARK: - Database Models
struct AirportPickupFormDB: Codable {
    let id: UUID?
    let utdId: String
    let firstName: String
    let lastName: String
    let utdEmail: String
    let whatsappNumber: String
    let gender: String
    let emergencyContact: String
    let flightNumber: String
    let flightDate: Date
    let flightTime: Date
    let portOfEntry: String
    let checkInBagsCount: Int
    let cabinBagsCount: Int
    let dropOffLocation: String
    let acceptanceLetterUrl: String
    let studentPhotoUrl: String
    let itineraryImageUrl: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case utdId = "utd_id"
        case firstName = "first_name"
        case lastName = "last_name"
        case utdEmail = "utd_email"
        case whatsappNumber = "whatsapp_number"
        case gender
        case emergencyContact = "emergency_contact"
        case flightNumber = "flight_number"
        case flightDate = "flight_date"
        case flightTime = "flight_time"
        case portOfEntry = "port_of_entry"
        case checkInBagsCount = "checkin_bags_count"
        case cabinBagsCount = "cabin_bags_count"
        case dropOffLocation = "drop_off_location"
        case acceptanceLetterUrl = "acceptance_letter_url"
        case studentPhotoUrl = "student_photo_url"
        case itineraryImageUrl = "itinerary_image_url"
        case createdAt = "created_at"
    }
}

struct FeedbackFormDB: Codable {
    let id: UUID?
    let name: String
    let email: String
    let category: String
    let message: String
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, category, message
        case createdAt = "created_at"
    }
}

struct SponsorFormDB: Codable {
    let id: UUID?
    let companyName: String
    let contactName: String
    let email: String
    let phone: String
    let sponsorshipTier: String
    let message: String?
    let createdAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id, email, phone, message
        case companyName = "company_name"
        case contactName = "contact_name"
        case sponsorshipTier = "sponsorship_tier"
        case createdAt = "created_at"
    }
}

// MARK: - Conversion Extensions
extension AirportPickupForm {
    func toDatabase() -> AirportPickupFormDB {
        AirportPickupFormDB(
            id: nil,
            utdId: utdId,
            firstName: firstName,
            lastName: lastName,
            utdEmail: utdEmail,
            whatsappNumber: whatsappNumber,
            gender: gender.rawValue,
            emergencyContact: emergencyContact,
            flightNumber: flightNumber,
            flightDate: arrivalDate,
            flightTime: arrivalTime,
            portOfEntry: portOfEntryAirport,
            checkInBagsCount: checkInBagsCount,
            cabinBagsCount: cabinBagsCount,
            dropOffLocation: dropOffLocation,
            acceptanceLetterUrl: acceptanceLetterImageURL,
            studentPhotoUrl: studentPhotoURL,
            itineraryImageUrl: itineraryImageURL,
            createdAt: nil
        )
    }
}

extension FeedbackForm {
    func toDatabase() -> FeedbackFormDB {
        FeedbackFormDB(
            id: nil,
            name: name,
            email: email,
            category: category.rawValue,
            message: message,
            createdAt: nil
        )
    }
}

extension SponsorForm {
    func toDatabase() -> SponsorFormDB {
        SponsorFormDB(
            id: nil,
            companyName: companyName,
            contactName: contactName,
            email: email,
            phone: phone,
            sponsorshipTier: sponsorshipTier.rawValue,
            message: message,
            createdAt: nil
        )
    }
} 
