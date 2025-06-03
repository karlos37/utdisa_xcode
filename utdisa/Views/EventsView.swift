import SwiftUI

struct EventsView: View {
    @State private var events: [Event] = [
        Event(
            title: "ISA Independence Day",
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 15, hour: 10))!,
            description: "Join us in celebrating India's Independence Day with cultural performances, flag hoisting ceremony, and traditional Indian refreshments.",
            location: "UTD Plinth",
            locationURL: URL(string: "https://maps.app.goo.gl/U2Y7igWRTvVXF1N1A"),
            registrationURL: URL(string: "https://utdallas.presence.io/organization/indian-students-association"),
            posterImageName: "independence_day_poster"
        ),
        Event(
            title: "ISA Ganesh Chaturthi",
            startDate: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 27, hour: 9))!,
            endDate: Calendar.current.date(from: DateComponents(year: 2024, month: 8, day: 28, hour: 17))!,
            description: "Celebrate the auspicious festival of Ganesh Chaturthi with ISA. Join us for aarti, prasad distribution, and cultural activities.",
            location: "UTD Chess Plaza",
            locationURL: URL(string: "https://maps.app.goo.gl/mnujc6rGEETHx1S87"),
            registrationURL: URL(string: "https://utdallas.presence.io/organization/indian-students-association"),
            posterImageName: "ganesh_chaturthi_poster"
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ISATheme.indianGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: ISATheme.Padding.large) {
                        // Header
                        VStack(spacing: ISATheme.Padding.medium) {
                            Text("Upcoming Events")
                                .font(ISATheme.TextStyle.title)
                                .foregroundColor(ISATheme.navy)
                            
                            Text("Join us for these exciting events!")
                                .font(ISATheme.TextStyle.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top)
                        
                        // Events List
                        LazyVStack(spacing: ISATheme.Padding.medium) {
                            ForEach(events) { event in
                                EventCard(event: event)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationTitle("Events")
        }
    }
}

struct EventCard: View {
    let event: Event
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event Poster
            Image(event.posterImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .clipped()
                .overlay(
                    // Date Badge
                    VStack {
                        Text(event.dateRangeText)
                            .font(ISATheme.TextStyle.subheading)
                            .foregroundColor(ISATheme.spiceRed)
                        Text(event.timeText)
                            .font(ISATheme.TextStyle.body)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.white)
                            .shadow(radius: 5)
                    )
                    .padding(),
                    alignment: .topLeading
                )
            
            VStack(alignment: .leading, spacing: ISATheme.Padding.medium) {
                Text(event.title)
                    .font(ISATheme.TextStyle.heading)
                    .foregroundColor(ISATheme.navy)
                
                HStack {
                    if let locationURL = event.locationURL {
                        Link(destination: locationURL) {
                            Label(event.location, systemImage: "mappin.circle.fill")
                                .font(ISATheme.TextStyle.body)
                                .foregroundColor(ISATheme.peacockBlue)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring()) {
                            isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: "chevron.down")
                            .foregroundColor(ISATheme.saffron)
                            .rotationEffect(.degrees(isExpanded ? 180 : 0))
                            .animation(.spring(), value: isExpanded)
                    }
                }
                
                if isExpanded {
                    VStack(alignment: .leading, spacing: ISATheme.Padding.medium) {
                        Text(event.description)
                            .font(ISATheme.TextStyle.body)
                            .foregroundColor(.secondary)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding()
        }
        .background(ISATheme.CardStyle.background())
        .cornerRadius(ISATheme.CardStyle.cornerRadius)
        .shadow(
            color: ISATheme.CardStyle.shadowColor,
            radius: ISATheme.CardStyle.shadowRadius
        )
    }
}

#Preview {
    EventsView()
} 