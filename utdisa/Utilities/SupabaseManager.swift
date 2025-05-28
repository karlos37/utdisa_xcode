import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    private(set) lazy var client = SupabaseClient(
        supabaseURL: SupabaseConfig.supabaseURL,
        supabaseKey: SupabaseConfig.supabaseAnonKey,
        options: SupabaseClientOptions(
            db: .init(
                schema: "public"
            ),
            global: .init(
                headers: [:],
                logger: .none   
            )
        )
    )
    
    private init() {}
} 
