import SwiftUI

struct EventsView: View {
    @State private var events: [Event] = Event.sampleEvents
    @State private var expandedEventID: UUID? = nil
    
    var body: some View {
        NavigationView {
            ZStack {
                ISATheme.indianGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: ISATheme.Padding.large) {
                        Color.clear.frame(height: 1)

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
                        VStack(spacing: ISATheme.Padding.medium) {
                            ForEach(events) { event in
                                EventCard(
                                    event: event,
                                    isExpanded: expandedEventID == event.id,
                                    onToggle: {
                                        withAnimation(.spring()) {
                                            if expandedEventID == event.id {
                                                expandedEventID = nil
                                            } else {
                                                expandedEventID = event.id
                                            }
                                        }
                                    }
                                )
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
    let isExpanded: Bool
    let onToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Event Poster
            Image(event.posterImageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 200)
                .background(Color.red.opacity(0.2))
                .clipped()
                // .overlay(
                //     // Date Badge
                //     VStack {
                //         Text(event.dateRangeText)
                //             .font(ISATheme.TextStyle.subheading)
                //             .foregroundColor(ISATheme.spiceRed)
                //         Text(event.timeText)
                //             .font(ISATheme.TextStyle.body)
                //             .foregroundColor(.secondary)
                //     }
                //     .padding()
                //     .background(
                //         RoundedRectangle(cornerRadius: 10)
                //             .fill(.white)
                //             .shadow(radius: 5)
                //     )
                //     .padding(),
                //     alignment: .topLeading
                // )
            
            VStack(alignment: .leading, spacing: ISATheme.Padding.medium) {
                Text(event.title)
                    .font(ISATheme.TextStyle.heading)
                    .foregroundColor(ISATheme.navy)
                    .onAppear { print("Rendering event card for: \(event.title)") }
                
                HStack {
                    if let locationURL = event.locationURL {
                        Link(destination: locationURL) {
                            Label(event.location, systemImage: "mappin.circle.fill")
                                .font(ISATheme.TextStyle.body)
                                .foregroundColor(ISATheme.peacockBlue)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: onToggle) {
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