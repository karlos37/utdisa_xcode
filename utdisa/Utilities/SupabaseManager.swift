import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    private(set) lazy var client = SupabaseClient(
        supabaseURL: SupabaseConfig.supabaseURL,
        supabaseKey: SupabaseConfig.supabaseAnonKey,
        options: SupabaseClientOptions(
            db: .init(
                schema: "public",
                encoder: {
                    let encoder = JSONEncoder()
                    encoder.dateEncodingStrategy = .iso8601
                    return encoder
                }(),
                decoder: {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    return decoder
                }()
            ),
            global: .init(
                headers: [:],
                logger: .none   
            )
        )
    )
    
    private init() {}
} 
