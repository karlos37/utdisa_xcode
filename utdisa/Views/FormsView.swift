import SwiftUI
import SafariServices

struct FormsView: View {
    private let forms: [FormType] = [.airportPickup, .feedback, .sponsor]
    @State private var selectedForm: FormType?
    @State private var showInAppForm = false
    @State private var airportPickupForm = AirportPickupForm()
    @State private var feedbackForm = FeedbackForm()
    @State private var sponsorForm = SponsorForm()
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: ISATheme.Padding.large) {
                    // Header
                    VStack(spacing: ISATheme.Padding.medium) {
                        Text("ISA Forms")
                            .font(ISATheme.TextStyle.title)
                            .foregroundColor(ISATheme.navy)
                        
                        Text("Fill out forms for various ISA services")
                            .font(ISATheme.TextStyle.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Forms List
                    LazyVStack(spacing: ISATheme.Padding.medium) {
                        ForEach(forms) { form in
                            FormCard(form: form) {
                                handleWebAction(for: form)
                            } inAppAction: {
                                selectedForm = form
                                showInAppForm = true
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(
                ISATheme.indianGradient
                    .opacity(0.1)
                    .ignoresSafeArea()
            )
            .navigationTitle("Forms")
            .sheet(isPresented: $showInAppForm) {
                if let form = selectedForm {
                    switch form {
                    case .airportPickup:
                        AirportPickupFormView(form: $airportPickupForm, isPresented: $showInAppForm)
                    case .feedback:
                        FeedbackFormView(form: $feedbackForm, isPresented: $showInAppForm)
                    case .sponsor:
                        SponsorFormView(form: $sponsorForm, isPresented: $showInAppForm)
                    }
                }
            }
            .alert("Error", isPresented: $showErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func handleWebAction(for form: FormType) {
        if let url = form.formURL {
            URLHandler.open(url) { success in
                if !success {
                    errorMessage = "Could not open the form. Please try again later."
                    showErrorAlert = true
                }
            }
        } else {
            selectedForm = form
            showInAppForm = true
        }
    }
}

struct FormCard: View {
    let form: FormType
    let webAction: () -> Void
    let inAppAction: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: ISATheme.Padding.medium) {
            Text(form.title)
                .font(ISATheme.TextStyle.heading)
                .foregroundColor(ISATheme.navy)
            
            Text(form.description)
                .font(ISATheme.TextStyle.body)
                .foregroundColor(.secondary)
            
            HStack(spacing: ISATheme.Padding.medium) {
                Button(action: webAction) {
                    HStack {
                        Image(systemName: "safari")
                        Text("Open in Browser")
                    }
                    .font(ISATheme.TextStyle.body.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ISATheme.peacockBlue)
                    .cornerRadius(10)
                }
                
                Button(action: inAppAction) {
                    HStack {
                        Image(systemName: "app")
                        Text("Fill in App")
                    }
                    .font(ISATheme.TextStyle.body.bold())
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ISATheme.saffron)
                    .cornerRadius(10)
                }
            }
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
    @Binding var form: FeedbackForm
    @Binding var isPresented: Bool
    @State private var showingSubmitAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Information")) {
                    TextField("Name", text: $form.name)
                        .textContentType(.name)
                    
                    TextField("Email", text: $form.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                }
                
                Section(header: Text("Feedback Details")) {
                    Picker("Category", selection: $form.category) {
                        ForEach(FeedbackForm.FeedbackCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    
                    TextEditor(text: $form.message)
                        .frame(height: 150)
                }
                
                Section {
                    Button(action: submitForm) {
                        Text("Submit Feedback")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(form.isValid ? ISATheme.saffron : Color.gray)
                    .disabled(!form.isValid)
                }
            }
            .navigationTitle("Share Your Feedback")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
            .alert("Thank You!", isPresented: $showingSubmitAlert) {
                Button("OK", role: .cancel) {
                    isPresented = false
                }
            } message: {
                Text("Your feedback has been submitted successfully.")
            }
        }
    }
    
    private func submitForm() {
        // Here we would submit the feedback to a backend service
        showingSubmitAlert = true
    }
}

struct SponsorFormView: View {
    @Binding var form: SponsorForm
    @Binding var isPresented: Bool
    @State private var showingSubmitAlert = false
    @State private var showingTierInfo = false
    @State private var selectedTierForInfo: SponsorForm.SponsorshipTier?
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Company Information")) {
                    TextField("Company Name", text: $form.companyName)
                    
                    TextField("Contact Name", text: $form.contactName)
                        .textContentType(.name)
                    
                    TextField("Email", text: $form.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                    
                    TextField("Phone", text: $form.phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Sponsorship Details")) {
                    Picker("Sponsorship Tier", selection: $form.sponsorshipTier) {
                        ForEach(SponsorForm.SponsorshipTier.allCases, id: \.self) { tier in
                            Text("\(tier.rawValue) (\(tier.amount))").tag(tier)
                        }
                    }
                    
                    Button("View Tier Benefits") {
                        selectedTierForInfo = form.sponsorshipTier
                        showingTierInfo = true
                    }
                    
                    TextEditor(text: $form.message)
                        .frame(height: 100)
                        .placeholder(when: form.message.isEmpty) {
                            Text("Additional message or requirements...")
                                .foregroundColor(.gray)
                    }
                }
                
                Section {
                    Button(action: submitForm) {
                        Text("Submit Request")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(form.isValid ? ISATheme.saffron : Color.gray)
                    .disabled(!form.isValid)
                }
            }
            .navigationTitle("Become a Sponsor")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
            .alert("Thank You!", isPresented: $showingSubmitAlert) {
                Button("OK", role: .cancel) {
                    isPresented = false
                }
            } message: {
                Text("Your sponsorship request has been submitted successfully.")
            }
            .alert("Tier Benefits", isPresented: $showingTierInfo) {
                Button("OK", role: .cancel) { }
            } message: {
                if let tier = selectedTierForInfo {
                    Text("\(tier.rawValue) Tier (\(tier.amount))\n\nBenefits:\n\(tier.benefits)")
                }
            }
        }
    }
    
    private func submitForm() {
        // Here we would submit the sponsorship request to a backend service
        showingSubmitAlert = true
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct AirportPickupFormView: View {
    @Binding var form: AirportPickupForm
    @Binding var isPresented: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Full Name", text: $form.fullName)
                        .textContentType(.name)
                    
                    TextField("Email", text: $form.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                    
                    TextField("Phone Number", text: $form.phone)
                        .textContentType(.telephoneNumber)
                        .keyboardType(.phonePad)
                }
                
                Section(header: Text("Flight Details")) {
                    TextField("Flight Number", text: $form.flightNumber)
                        .textCase(.uppercase)
                    
                    DatePicker("Arrival Date", selection: $form.arrivalDate, displayedComponents: .date)
                    
                    DatePicker("Arrival Time", selection: $form.arrivalTime, displayedComponents: .hourAndMinute)
                }
                
                Section(header: Text("Additional Information")) {
                    Stepper("Number of Bags: \(form.numberOfBags)", value: $form.numberOfBags, in: 1...5)
                    
                    TextEditor(text: $form.additionalNotes)
                        .frame(height: 100)
                }
                
                Section {
                    Button(action: submitForm) {
                        Text("Submit Request")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                    }
                    .listRowBackground(form.isValid ? ISATheme.saffron : Color.gray)
                    .disabled(!form.isValid)
                }
            }
            .navigationTitle("Airport Pickup Request")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            })
        }
    }
    
    private func submitForm() {
        // Here we'll submit to the Microsoft Form
        if let url = URL(string: "https://forms.office.com/r/pFCGev576R") {
            UIApplication.shared.open(url)
        }
        isPresented = false
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        // No update needed
    }
}

#Preview {
    FormsView()
} 