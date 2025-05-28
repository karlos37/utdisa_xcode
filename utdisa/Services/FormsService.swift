import Foundation
import Supabase

class FormsService {
    private let supabase = SupabaseManager.shared.client
    
    // MARK: - Airport Pickup Forms
    
    func submitAirportPickupForm(_ form: AirportPickupForm) async throws {
        let dbForm = form.toDatabase()
        try await supabase
            .from("airport_pickup_forms")
            .insert(dbForm)
            .single()
            .execute()
    }
    
    func getAirportPickupForms() async throws -> [AirportPickupFormDB] {
        return try await supabase
            .from("airport_pickup_forms")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
    }
    
    // MARK: - Feedback Forms
    
    func submitFeedbackForm(_ form: FeedbackForm) async throws {
        let dbForm = form.toDatabase()
        try await supabase
            .from("feedback_forms")
            .insert(dbForm)
            .single()
            .execute()
    }
    
    func getFeedbackForms() async throws -> [FeedbackFormDB] {
        return try await supabase
            .from("feedback_forms")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
    }
    
    // MARK: - Sponsor Forms
    
    func submitSponsorForm(_ form: SponsorForm) async throws {
        let dbForm = form.toDatabase()
        try await supabase
            .from("sponsor_forms")
            .insert(dbForm)
            .single()
            .execute()
    }
    
    func getSponsorForms() async throws -> [SponsorFormDB] {
        return try await supabase
            .from("sponsor_forms")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
    }
} 
