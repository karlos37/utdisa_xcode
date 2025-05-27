import SwiftUI

struct FormsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: ISATheme.Padding.large) {
                    // Forms Grid
                    LazyVGrid(
                        columns: [GridItem(.flexible())],
                        spacing: ISATheme.Padding.medium
                    ) {
                        NavigationLink(destination: FeedbackFormView()) {
                            FormCard(
                                title: "Feedback",
                                icon: "message",
                                color: ISATheme.saffron,
                                description: "Share your thoughts and suggestions with us"
                            )
                        }
                        
                        NavigationLink(destination: SponsorFormView()) {
                            FormCard(
                                title: "Sponsor Request",
                                icon: "dollarsign.circle",
                                color: ISATheme.green,
                                description: "Partner with us to support our community"
                            )
                        }
                        
                        NavigationLink(destination: AirportPickupFormView()) {
                            FormCard(
                                title: "Airport Pickup",
                                icon: "airplane.arrival",
                                color: ISATheme.navy,
                                description: "Request pickup service from DFW or Love Field"
                            )
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .background(
                ISATheme.indianGradient
                    .opacity(0.1)
                    .ignoresSafeArea()
            )
            .navigationTitle("Forms")
        }
    }
}

struct FormCard: View {
    let title: String
    let icon: String
    let color: Color
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: ISATheme.Padding.small) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.system(size: 24))
                        .frame(width: 32)
                    
                    Text(title)
                        .font(ISATheme.TextStyle.heading)
                        .foregroundColor(ISATheme.navy)
                }
                
                Text(description)
                    .font(ISATheme.TextStyle.body)
                    .foregroundColor(.secondary)
                    .padding(.leading, 40)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(color)
                .font(.system(size: 20, weight: .semibold))
        }
        .padding()
        .background(ISATheme.CardStyle.background())
        .cornerRadius(ISATheme.CardStyle.cornerRadius)
        .shadow(
            color: ISATheme.CardStyle.shadowColor,
            radius: ISATheme.CardStyle.shadowRadius
        )
    }
}

struct FormTextField: View {
    let title: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    var autocapitalization: TextInputAutocapitalization? = nil
    var formatOnChange: ((String) -> String)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(ISATheme.TextStyle.body)
                .foregroundColor(ISATheme.navy)
            
            TextField("", text: Binding(
                get: { text },
                set: { newValue in
                    if let formatter = formatOnChange {
                        text = formatter(newValue)
                    } else {
                        text = newValue
                    }
                }
            ))
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .keyboardType(keyboardType)
            .if(autocapitalization != nil) { view in
                view.textInputAutocapitalization(autocapitalization)
            }
        }
    }
}

// Extension to conditionally apply modifiers
extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct FormSubmitButton: View {
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(ISATheme.TextStyle.body.bold())
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        colors: [color, color.opacity(0.8)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(10)
        }
    }
}

struct FeedbackFormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var feedback = ""
    @State private var showingSubmitAlert = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: ISATheme.Padding.large) {
                VStack(spacing: ISATheme.Padding.medium) {
                    FormTextField(
                        title: "Name",
                        text: $name
                    )
                    
                    FormTextField(
                        title: "Email",
                        text: $email,
                        keyboardType: .emailAddress,
                        autocapitalization: .never
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Feedback")
                        .font(ISATheme.TextStyle.body)
                        .foregroundColor(ISATheme.navy)
                    
                    TextEditor(text: $feedback)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                }
                
                FormSubmitButton(
                    title: "Submit Feedback",
                    color: ISATheme.saffron,
                    action: submitFeedback
                )
            }
            .padding()
            .background(ISATheme.CardStyle.background())
            .cornerRadius(ISATheme.CardStyle.cornerRadius)
            .shadow(
                color: ISATheme.CardStyle.shadowColor,
                radius: ISATheme.CardStyle.shadowRadius
            )
            .padding()
        }
        .background(
            ISATheme.indianGradient
                .opacity(0.1)
                .ignoresSafeArea()
        )
        .navigationTitle("Feedback")
        .alert("Thank You!", isPresented: $showingSubmitAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Your feedback has been submitted successfully.")
        }
    }
    
    private func submitFeedback() {
        // Add submission logic here
        showingSubmitAlert = true
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
    @Environment(\.dismiss) private var dismiss
    
    let sponsorshipLevels = ["Gold", "Silver", "Bronze"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: ISATheme.Padding.large) {
                VStack(spacing: ISATheme.Padding.medium) {
                    FormTextField(
                        title: "Company Name",
                        text: $companyName
                    )
                    
                    FormTextField(
                        title: "Contact Name",
                        text: $contactName
                    )
                    
                    FormTextField(
                        title: "Email",
                        text: $email,
                        keyboardType: .emailAddress,
                        autocapitalization: .never
                    )
                    
                    FormTextField(
                        title: "Phone",
                        text: $phone,
                        keyboardType: .phonePad
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sponsorship Level")
                        .font(ISATheme.TextStyle.body)
                        .foregroundColor(ISATheme.navy)
                    
                    Picker("Sponsorship Level", selection: $sponsorshipLevel) {
                        ForEach(sponsorshipLevels, id: \.self) { level in
                            Text(level)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Additional Information")
                        .font(ISATheme.TextStyle.body)
                        .foregroundColor(ISATheme.navy)
                    
                    TextEditor(text: $additionalInfo)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                }
                
                FormSubmitButton(
                    title: "Submit Request",
                    color: ISATheme.green,
                    action: submitSponsorRequest
                )
            }
            .padding()
            .background(ISATheme.CardStyle.background())
            .cornerRadius(ISATheme.CardStyle.cornerRadius)
            .shadow(
                color: ISATheme.CardStyle.shadowColor,
                radius: ISATheme.CardStyle.shadowRadius
            )
            .padding()
        }
        .background(
            ISATheme.indianGradient
                .opacity(0.1)
                .ignoresSafeArea()
        )
        .navigationTitle("Sponsor Request")
        .alert("Thank You!", isPresented: $showingSubmitAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Your sponsorship request has been submitted successfully.")
        }
    }
    
    private func submitSponsorRequest() {
        showingSubmitAlert = true
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
    @Environment(\.dismiss) private var dismiss
    
    // Flight number formatter
    private func formatFlightNumber(_ input: String) -> String {
        // Convert to uppercase
        let uppercased = input.uppercased()
        // Remove any characters that aren't letters or numbers
        let filtered = uppercased.filter { $0.isLetter || $0.isNumber }
        // Limit to 8 characters (typical max length for flight numbers)
        return String(filtered.prefix(8))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: ISATheme.Padding.large) {
                VStack(spacing: ISATheme.Padding.medium) {
                    FormTextField(
                        title: "Full Name",
                        text: $name
                    )
                    
                    FormTextField(
                        title: "Email",
                        text: $email,
                        keyboardType: .emailAddress,
                        autocapitalization: .never
                    )
                    
                    FormTextField(
                        title: "Phone",
                        text: $phone,
                        keyboardType: .phonePad
                    )
                    
                    FormTextField(
                        title: "Flight Number",
                        text: $flightNumber,
                        keyboardType: .asciiCapable,
                        autocapitalization: .words,
                        formatOnChange: formatFlightNumber
                    )
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Arrival Date & Time")
                        .font(ISATheme.TextStyle.body)
                        .foregroundColor(ISATheme.navy)
                    
                    DatePicker(
                        "",
                        selection: $arrivalDate,
                        in: Date()...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Additional Information")
                        .font(ISATheme.TextStyle.body)
                        .foregroundColor(ISATheme.navy)
                    
                    TextEditor(text: $additionalInfo)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                        )
                }
                
                FormSubmitButton(
                    title: "Request Pickup",
                    color: ISATheme.navy,
                    action: submitPickupRequest
                )
            }
            .padding()
            .background(ISATheme.CardStyle.background())
            .cornerRadius(ISATheme.CardStyle.cornerRadius)
            .shadow(
                color: ISATheme.CardStyle.shadowColor,
                radius: ISATheme.CardStyle.shadowRadius
            )
            .padding()
        }
        .background(
            ISATheme.indianGradient
                .opacity(0.1)
                .ignoresSafeArea()
        )
        .navigationTitle("Airport Pickup")
        .alert("Thank You!", isPresented: $showingSubmitAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("Your airport pickup request has been submitted successfully.")
        }
    }
    
    private func submitPickupRequest() {
        showingSubmitAlert = true
    }
}

#Preview {
    FormsView()
} 