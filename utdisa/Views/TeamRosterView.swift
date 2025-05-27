import SwiftUI

struct TeamRosterView: View {
    @State private var teamMembers: [TeamMember] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: ISATheme.Padding.medium) {
                    if teamMembers.isEmpty {
                        Text("Team roster will be updated soon")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(teamMembers) { member in
                            TeamMemberCard(member: member)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("ISA Team")
        }
    }
}

struct TeamMemberCard: View {
    let member: TeamMember
    
    var body: some View {
        VStack {
            if let imageURL = member.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .foregroundColor(.secondary)
                }
                .frame(width: 120, height: 120)
                .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundColor(.secondary)
            }
            
            Text(member.name)
                .font(ISATheme.TextStyle.subheading)
                .foregroundColor(ISATheme.navy)
            
            Text(member.position)
                .font(ISATheme.TextStyle.body)
                .foregroundColor(.secondary)
            
            if let linkedInURL = member.linkedInURL {
                Link(destination: linkedInURL) {
                    Image("linkedin")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
        .padding()
        .background(ISATheme.secondaryBackground)
        .cornerRadius(12)
    }
}

#Preview {
    TeamRosterView()
} 