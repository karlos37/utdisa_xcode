import Foundation
import Supabase

class SupabaseManager {
    static let shared = SupabaseManager()
    
    static let sharedDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSXXXXX"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
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
                decoder: SupabaseManager.sharedDecoder
            ),
            global: .init(
                headers: [:],
                logger: .none   
            )
        )
    )
    
    private init() {}
} 
