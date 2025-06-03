import SwiftUI

struct AuthFlowView: View {
    @ObservedObject var authManager: AuthManager
    @Binding var showAuthFlow: Bool
    @State private var showLogin = true
    @State private var showRegister = false
    @State private var showPasswordReset = false
    
    var body: some View {
        VStack {
            if showLogin {
                LoginView(authManager: authManager, showRegister: $showRegister, showPasswordReset: $showPasswordReset, showLogin: $showLogin, showAuthFlow: $showAuthFlow)
            } else if showRegister {
                RegistrationView(authManager: authManager, showLogin: $showLogin, showRegister: $showRegister, showAuthFlow: $showAuthFlow)
            } else if showPasswordReset {
                PasswordResetView(showLogin: $showLogin)
            }
        }
        .background(ISATheme.indianGradient.ignoresSafeArea())
    }
}

struct LoginView: View {
    @ObservedObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var isLoading = false
    @State private var showSuccess = false
    @Binding var showRegister: Bool
    @Binding var showPasswordReset: Bool
    @Binding var showLogin: Bool
    @Binding var showAuthFlow: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer(minLength: 32)
            // Logo or Icon
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 64, height: 64)
                .foregroundColor(ISATheme.saffron)
                .padding(.bottom, 16)

            VStack(spacing: 24) {
                Text("Welcome Back!")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(ISATheme.navy)
                    .padding(.bottom, 4)
                Text("Sign in to your UTD ISA account")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)

                VStack(spacing: 16) {
                    TextField("UTD Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(ISATheme.saffron.opacity(0.3), lineWidth: 1)
                        )
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(ISATheme.saffron.opacity(0.3), lineWidth: 1)
                        )
                }

                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.subheadline)
                        .padding(.top, 4)
                }
                if showSuccess {
                    Text("Login successful!")
                        .foregroundColor(.green)
                        .font(.headline)
                        .padding(.top, 4)
                }

                Button(action: login) {
                    HStack {
                        Spacer()
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .bold()
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(ISATheme.peacockBlue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: ISATheme.peacockBlue.opacity(0.15), radius: 6, x: 0, y: 3)
                .disabled(isLoading)

                // DEMO LOGIN BUTTON
                Button(action: demoLogin) {
                    HStack {
                        Spacer()
                        Text("Demo Login")
                            .bold()
                        Spacer()
                    }
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
                .shadow(color: Color.green.opacity(0.15), radius: 6, x: 0, y: 3)
                .disabled(isLoading)

                HStack {
                    Button("Forgot Password?") {
                        showPasswordReset = true
                        showRegister = false
                        showLogin = false
                    }
                    .foregroundColor(ISATheme.peacockBlue)
                    Spacer()
                    Button("Register") {
                        showRegister = true
                        showLogin = false
                    }
                    .foregroundColor(ISATheme.saffron)
                }
                .font(.subheadline)
                .padding(.top, 4)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white.opacity(0.97))
                    .shadow(color: ISATheme.navy.opacity(0.08), radius: 12, x: 0, y: 6)
            )
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            Spacer()
        }
        .background(ISATheme.indianGradient.ignoresSafeArea())
    }
    
    private func login() {
        errorMessage = nil
        showSuccess = false
        guard email.lowercased().hasSuffix("@utdallas.edu") else {
            errorMessage = "Please use your @utdallas.edu email."
            return
        }
        isLoading = true
        authManager.login(email: email, password: password) { error in
            isLoading = false
            if let error = error {
                errorMessage = error
            } else {
                showSuccess = true
                // Collapse login screen after short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showAuthFlow = false
                }
            }
        }
    }
    
    // DEMO LOGIN FUNCTION
    private func demoLogin() {
        errorMessage = nil
        showSuccess = false
        isLoading = true
        // Use demo credentials (hardcoded)
        let demoEmail = "demo@utdisa.com"
        let demoPassword = "demopassword"
        authManager.login(email: demoEmail, password: demoPassword) { error in
            isLoading = false
            if let error = error {
                errorMessage = error
            } else {
                showSuccess = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showAuthFlow = false
                }
            }
        }
    }
}

struct RegistrationView: View {
    @ObservedObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phoneNumber = ""
    @State private var errorMessage: String?
    @State private var showSuccess = false
    @State private var isLoading = false
    @Binding var showLogin: Bool
    @Binding var showRegister: Bool
    @Binding var showAuthFlow: Bool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Logo or Icon
                Image(systemName: "person.crop.circle.badge.plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
                    .foregroundColor(ISATheme.saffron)
                    .padding(.top, 32)
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("Register with UTD Email")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(ISATheme.navy)
                        .padding(.bottom, 8)
                    
                    Group {
                        Text("Personal Information")
                            .font(.headline)
                            .foregroundColor(ISATheme.peacockBlue)
                        TextField("First Name", text: $firstName)
                            .autocapitalization(.words)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Last Name", text: $lastName)
                            .autocapitalization(.words)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        TextField("Phone Number", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.bottom, 4)
                    
                    Group {
                        Text("Account Information")
                            .font(.headline)
                            .foregroundColor(ISATheme.peacockBlue)
                        TextField("UTD Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.bottom, 4)
                    
                    if let error = errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .padding(.vertical, 4)
                    }
                    
                    Button(action: register) {
                        HStack {
                            Spacer()
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Register")
                                    .bold()
                            }
                            Spacer()
                        }
                    }
                    .padding()
                    .background(ISATheme.saffron)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: ISATheme.saffron.opacity(0.2), radius: 6, x: 0, y: 3)
                    .disabled(isLoading)
                    .padding(.top, 8)
                    
                    Button("Already have an account? Login") {
                        showLogin = true
                        showRegister = false
                    }
                    .foregroundColor(ISATheme.peacockBlue)
                    .padding(.top, 8)
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.white.opacity(0.95))
                        .shadow(color: ISATheme.navy.opacity(0.08), radius: 12, x: 0, y: 6)
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .background(ISATheme.indianGradient.ignoresSafeArea())
        .alert(isPresented: $showSuccess) {
            Alert(
                title: Text("Check your email!"),
                message: Text("A verification link has been sent to your UTD email. Please verify before logging in."),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func register() {
        errorMessage = nil
        guard !firstName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "First name is required."
            return
        }
        guard !lastName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Last name is required."
            return
        }
        guard !phoneNumber.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Phone number is required."
            return
        }
        guard email.lowercased().hasSuffix("@utdallas.edu") else {
            errorMessage = "Please use your @utdallas.edu email."
            return
        }
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            return
        }
        isLoading = true
        Task {
            do {
                let session = try await SupabaseManager.shared.client.auth.signUp(email: email, password: password)
                // Insert profile row
                let userIdString = (session.user.id as? UUID)?.uuidString ?? String(describing: session.user.id)
                let fullName = "\(firstName) \(lastName)"
                let profile: [String: String] = [
                    "user_id": userIdString,
                    "full_name": fullName,
                    "phone_number": phoneNumber
                ]
                do {
                    _ = try await SupabaseManager.shared.client
                        .from("profiles")
                        .insert(profile)
                        .single()
                        .execute()
                } catch let insertError as NSError {
                    // If error is 404, ignore and treat as success
                    if insertError.localizedDescription.contains("404") {
                        // Ignore
                    } else {
                        throw insertError
                    }
                }
                await authManager.refreshSession()
                DispatchQueue.main.async {
                    isLoading = false
                    showSuccess = true
                }
            } catch {
                DispatchQueue.main.async {
                    isLoading = false
                    if error.localizedDescription.contains("404") {
                        showSuccess = true
                    } else {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

struct PasswordResetView: View {
    @State private var email = ""
    @State private var message: String?
    @State private var isLoading = false
    var showLogin: Binding<Bool>? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Reset Password")
                .font(.title2)
                .bold()
            TextField("UTD Email", text: $email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Send Reset Link") {
                sendReset()
            }
            .disabled(isLoading)
            .padding()
            .background(ISATheme.peacockBlue)
            .foregroundColor(.white)
            .cornerRadius(8)
            if let message = message {
                Text(message)
                    .foregroundColor(.green)
            }
            if let showLogin = showLogin {
                Button("Back to Login") {
                    showLogin.wrappedValue = true
                }
                .foregroundColor(ISATheme.saffron)
            }
        }
        .padding()
    }
    
    private func sendReset() {
        message = nil
        isLoading = true
        Task {
            do {
                try await SupabaseManager.shared.client.auth.resetPasswordForEmail(email)
                message = "A password reset link has been sent to your email."
                isLoading = false
            } catch {
                message = error.localizedDescription
                isLoading = false
            }
        }
    }
} 
