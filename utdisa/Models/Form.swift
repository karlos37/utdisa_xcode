import Foundation

struct AirportPickupForm {
    // Basic Information
    var email: String = ""
    var utdId: String = ""
    var utdEmail: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var whatsappNumber: String = ""
    var gender: Gender = .preferNotToSay
    var emergencyContact: String = ""
    
    // Student Verification
    var isSpring25Student: Bool = false
    var acceptanceLetterImageURL: String = ""
    var studentPhotoURL: String = ""
    
    // Flight Details
    var flightNumber: String = ""
    var arrivalDate: Date = Date()
    var arrivalTime: Date = Date()
    var arrivalAirport: DallasAirport = .dfw
    var portOfEntryAirport: String = ""
    var itineraryImageURL: String = ""
    
    // Baggage Information
    var checkInBagsCount: Int = 1
    var cabinBagsCount: Int = 1
    
    // Location
    var dropOffLocation: String = ""
    
    // Terms and Conditions
    var agreesToTerms: Bool = false
    var agreesToWaiver: Bool = false
    
    enum Gender: String, CaseIterable {
        case male = "Male"
        case female = "Female"
        case preferNotToSay = "Prefer not to say"
    }
    
    enum DallasAirport: String, CaseIterable {
        case dfw = "Dallas/Fort Worth International Airport (DFW)"
        case dal = "Dallas Love Field Airport (DAL)"
    }
    
    var isValid: Bool {
        !email.isEmpty &&
        !utdId.isEmpty &&
        !utdEmail.isEmpty &&
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !whatsappNumber.isEmpty &&
        !emergencyContact.isEmpty &&
        isSpring25Student &&
        !acceptanceLetterImageURL.isEmpty &&
        !studentPhotoURL.isEmpty &&
        !flightNumber.isEmpty &&
        !portOfEntryAirport.isEmpty &&
        !itineraryImageURL.isEmpty &&
        !dropOffLocation.isEmpty &&
        agreesToTerms &&
        agreesToWaiver
    }
    
    // Helper function to format phone numbers
    static func formatPhoneNumber(_ number: String) -> String {
        let cleaned = number.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if cleaned.hasPrefix("91") && cleaned.count == 12 {
            let countryCode = cleaned.prefix(2)
            let remaining = cleaned.dropFirst(2)
            return "\(countryCode)\(remaining)"
        }
        return cleaned
    }
}

struct FeedbackForm {
    var name: String = ""
    var email: String = ""
    var category: FeedbackCategory = .general
    var message: String = ""
    
    var isValid: Bool {
        !name.isEmpty &&
        !email.isEmpty &&
        !message.isEmpty
    }
    
    enum FeedbackCategory: String, CaseIterable {
        case general = "General"
        case event = "Event"
        case suggestion = "Suggestion"
        case technical = "Technical"
        case other = "Other"
    }
}

struct SponsorForm {
    var companyName: String = ""
    var contactName: String = ""
    var email: String = ""
    var phone: String = ""
    var sponsorshipTier: SponsorshipTier = .gold
    var message: String = ""
    
    var isValid: Bool {
        !companyName.isEmpty &&
        !contactName.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty
    }
    
    enum SponsorshipTier: String, CaseIterable {
        case platinum = "Platinum"
        case gold = "Gold"
        case silver = "Silver"
        case bronze = "Bronze"
        
        var amount: String {
            switch self {
            case .platinum: return "$2000+"
            case .gold: return "$1000"
            case .silver: return "$500"
            case .bronze: return "$250"
            }
        }
        
        var benefits: String {
            switch self {
            case .platinum: return "Logo on all materials, VIP event access, Speaking opportunity, Premium booth space"
            case .gold: return "Logo on all materials, VIP event access, Premium booth space"
            case .silver: return "Logo on digital materials, Event booth space"
            case .bronze: return "Logo on digital materials"
            }
        }
    }
}

enum FormType: String, Identifiable {
    case airportPickup = "Airport Pickup"
    case feedback = "Feedback"
    case sponsor = "Become a Sponsor"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .airportPickup:
            return "Airport Pickup Request"
        case .feedback:
            return "Share Your Feedback"
        case .sponsor:
            return "Sponsor ISA Events"
        }
    }
    
    var description: String {
        switch self {
        case .airportPickup:
            return "Request a pickup from DFW Airport by ISA volunteers"
        case .feedback:
            return "Share your thoughts, suggestions, or report issues"
        case .sponsor:
            return "Support ISA events and connect with our community"
        }
    }
    
    var formURL: URL? {
        switch self {
        case .airportPickup:
            return URL(string: "https://forms.office.com/r/pFCGev576R")
        case .feedback, .sponsor:
            return nil
        }
    }
} 