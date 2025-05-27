import SwiftUI

struct FormsView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: FeedbackFormView()) {
                    FormRowView(
                        title: "Feedback",
                        icon: "message",
                        color: ISATheme.saffron
                    )
                }
                
                NavigationLink(destination: SponsorFormView()) {
                    FormRowView(
                        title: "Sponsor Request",
                        icon: "dollarsign.circle",
                        color: ISATheme.green
                    )
                }
                
                NavigationLink(destination: AirportPickupFormView()) {
                    FormRowView(
                        title: "Airport Pickup",
                        icon: "airplane.arrival",
                        color: ISATheme.navy
                    )
                }
            }
            .navigationTitle("Forms")
        }
    }
}

struct FormRowView: View {
    let title: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 32)
            
            Text(title)
                .font(ISATheme.TextStyle.body)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
                .font(.caption)
        }
        .padding(.vertical, 8)
    }
}

struct FeedbackFormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var feedback = ""
    @State private var showingSubmitAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Your Information")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            
            Section(header: Text("Your Feedback")) {
                TextEditor(text: $feedback)
                    .frame(height: 150)
            }
            
            Section {
                Button(action: submitFeedback) {
                    Text("Submit Feedback")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .listRowBackground(ISATheme.saffron)
            }
        }
        .navigationTitle("Feedback")
        .alert("Thank You!", isPresented: $showingSubmitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your feedback has been submitted successfully.")
        }
    }
    
    private func submitFeedback() {
        // Add submission logic here
        showingSubmitAlert = true
        name = ""
        email = ""
        feedback = ""
    }
}

struct SponsorFormView: View {
    @State private var companyName = ""
    @State private var contactName = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var sponsorshipLevel = "Gold"
    @State private var additionalInfo = ""
    @State private var showingSubmitAlert = false
    
    let sponsorshipLevels = ["Gold", "Silver", "Bronze"]
    
    var body: some View {
        Form {
            Section(header: Text("Company Information")) {
                TextField("Company Name", text: $companyName)
                TextField("Contact Name", text: $contactName)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
            }
            
            Section(header: Text("Sponsorship Details")) {
                Picker("Sponsorship Level", selection: $sponsorshipLevel) {
                    ForEach(sponsorshipLevels, id: \.self) { level in
                        Text(level)
                    }
                }
                
                TextEditor(text: $additionalInfo)
                    .frame(height: 100)
                    .overlay(
                        Group {
                            if additionalInfo.isEmpty {
                                Text("Additional Information")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                            }
                        },
                        alignment: .topLeading
                    )
            }
            
            Section {
                Button(action: submitSponsorRequest) {
                    Text("Submit Request")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .listRowBackground(ISATheme.green)
            }
        }
        .navigationTitle("Sponsor Request")
        .alert("Thank You!", isPresented: $showingSubmitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your sponsorship request has been submitted successfully.")
        }
    }
    
    private func submitSponsorRequest() {
        // Add submission logic here
        showingSubmitAlert = true
        companyName = ""
        contactName = ""
        email = ""
        phone = ""
        additionalInfo = ""
    }
}

struct AirportPickupFormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var phone = ""
    @State private var flightNumber = ""
    @State private var arrivalDate = Date()
    @State private var additionalInfo = ""
    @State private var showingSubmitAlert = false
    
    var body: some View {
        Form {
            Section(header: Text("Personal Information")) {
                TextField("Full Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
            }
            
            Section(header: Text("Flight Details")) {
                TextField("Flight Number", text: $flightNumber)
                    .autocapitalization(.allCharacters)
                
                DatePicker(
                    "Arrival Date & Time",
                    selection: $arrivalDate,
                    in: Date()...,
                    displayedComponents: [.date, .hourAndMinute]
                )
                
                TextEditor(text: $additionalInfo)
                    .frame(height: 100)
                    .overlay(
                        Group {
                            if additionalInfo.isEmpty {
                                Text("Additional Information (Luggage, etc.)")
                                    .foregroundColor(.gray)
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8)
                            }
                        },
                        alignment: .topLeading
                    )
            }
            
            Section {
                Button(action: submitPickupRequest) {
                    Text("Request Pickup")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                }
                .listRowBackground(ISATheme.navy)
            }
        }
        .navigationTitle("Airport Pickup")
        .alert("Thank You!", isPresented: $showingSubmitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your airport pickup request has been submitted successfully.")
        }
    }
    
    private func submitPickupRequest() {
        // Add submission logic here
        showingSubmitAlert = true
        name = ""
        email = ""
        phone = ""
        flightNumber = ""
        additionalInfo = ""
    }
}

#Preview {
    FormsView()
} 