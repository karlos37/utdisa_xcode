import SwiftUI
import Supabase

struct HousingMarketplaceView: View {
    @State private var listings: [HousingListing] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showListingForm = false
    @State private var showSuccessAlert = false
    @State private var selectedTab = 0 // 0: All Listings, 1: My Listings
    @State private var showDeleteAlert = false
    @State private var listingToDelete: HousingListing? = nil
    @EnvironmentObject var authManager: AuthManager
    @Binding var showAuthFlow: Bool
    @Binding var authPurpose: AuthPurpose?
    
    var body: some View {
        NavigationView {
            ZStack {
                ISATheme.indianGradient.ignoresSafeArea()
                Group {
                    if isLoading {
                        ProgressView("Loading Listings...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let errorMessage = errorMessage {
                        VStack {
                            Text("Error: \(errorMessage)")
                                .foregroundColor(.red)
                            Button("Retry") { fetchListings() }
                                .padding(.top)
                                .foregroundColor(.white)
                                .background(ISATheme.saffron)
                                .cornerRadius(8)
                        }
                    } else {
                        VStack(spacing: 0) {
                            Picker("View", selection: $selectedTab) {
                                Text("All Listings").tag(0)
                                Text("My Listings").tag(1)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding([.horizontal, .top])

                            Divider().padding(.bottom, 4)

                            let filteredListings: [HousingListing] = {
                                if selectedTab == 1, let userId = authManager.userId {
                                    return listings.filter { $0.user_id == userId }
                                } else {
                                    return listings
                                }
                            }()

                            if filteredListings.isEmpty {
                                Text(selectedTab == 1 ? "You have not posted any listings." : "No listings found.")
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            } else {
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 20) {
                                        Text("🏠 Housing Marketplace")
                                            .font(ISATheme.TextStyle.title)
                                            .foregroundColor(ISATheme.peacockBlue)
                                            .padding(.leading)
                                            .padding(.top, 8)
                                        Divider()
                                            .background(ISATheme.saffron)
                                            .padding(.horizontal)
                                        ForEach(filteredListings) { listing in
                                            HousingListingCard(
                                                listing: listing,
                                                showDelete: selectedTab == 1 && listing.user_id == authManager.userId,
                                                onDelete: { listingToDelete = listing; showDeleteAlert = true }
                                            )
                                            .padding(.horizontal)
                                        }
                                    }
                                    .padding(.vertical)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if authManager.isVerified {
                            showListingForm = true
                        } else {
                            authPurpose = .addListing
                            showAuthFlow = true
                        }
                    }) {
                        Label("Add Listing", systemImage: "plus")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(ISATheme.peacockBlue)
                            .cornerRadius(8)
                    }
                }
            }
            .sheet(isPresented: $showListingForm, onDismiss: {
                fetchListings()
                showSuccessAlert = true
            }) {
                HousingListingFormView(userId: authManager.userId)
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Success"), message: Text("Listing uploaded successfully!"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Listing"),
                    message: Text("Are you sure you want to delete this listing? This action cannot be undone."),
                    primaryButton: .destructive(Text("Delete")) {
                        if let listing = listingToDelete {
                            deleteListing(listing)
                        }
                        listingToDelete = nil
                    },
                    secondaryButton: .cancel {
                        listingToDelete = nil
                    }
                )
            }
            .onAppear(perform: fetchListings)
        }
    }
    
    private func fetchListings() {
        isLoading = true
        errorMessage = nil
        let client = SupabaseManager.shared.client
        Task {
            do {
                let result = try await client.database
                    .from("housing_listings")
                    .select()
                    .order("created_at", ascending: false)
                    .execute()
                let response: [HousingListing] = try SupabaseManager.sharedDecoder.decode([HousingListing].self, from: result.data)
                DispatchQueue.main.async {
                    self.listings = response
                    self.isLoading = false
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func deleteListing(_ listing: HousingListing) {
        guard let id = listing.id else { return }
        let client = SupabaseManager.shared.client
        isLoading = true
        Task {
            do {
                _ = try await client.database.from("housing_listings").delete().eq("id", value: id.uuidString).execute()
                DispatchQueue.main.async {
                    self.listings.removeAll { $0.id == id }
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}

struct HousingListingCard: View {
    let listing: HousingListing
    var showDelete: Bool = false
    var onDelete: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !listing.photo_urls.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(listing.photo_urls, id: \.self) { urlString in
                            if let url = URL(string: urlString) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView()
                                            .frame(width: 120, height: 120)
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipped()
                                    case .failure:
                                        Color.gray.frame(width: 120, height: 120)
                                    @unknown default:
                                        Color.gray.frame(width: 120, height: 120)
                                    }
                                }
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(ISATheme.saffron, lineWidth: 2)
                                )
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(listing.apartment_name)
                        .font(ISATheme.TextStyle.heading)
                        .foregroundColor(ISATheme.peacockBlue)
                    Text("Type: \(listing.apartment_type) | \(listing.availability.capitalized)")
                        .font(ISATheme.TextStyle.subheading)
                        .foregroundColor(.secondary)
                    Text("Rent: $\(String(format: "%.2f", listing.rent)) / month")
                        .font(ISATheme.TextStyle.subheading)
                        .foregroundColor(ISATheme.green)
                    if let aptNum = listing.apartment_number, !aptNum.isEmpty {
                        Text("Apt #: \(aptNum)")
                            .font(ISATheme.TextStyle.body)
                    }
                    Text("Lease: \(listing.lease_type.capitalized)")
                        .font(ISATheme.TextStyle.body)
                    if listing.lease_type == "existing", let months = listing.lease_months_left {
                        Text("Months left: \(months)")
                            .font(ISATheme.TextStyle.body)
                    }
                    if listing.is_temporary {
                        Text("Temporary Housing Available")
                            .font(ISATheme.TextStyle.body)
                            .foregroundColor(ISATheme.saffron)
                        if let from = listing.available_from, let to = listing.available_to {
                            Text("From \(formattedDate(from)) to \(formattedDate(to))")
                                .font(ISATheme.TextStyle.body)
                        }
                        if let perDay = listing.rent_per_day {
                            Text("$\(String(format: "%.2f", perDay)) per day")
                                .font(ISATheme.TextStyle.body)
                        }
                    }
                    if let created = listing.created_at {
                        Text("Posted: \(relativeDate(created))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                if showDelete, let onDelete = onDelete {
                    Button(role: .destructive) {
                        onDelete()
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                            .padding(8)
                            .background(Color.white)
                            .clipShape(Circle())
                    }
                }
            }
        }
        .padding()
        .background(
            ISATheme.CardStyle.background()
        )
        .overlay(
            RoundedRectangle(cornerRadius: ISATheme.CardStyle.cornerRadius)
                .stroke(ISATheme.saffron.opacity(0.5), lineWidth: 2)
        )
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    private func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
} 
