import SwiftUI

struct AboutISAView: View {
    let socialLinks: [(name: String, url: String, asset: String)] = [
        ("Instagram", "https://www.instagram.com/utdisa/", "Instagram logo"),
        ("LinkedIn", "https://www.linkedin.com/company/indian-students-association-at-utdallas", "LinkedIn logo")
    ]
    let galleryImages: [(name: String, caption: String)] = [
        ("udaan", "Udaan - Sports Fest"),
        ("diwali", "Diwali Night"),
        ("holi", "Holi Celebration"),
        ("navratri", "Navratri Garba"),
        ("ganesh", "Ganesh Chaturthi"),
        ("airport_pickup", "Airport Pickup")
    ]
    @State private var showCopyAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ISATheme.indianGradient.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        // About Section (only once at the top)
                        VStack(alignment: .leading, spacing: 12) {
                            Text("About ISA")
                                .font(.largeTitle).bold()
                                .foregroundColor(ISATheme.navy)
                            Text("The Indian Students Association (ISA) at UTD is a vibrant student organization dedicated to celebrating Indian culture, supporting students, and building a strong community through events, volunteering, and resources.")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        // Contact Email
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Contact Email")
                                .font(.title2).bold()
                                .foregroundColor(ISATheme.saffron)
                            HStack(spacing: 12) {
                                Text("utd.isa@gmail.com")
                                    .font(.body).foregroundColor(.blue)
                                Button(action: {
                                    UIPasteboard.general.string = "utd.isa@gmail.com"
                                    showCopyAlert = true
                                }) {
                                    Image(systemName: "doc.on.doc").foregroundColor(.gray)
                                }
                                Link(destination: URL(string: "mailto:utd.isa@gmail.com")!) {
                                    Image(systemName: "envelope").foregroundColor(.gray)
                                }
                            }
                        }
                        // Social Media
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Follow us and Stay Connected")
                                .font(.title2).bold()
                                .foregroundColor(ISATheme.saffron)
                            HStack(spacing: 48) {
                                ForEach(socialLinks.indices, id: \ .self) { i in
                                    let link = socialLinks[i]
                                    Link(destination: URL(string: link.url)!) {
                                        VStack(spacing: 12) {
                                            Image(link.asset)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 60, height: 60)
                                            Text(link.name)
                                                .font(.caption)
                                                .foregroundColor(ISATheme.navy)
                                        }
                                        .padding(16)
                                        .background(Color.white.opacity(0.9))
                                        .cornerRadius(16)
                                        .shadow(radius: 4)
                                    }
                                }
                            }
                        }
                        // ISA Initiatives
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ISA Initiatives")
                                .font(.title2).bold()
                                .foregroundColor(ISATheme.saffron)
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "graduationcap.fill").foregroundColor(ISATheme.peacockBlue).font(.title2)
                                    VStack(alignment: .leading) {
                                        Text("ISA Scholarship").bold().foregroundColor(ISATheme.navy)
                                        Text("A special scholarship for Jindal School of Management students and active ISA volunteers who serve the community.")
                                            .font(.caption).foregroundColor(.secondary)
                                    }
                                }
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "airplane").foregroundColor(ISATheme.peacockBlue).font(.title2)
                                    VStack(alignment: .leading) {
                                        Text("Airport Pickup").bold().foregroundColor(ISATheme.navy)
                                        Text("ISA arranges airport pickups for new students arriving at UTD, helping them settle in comfortably.")
                                            .font(.caption).foregroundColor(.secondary)
                                    }
                                }
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: "cart.fill").foregroundColor(ISATheme.peacockBlue).font(.title2)
                                    VStack(alignment: .leading) {
                                        Text("Grocery Distribution").bold().foregroundColor(ISATheme.navy)
                                        Text("ISA organizes grocery distribution drives to support students in need and foster community well-being.")
                                            .font(.caption).foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        // Photo Gallery
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ISA Event Gallery")
                                .font(.title2).bold()
                                .foregroundColor(ISATheme.saffron)
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(galleryImages.indices, id: \ .self) { i in
                                        let img = galleryImages[i]
                                        VStack(spacing: 6) {
                                            Image(img.name)
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                                .frame(width: 140, height: 100)
                                                .clipped()
                                                .cornerRadius(14)
                                            Text(img.caption)
                                                .font(.caption)
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(ISATheme.navy)
                                        }
                                        .background(Color.white.opacity(0.8))
                                        .cornerRadius(14)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .padding()
                }
                .alert("Email copied!", isPresented: $showCopyAlert) {
                    Button("OK", role: .cancel) { }
                }
            }
            .tint(ISATheme.saffron)
        }
    }
}

#Preview {
    AboutISAView()
} 