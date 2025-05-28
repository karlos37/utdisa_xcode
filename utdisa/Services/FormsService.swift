import Foundation
import Supabase

class FormsService {
    private let supabase = SupabaseManager.shared.client
    
    // MARK: - Airport Pickup Forms
    
    func submitAirportPickupForm(_ form: AirportPickupForm) async throws -> AirportPickupFormDB {
        let dbForm = form.toDatabase()
        return try await supabase
            .from("airport_pickup_forms")
            .insert(dbForm)
            .single()
            .execute()
            .value
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
    
    func submitFeedbackForm(_ form: FeedbackForm) async throws -> FeedbackFormDB {
        let dbForm = form.toDatabase()
        return try await supabase
            .from("feedback_forms")
            .insert(dbForm)
            .single()
            .execute()
            .value
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
    
    func submitSponsorForm(_ form: SponsorForm) async throws -> SponsorFormDB {
        let dbForm = form.toDatabase()
        return try await supabase
            .from("sponsor_forms")
            .insert(dbForm)
            .single()
            .execute()
            .value
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
