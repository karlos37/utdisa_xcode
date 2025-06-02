//
//  ContentView.swift
//  utdisa
//
//  Created by Vedansh Surjan on 27/05/25.
////
//
import SwiftUI
import Supabase

struct ContentView: View {
    @StateObject private var authManager = AuthManager()
    @State private var showAuthFlow = false
    @State private var authPurpose: AuthPurpose? = nil
    
    var body: some View {
        TabView {
            EventsView()
                .tabItem {
                    Label("Events", systemImage: "calendar")
                }
            
            TeamRosterView()
                .tabItem {
                    Label("Team", systemImage: "person.3")
                }
            
            FormsView(showAuthFlow: $showAuthFlow, authPurpose: $authPurpose)
                .tabItem {
                    Label("Forms", systemImage: "doc.text")
                }
            
            HousingMarketplaceTab(authManager: authManager, showAuthFlow: $showAuthFlow, authPurpose: $authPurpose)
                .tabItem {
                    Label("Housing", systemImage: "house")
                }
            
            ProfileTab(authManager: authManager, showAuthFlow: $showAuthFlow)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
        .tint(ISATheme.saffron)
        .sheet(isPresented: $showAuthFlow) {
            AuthFlowView(authManager: authManager, showAuthFlow: $showAuthFlow)
        }
    }
}

enum AuthPurpose {
    case addListing
    case pickupForm
}

struct HousingMarketplaceTab: View {
    var authManager: AuthManager
    @Binding var showAuthFlow: Bool
    @Binding var authPurpose: AuthPurpose?
    var body: some View {
        HousingMarketplaceView(showAuthFlow: $showAuthFlow, authPurpose: $authPurpose)
            .environmentObject(authManager)
    }
}

struct ProfileTab: View {
    @ObservedObject var authManager: AuthManager
    @State private var showPasswordReset = false
    @Binding var showAuthFlow: Bool

    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                if authManager.isLoggedIn {
                    Text("Logged in as\n\(authManager.displayName ?? authManager.userEmail ?? "")")
                        .multilineTextAlignment(.center)
                        .font(.title3)
                        .padding(.top)
                    Button("Reset Password") {
                        showPasswordReset = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(ISATheme.peacockBlue)
                    .cornerRadius(8)
                    Button("Logout") {
                        authManager.logout()
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(ISATheme.spiceRed)
                    .cornerRadius(8)
                } else {
                    Spacer()
                    Text("You are not signed in.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                    Button("Sign In / Register") {
                        showAuthFlow = true
                    }
                    .foregroundColor(.white)
                    .padding()
                    .background(ISATheme.saffron)
                    .cornerRadius(8)
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Profile")
            .sheet(isPresented: $showPasswordReset) {
                PasswordResetView()
            }
        }
    }
}

#Preview {
    ContentView()
}
