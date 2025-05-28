import SwiftUI
import Supabase

struct HousingMarketplaceView: View {
    @State private var listings: [HousingListing] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var showListingForm = false
    @State private var showSuccessAlert = false
    
    var body: some View {
        NavigationView {
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
                    }
                } else if listings.isEmpty {
                    Text("No listings found.")
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(listings) { listing in
                                HousingListingCard(listing: listing)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.vertical)
                    }
                }
            }
            .navigationTitle("Housing Marketplace")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showListingForm = true }) {
                        Label("Add Listing", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showListingForm, onDismiss: {
                // After the form is dismissed, refresh listings and show success alert
                fetchListings()
                showSuccessAlert = true
            }) {
                HousingListingFormView()
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Success"), message: Text("Listing uploaded successfully!"), dismissButton: .default(Text("OK")))
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
//                print("Raw JSON: \(String(data: result.data, encoding: .utf8) ?? "")")
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
}

struct HousingListingCard: View {
    let listing: HousingListing
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let firstUrl = listing.photo_urls.first, let url = URL(string: firstUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                            .clipped()
                    case .failure:
                        Color.gray.frame(height: 180)
                    @unknown default:
                        Color.gray.frame(height: 180)
                    }
                }
                .cornerRadius(10)
            }
            Text(listing.apartment_name)
                .font(.headline)
            Text("Type: \(listing.apartment_type) | \(listing.availability.capitalized)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Rent: $\(String(format: "%.2f", listing.rent)) / month")
                .font(.subheadline)
            if let aptNum = listing.apartment_number, !aptNum.isEmpty {
                Text("Apt #: \(aptNum)")
                    .font(.subheadline)
            }
            Text("Lease: \(listing.lease_type.capitalized)")
                .font(.subheadline)
            if listing.lease_type == "existing", let months = listing.lease_months_left {
                Text("Months left: \(months)")
                    .font(.subheadline)
            }
            if listing.is_temporary {
                Text("Temporary Housing Available")
                    .font(.subheadline)
                    .foregroundColor(.orange)
                if let from = listing.available_from, let to = listing.available_to {
                    Text("From \(formattedDate(from)) to \(formattedDate(to))")
                        .font(.subheadline)
                }
                if let perDay = listing.rent_per_day {
                    Text("$\(String(format: "%.2f", perDay)) per day")
                        .font(.subheadline)
                }
            }
            if let created = listing.created_at {
                Text("Posted: \(relativeDate(created))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.07), radius: 4, x: 0, y: 2)
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
