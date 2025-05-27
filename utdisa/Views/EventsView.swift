import SwiftUI

struct EventsView: View {
    @State private var events: [Event] = []
    @State private var selectedDate: Date = Date()
    
    var body: some View {
        NavigationView {
            List {
                // Calendar Section
                Section {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    )
                    .datePickerStyle(.graphical)
                    .tint(ISATheme.saffron)
                }
                
                // Events Section
                Section("Upcoming Events") {
                    if events.isEmpty {
                        Text("No upcoming events")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(events) { event in
                            EventRow(event: event)
                        }
                    }
                }
            }
            .navigationTitle("ISA Events")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add refresh action here
                    }) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
            }
        }
    }
}

struct EventRow: View {
    let event: Event
    
    var body: some View {
        VStack(alignment: .leading, spacing: ISATheme.Padding.small) {
            Text(event.title)
                .font(ISATheme.TextStyle.subheading)
                .foregroundColor(ISATheme.navy)
            
            Text(event.formattedDate)
                .font(ISATheme.TextStyle.body)
                .foregroundColor(.secondary)
            
            Text(event.location)
                .font(ISATheme.TextStyle.body)
                .foregroundColor(.secondary)
            
            if let registrationLink = event.registrationLink {
                Link("Register Now", destination: registrationLink)
                    .font(ISATheme.TextStyle.body)
                    .foregroundColor(ISATheme.saffron)
            }
        }
        .padding(.vertical, ISATheme.Padding.small)
    }
}

#Preview {
    EventsView()
} 