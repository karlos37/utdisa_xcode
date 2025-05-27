import SwiftUI

struct EventsView: View {
    @State private var events: [Event] = []
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: ISATheme.Padding.medium) {
                    // Calendar Section
                    VStack {
                        DatePicker(
                            "Select Date",
                            selection: $selectedDate,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.graphical)
                        .tint(ISATheme.saffron)
                        .padding()
                    }
                    .background(ISATheme.CardStyle.background())
                    .padding(.horizontal)
                    
                    // Events Section
                    VStack(alignment: .leading, spacing: ISATheme.Padding.medium) {
                        Text("Upcoming Events")
                            .font(ISATheme.TextStyle.heading)
                            .foregroundColor(ISATheme.navy)
                            .padding(.horizontal)
                        
                        if events.isEmpty {
                            EmptyEventsView()
                        } else {
                            ForEach(events) { event in
                                EventCard(event: event)
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .background(
                ISATheme.indianGradient
                    .opacity(0.1)
                    .ignoresSafeArea()
            )
            .navigationTitle("ISA Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add refresh action here
                    }) {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(ISATheme.saffron)
                    }
                }
            }
        }
    }
}

struct EmptyEventsView: View {
    var body: some View {
        VStack(spacing: ISATheme.Padding.medium) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(ISATheme.saffron)
            
            Text("No upcoming events")
                .font(ISATheme.TextStyle.subheading)
                .foregroundColor(.secondary)
            
            Text("Check back later for exciting ISA events!")
                .font(ISATheme.TextStyle.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(ISATheme.Padding.large)
        .background(ISATheme.CardStyle.background())
        .padding(.horizontal)
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: ISATheme.Padding.small) {
            // Event Image
            if let imageURL = event.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Rectangle()
                        .fill(ISATheme.secondaryBackground)
                }
                .frame(height: 150)
                .clipped()
            }
            
            VStack(alignment: .leading, spacing: ISATheme.Padding.small) {
                Text(event.title)
                    .font(ISATheme.TextStyle.subheading)
                    .foregroundColor(ISATheme.navy)
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(ISATheme.saffron)
                    Text(event.formattedDate)
                        .font(ISATheme.TextStyle.body)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(ISATheme.green)
                    Text(event.location)
                        .font(ISATheme.TextStyle.body)
                        .foregroundColor(.secondary)
                }
                
                Text(event.description)
                    .font(ISATheme.TextStyle.body)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
                    .padding(.top, 4)
                
                if let registrationLink = event.registrationLink {
                    Link(destination: registrationLink) {
                        Text("Register Now")
                            .font(ISATheme.TextStyle.body.bold())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(ISATheme.peacockGradient)
                            .cornerRadius(8)
                    }
                    .padding(.top, 8)
                }
            }
            .padding()
        }
        .background(ISATheme.CardStyle.background())
        .cornerRadius(ISATheme.CardStyle.cornerRadius)
        .padding(.horizontal)
    }
}

#Preview {
    EventsView()
} 