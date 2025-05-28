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
                    } else if listings.isEmpty {
                        Text("No listings found.")
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
                                ForEach(listings) { listing in
                                    HousingListingCard(listing: listing)
                                        .padding(.horizontal)
                                }
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showListingForm = true }) {
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
