import Foundation

struct AirportPickupForm {
    var fullName: String = ""
    var email: String = ""
    var phone: String = ""
    var flightNumber: String = ""
    var arrivalDate: Date = Date()
    var arrivalTime: Date = Date()
    var numberOfBags: Int = 1
    var additionalNotes: String = ""
    
    var isValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        !phone.isEmpty &&
        !flightNumber.isEmpty
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