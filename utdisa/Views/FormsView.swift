import SwiftUI
import SafariServices

struct FormsView: View {
    @Binding var showAuthFlow: Bool
    @Binding var authPurpose: AuthPurpose?
    private let forms: [FormType] = [.airportPickup, .feedback, .sponsor]
    @State private var selectedForm: FormType?
    @State private var showInAppForm = false
    @State private var airportPickupForm = AirportPickupForm()
    @State private var feedbackForm = FeedbackForm()
    @State private var sponsorForm = SponsorForm()
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @EnvironmentObject var authManager: AuthManager
    
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
                                if form == .airportPickup && !(authManager.isLoggedIn && authManager.isVerified) {
                                    authPurpose = .pickupForm
                                    showAuthFlow = true
                                } else {
                                    selectedForm = form
                                    showInAppForm = true
                                }
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
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    @State private var isSubmitting = false
    private let formsService = FormsService()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Your Information")) {
                    TextField("Name", text: $form.name)
                        .textContentType(.name)
                        .autocapitalization(.words)
                        .disabled(isSubmitting)
                    
                    TextField("Email", text: $form.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disabled(isSubmitting)
                }
                
                Section(header: Text("Feedback Details")) {
                    Picker("Category", selection: $form.category) {
                        ForEach(FeedbackForm.FeedbackCategory.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .disabled(isSubmitting)
                    
                    ZStack(alignment: .topLeading) {
                        if form.message.isEmpty {
                            Text("Enter your message here...")
                                .foregroundColor(.gray)
                                .padding(.top, 8)
                                .padding(.leading, 5)
                        }
                        TextEditor(text: $form.message)
                            .frame(minHeight: 100)
                            .disabled(isSubmitting)
                    }
                }
                
                Section {
                    Button(action: submitForm) {
                        HStack {
                            Text("Submit Feedback")
                                .frame(maxWidth: .infinity)
                            if isSubmitting {
                                Spacer()
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(form.isValid ? ISATheme.saffron : Color.gray)
                    .disabled(!form.isValid || isSubmitting)
                }
            }
            .navigationTitle("Share Your Feedback")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            }
            .disabled(isSubmitting))
            .alert("Thank You!", isPresented: $showingSubmitAlert) {
                Button("OK", role: .cancel) {
                    form = FeedbackForm() // Reset form
                    isPresented = false
                }
            } message: {
                Text("Your feedback has been submitted successfully.")
            }
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .interactiveDismissDisabled(isSubmitting)
        }
    }
    
    private func submitForm() {
        guard !isSubmitting else { return }
        
        // Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                     to: nil, 
                                     from: nil, 
                                     for: nil)
        
        isSubmitting = true
        Task {
            do {
                try await formsService.submitFeedbackForm(form)
                isSubmitting = false
                showingSubmitAlert = true
            } catch {
                isSubmitting = false
                errorMessage = error.localizedDescription
                showingErrorAlert = true
            }
        }
    }
}

struct SponsorFormView: View {
    @Binding var form: SponsorForm
    @Binding var isPresented: Bool
    @State private var showingSubmitAlert = false
    @State private var showingTierInfo = false
    @State private var selectedTierForInfo: SponsorForm.SponsorshipTier?
    @State private var isSubmitting = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    private let formsService = FormsService()
    
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
                        HStack {
                            Text("Submit Request")
                                .frame(maxWidth: .infinity)
                            if isSubmitting {
                                Spacer()
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(form.isValid && !isSubmitting ? ISATheme.saffron : Color.gray)
                    .disabled(!form.isValid || isSubmitting)
                }
            }
            .navigationTitle("Become a Sponsor")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            }
            .disabled(isSubmitting))
            .alert("Thank You!", isPresented: $showingSubmitAlert) {
                Button("OK", role: .cancel) {
                    form = SponsorForm() // Reset form
                    isPresented = false
                }
            } message: {
                Text("Your sponsorship request has been submitted successfully.")
            }
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .alert("Tier Benefits", isPresented: $showingTierInfo) {
                Button("OK", role: .cancel) { }
            } message: {
                if let tier = selectedTierForInfo {
                    Text("\(tier.rawValue) Tier (\(tier.amount))\n\nBenefits:\n\(tier.benefits)")
                }
            }
            .interactiveDismissDisabled(isSubmitting)
        }
    }
    
    private func submitForm() {
        guard !isSubmitting else { return }
        
        // Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                     to: nil, 
                                     from: nil, 
                                     for: nil)
        
        isSubmitting = true
        Task {
            do {
                try await formsService.submitSponsorForm(form)
                isSubmitting = false
                showingSubmitAlert = true
            } catch {
                isSubmitting = false
                errorMessage = error.localizedDescription
                showingErrorAlert = true
            }
        }
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
    @State private var showingImageInfo = false
    @State private var showingWaiverText = false
    @State private var isSubmitting = false
    @State private var showingSubmitAlert = false
    @State private var showingErrorAlert = false
    @State private var errorMessage = ""
    private let formsService = FormsService()
    
    var body: some View {
        NavigationView {
            Form {
                // Student Verification
                Section(header: Text("Student Verification")) {
                    Toggle("I am a Fall '25 Incoming Student", isOn: $form.isSpring25Student)
                    
                    if form.isSpring25Student {
                        TextField("Acceptance Letter Image URL", text: $form.acceptanceLetterImageURL)
                            .textContentType(.URL)
                            .keyboardType(.URL)
                        
                        Button("How to upload images?") {
                            showingImageInfo = true
                        }
                        .foregroundColor(ISATheme.peacockBlue)
                    }
                }
                
                // Basic Information
                Section(header: Text("Student Information")) {
                    TextField("UTD ID", text: $form.utdId)
                        .keyboardType(.numberPad)
                    
                    TextField("UTD Email (NetID)", text: $form.utdEmail)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    TextField("First Name", text: $form.firstName)
                        .textContentType(.givenName)
                    
                    TextField("Last Name", text: $form.lastName)
                        .textContentType(.familyName)
                    
                    TextField("Email", text: $form.email)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    Picker("Gender", selection: $form.gender) {
                        ForEach(AirportPickupForm.Gender.allCases, id: \.self) { gender in
                            Text(gender.rawValue).tag(gender)
                        }
                    }
                    
                    TextField("Student Photo URL", text: $form.studentPhotoURL)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                }
                
                // Contact Information
                Section(header: Text("Contact Information")) {
                    TextField("WhatsApp Number (91xxxxxxxxxx)", text: $form.whatsappNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: form.whatsappNumber) { newValue in
                            form.whatsappNumber = AirportPickupForm.formatPhoneNumber(newValue)
                        }
                    
                    TextField("Emergency Contact (91xxxxxxxxxx)", text: $form.emergencyContact)
                        .keyboardType(.numberPad)
                        .onChange(of: form.emergencyContact) { newValue in
                            form.emergencyContact = AirportPickupForm.formatPhoneNumber(newValue)
                        }
                }
                
                // Flight Details
                Section(header: Text("Flight Details")) {
                    TextField("Flight Number", text: $form.flightNumber)
                        .textCase(.uppercase)
                    
                    DatePicker("Arrival Date", selection: $form.arrivalDate, displayedComponents: .date)
                    
                    DatePicker("Arrival Time", selection: $form.arrivalTime, displayedComponents: .hourAndMinute)
                    
                    Picker("Arrival Airport", selection: $form.arrivalAirport) {
                        ForEach(AirportPickupForm.DallasAirport.allCases, id: \.self) { airport in
                            Text(airport.rawValue).tag(airport)
                        }
                    }
                    
                    TextField("Port of Entry Airport", text: $form.portOfEntryAirport)
                        .textContentType(.location)
                    
                    TextField("Itinerary Image URL", text: $form.itineraryImageURL)
                        .textContentType(.URL)
                        .keyboardType(.URL)
                }
                
                // Baggage Information
                Section(header: Text("Baggage Information")) {
                    Stepper("Check-in Bags: \(form.checkInBagsCount)", value: $form.checkInBagsCount, in: 0...5)
                    Stepper("Cabin Bags: \(form.cabinBagsCount)", value: $form.cabinBagsCount, in: 0...3)
                }
                
                // Drop-off Location
                Section(header: Text("Drop-off Location")) {
                    TextField("Drop-off Address", text: $form.dropOffLocation)
                        .textContentType(.fullStreetAddress)
                }
                
                // Terms and Agreements
                Section(header: Text("Terms and Agreements")) {
                    Toggle("I agree to the Terms and Conditions", isOn: $form.agreesToTerms)
                    
                    Toggle("I agree to the Liability Waiver", isOn: $form.agreesToWaiver)
                    
                    Button("View Waiver") {
                        showingWaiverText = true
                    }
                    .foregroundColor(ISATheme.peacockBlue)
                }
                
                // Submit Button
                Section {
                    Button(action: submitForm) {
                        HStack {
                            Text("Submit Request")
                                .frame(maxWidth: .infinity)
                            if isSubmitting {
                                Spacer()
                                ProgressView()
                                    .tint(.white)
                            }
                        }
                        .foregroundColor(.white)
                    }
                    .listRowBackground(form.isValid && !isSubmitting ? ISATheme.saffron : Color.gray)
                    .disabled(!form.isValid || isSubmitting)
                }
            }
            .navigationTitle("Airport Pickup Request")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
            }
            .disabled(isSubmitting))
            .alert("Thank You!", isPresented: $showingSubmitAlert) {
                Button("OK", role: .cancel) {
                    form = AirportPickupForm() // Reset form
                    isPresented = false
                }
            } message: {
                Text("Your airport pickup request has been submitted successfully.")
            }
            .alert("Error", isPresented: $showingErrorAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(errorMessage)
            }
            .alert("Image Upload Instructions", isPresented: $showingImageInfo) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("1. Go to postimage.org\n2. Upload your image\n3. Copy the 'Direct Link'\n4. Paste the link in the form")
            }
            .alert("Liability Waiver", isPresented: $showingWaiverText) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("I WAIVE, RELEASE, AND DISCHARGE from any and all liability, including but not limited to, liability arising from the negligence or fault of the entities or persons released, for my death, disability, personal injury, property damage, property theft, or actions of any kind.")
            }
            .interactiveDismissDisabled(isSubmitting)
        }
    }
    
    private func submitForm() {
        guard !isSubmitting else { return }
        
        // Dismiss keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                     to: nil, 
                                     from: nil, 
                                     for: nil)
        
        isSubmitting = true
        Task {
            do {
                try await formsService.submitAirportPickupForm(form)
                isSubmitting = false
                showingSubmitAlert = true
            } catch {
                isSubmitting = false
                errorMessage = error.localizedDescription
                showingErrorAlert = true
            }
        }
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
    FormsView(showAuthFlow: .constant(false), authPurpose: .constant(nil))
} 
