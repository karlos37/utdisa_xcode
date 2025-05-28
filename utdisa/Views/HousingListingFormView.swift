import SwiftUI
import PhotosUI
import Supabase

struct HousingListingFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var apartmentName = ""
    @State private var apartmentType = "1b1b"
    @State private var availability = "whole"
    @State private var rent = ""
    @State private var apartmentNumber = ""
    @State private var leaseType = "new"
    @State private var leaseMonthsLeft = ""
    @State private var isTemporary = false
    @State private var availableFrom = Date()
    @State private var availableTo = Date()
    @State private var hasAvailableFrom = false
    @State private var hasAvailableTo = false
    @State private var rentPerDay = ""
    @State private var selectedImages: [UIImage] = []
    @State private var photoPickerItems: [PhotosPickerItem] = []
    @State private var isUploading = false
    @State private var errorMessage: String?
    @State private var showErrorAlert = false
    @State private var showSuccessAlert = false

    let apartmentTypes = ["1b1b", "2b2b", "2b2.5b", "3b2b", "3b3b"]
    let availabilities = ["whole", "room"]
    let leaseTypes = ["new", "existing"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Apartment Details")) {
                    TextField("Apartment Name", text: $apartmentName)
                    Picker("Apartment Type", selection: $apartmentType) {
                        ForEach(apartmentTypes, id: \.self) { Text($0) }
                    }
                    Picker("Availability", selection: $availability) {
                        ForEach(availabilities, id: \.self) { Text($0.capitalized) }
                    }
                    TextField("Rent (per month)", text: $rent)
                        .keyboardType(.decimalPad)
                    TextField("Apartment Number", text: $apartmentNumber)
                    Picker("Lease Type", selection: $leaseType) {
                        ForEach(leaseTypes, id: \.self) { Text($0.capitalized) }
                    }
                    if leaseType == "existing" {
                        TextField("Months Left on Lease", text: $leaseMonthsLeft)
                            .keyboardType(.numberPad)
                    }
                }
                Section(header: Text("Temporary Housing")) {
                    Toggle("Is Temporary?", isOn: $isTemporary)
                    if isTemporary {
                        Toggle("Set Available From", isOn: $hasAvailableFrom)
                        if hasAvailableFrom {
                            DatePicker("Available From", selection: $availableFrom, displayedComponents: .date)
                        }
                        Toggle("Set Available To", isOn: $hasAvailableTo)
                        if hasAvailableTo {
                            DatePicker("Available To", selection: $availableTo, displayedComponents: .date)
                        }
                        TextField("Rent Per Day", text: $rentPerDay)
                            .keyboardType(.decimalPad)
                    }
                }
                Section(header: Text("Photos")) {
                    PhotosPicker(
                        selection: $photoPickerItems,
                        maxSelectionCount: 5,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Label("Select Photos", systemImage: "photo.on.rectangle")
                    }
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(selectedImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                Section {
                    Button(action: submitListing) {
                        if isUploading {
                            ProgressView()
                        } else {
                            Text("Submit Listing")
                        }
                    }
                    .disabled(isUploading)
                }
            }
            .navigationTitle("Add Housing Listing")
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage ?? "Unknown error"), dismissButton: .default(Text("OK")))
            }
            .alert(isPresented: $showSuccessAlert) {
                Alert(title: Text("Success"), message: Text("Listing uploaded!"), dismissButton: .default(Text("OK"), action: {
                    presentationMode.wrappedValue.dismiss()
                }))
            }
            .onChange(of: photoPickerItems) { newItems in
                loadImages(from: newItems)
            }
        }
    }

    private func loadImages(from items: [PhotosPickerItem]) {
        selectedImages = []
        for item in items {
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            selectedImages.append(image)
                        }
                    }
                case .failure(let error):
                    print("Failed to load image: \(error)")
                }
            }
        }
    }

    private func submitListing() {
        guard !apartmentName.isEmpty, !apartmentType.isEmpty, !availability.isEmpty, let rentValue = Double(rent), !selectedImages.isEmpty else {
            errorMessage = "Please fill all required fields and select at least one photo."
            showErrorAlert = true
            return
        }
        isUploading = true
        uploadImages(images: selectedImages) { urls in
            guard let urls = urls, !urls.isEmpty else {
                errorMessage = "Failed to upload images."
                showErrorAlert = true
                isUploading = false
                return
            }
            let listing = HousingListing(
                id: nil,
                user_id: nil, // Set if you have auth
                apartment_name: apartmentName,
                apartment_type: apartmentType,
                availability: availability,
                rent: rentValue,
                apartment_number: apartmentNumber.isEmpty ? nil : apartmentNumber,
                lease_type: leaseType,
                lease_months_left: Int(leaseMonthsLeft),
                is_temporary: isTemporary,
                available_from: hasAvailableFrom ? availableFrom : nil,
                available_to: hasAvailableTo ? availableTo : nil,
                rent_per_day: Double(rentPerDay),
                photo_urls: urls,
                created_at: nil
            )
            saveListing(listing)
        }
    }

    private func uploadImages(images: [UIImage], completion: @escaping ([String]?) -> Void) {
        let bucket = "housing-photos"
        let client = SupabaseManager.shared.client
        var urls: [String] = []
        Task {
            for image in images {
                guard let imageData = image.jpegData(compressionQuality: 0.8) else { continue }
                let fileName = "listing-\(UUID().uuidString).jpg"
                do {
                    _ = try await client.storage.from(bucket).upload(path: fileName, file: imageData, options: FileOptions(contentType: "image/jpeg"))
                    let publicUrl = "https://ygeuxkwcqqscxqomwrgo.supabase.co/storage/v1/object/public/\(bucket)/\(fileName)"
                    urls.append(publicUrl)
                } catch {
                    print("Upload failed: \(error)")
                }
            }
            DispatchQueue.main.async {
                completion(urls.count == images.count ? urls : nil)
            }
        }
    }

    private func saveListing(_ listing: HousingListing) {
        let client = SupabaseManager.shared.client
        Task {
            do {
                let _: HousingListing = try await client.database.from("housing_listings").insert(listing).single().execute().value
                isUploading = false
                showSuccessAlert = true
            } catch {
                errorMessage = "Failed to save listing: \(error.localizedDescription)"
                showErrorAlert = true
                isUploading = false
            }
        }
    }
} 