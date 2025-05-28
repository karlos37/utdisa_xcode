import Foundation
import Supabase
import Combine

class AuthManager: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var userEmail: String? = nil
    @Published var isVerified: Bool = false
    @Published var displayName: String? = nil
    private var cancellables = Set<AnyCancellable>()
    
    struct Profile: Decodable {
        let user_id: String
        let full_name: String?
    }
    
    init() {
        Task {
            await self.refreshSession()
        }
    }
    
    func refreshSession() async {
        let client = SupabaseManager.shared.client
        do {
            let session = try await client.auth.session
            let user = session.user
            if let email = user.email {
                let userId = user.id
                let profile = try? await fetchProfile(userId: userId.uuidString)
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.userEmail = email
                    self.isVerified = user.emailConfirmedAt != nil
                    self.displayName = profile?.full_name
                }
            } else {
                DispatchQueue.main.async {
                    self.isLoggedIn = false
                    self.userEmail = nil
                    self.isVerified = false
                    self.displayName = nil
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.isLoggedIn = false
                self.userEmail = nil
                self.isVerified = false
                self.displayName = nil
            }
        }
    }
    
    private func fetchProfile(userId: String) async throws -> Profile? {
        let client = SupabaseManager.shared.client
        let response = try await client
            .from("profiles")
            .select()
            .eq("user_id", value: userId)
            .single()
            .execute()
        let data = response.data
        let profile = try? JSONDecoder().decode(Profile.self, from: JSONSerialization.data(withJSONObject: data))
        return profile
    }
    
    func logout() {
        Task {
            do {
                try await SupabaseManager.shared.client.auth.signOut()
                await self.refreshSession()
            } catch {
                print("Logout error: \(error)")
                await self.refreshSession()
            }
        }
    }
    
    func login(email: String, password: String, completion: @escaping (String?) -> Void) {
        Task {
            do {
                let session = try await SupabaseManager.shared.client.auth.signIn(email: email, password: password)
                let user = session.user
                let profile = try? await fetchProfile(userId: user.id.uuidString)
                await self.refreshSession()
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                    self.userEmail = user.email
                    self.isVerified = user.emailConfirmedAt != nil
                    self.displayName = profile?.full_name
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error.localizedDescription)
                }
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (String?) -> Void) {
        Task {
            do {
                _ = try await SupabaseManager.shared.client.auth.signUp(email: email, password: password)
                await self.refreshSession()
                DispatchQueue.main.async {
                    completion(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(error.localizedDescription)
                }
            }
        }
    }
} 
