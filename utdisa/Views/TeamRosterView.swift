import SwiftUI

struct TeamRosterView: View {
    @State private var teamMembers: [TeamMember] = [
        // Executive Board
        TeamMember(
            name: "Pranav Vishnuvajjhula",
            position: "President",
            email: "pranav.vishnuvajjhula@utdallas.edu",
            bio: "Leading UTD's Indian Students Association"
        ),
        TeamMember(
            name: "Teeya Kapur",
            position: "Vice President",
            email: "teeya.kapur@utdallas.edu",
            bio: "Supporting ISA's mission and initiatives"
        ),
        TeamMember(
            name: "Jay Tarde",
            position: "General Secretary",
            email: "jay.tarde@utdallas.edu",
            bio: "Managing ISA's administrative affairs"
        ),
        TeamMember(
            name: "Nimanshu Jain",
            position: "Treasurer",
            email: "nimanshu.jain@utdallas.edu",
            bio: "Managing ISA's finances"
        ),
        TeamMember(
            name: "Saarth Shetty",
            position: "Public Relations Officer",
            email: "saarth.shetty@utdallas.edu",
            bio: "Managing public relations and communications"
        ),
        
        // Officers
        TeamMember(
            name: "Shreyas Agrawal",
            position: "Technology Officer",
            email: "shreyas.agrawal@utdallas.edu",
            bio: "Managing ISA's technical infrastructure"
        ),
        TeamMember(
            name: "Sana Dharani",
            position: "Dance Officer",
            email: "sana.dharani@utdallas.edu",
            bio: "Coordinating dance events and performances"
        ),
        TeamMember(
            name: "Mohammed Zumar Ali",
            position: "Music Officer",
            email: "mohammad.isa@utdallas.edu",
            bio: "Managing musical events and performances"
        ),
        TeamMember(
            name: "Krina Prajapati",
            position: "SOC Officer",
            email: "krina.prajapati@utdallas.edu",
            bio: "Managing Student Organization Center relations"
        ),
        TeamMember(
            name: "Amulya Vangari",
            position: "Social Media Officer",
            email: "amulya.vangari@utdallas.edu",
            bio: "Managing ISA's social media presence"
        ),
        TeamMember(
            name: "Sakitharini Karthikeyan",
            position: "Anchoring Officer",
            email: "sakitharini.karthikeyan@utdallas.edu",
            bio: "Leading event hosting and presentations"
        ),
        TeamMember(
            name: "Ashwin Kashyap",
            position: "Photography Officer",
            email: "ashwin.kashyap@utdallas.edu",
            bio: "Capturing ISA's memorable moments"
        ),
        TeamMember(
            name: "Kush Vora",
            position: "Sports Officer",
            email: "kush.vora@utdallas.edu",
            bio: "Organizing sports events and tournaments"
        ),
        TeamMember(
            name: "Mrunal Bhagyawant",
            position: "Community Manager",
            email: "mrunal.bhagyawant@utdallas.edu",
            bio: "Building and nurturing the ISA community"
        ),
        TeamMember(
            name: "Neel Dave",
            position: "Marketing Officer",
            email: "neel.dave@utdallas.edu",
            bio: "Leading ISA's marketing initiatives"
        ),
        TeamMember(
            name: "Kunal Bipin",
            position: "Outreach Officer",
            email: "kunal.bipin@utdallas.edu",
            bio: "Managing external relations and partnerships"
        ),
        TeamMember(
            name: "Jagannatha Shah",
            position: "Outreach Officer",
            email: "jagannatha.shah@utdallas.edu",
            bio: "Managing external relations and partnerships"
        ),
        
        // Events and Logistics Team
        TeamMember(
            name: "Gaurica Desai",
            position: "Events & Logistics Officer",
            email: "gaurica.desai@utdallas.edu",
            bio: "Coordinating ISA events and logistics"
        ),
        TeamMember(
            name: "Parag Garg",
            position: "Events & Logistics Officer",
            email: "parag.garg@utdallas.edu",
            bio: "Coordinating ISA events and logistics"
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                ISATheme.indianGradient.ignoresSafeArea()
                ScrollView {
                    VStack(spacing: ISATheme.Padding.large) {
                        // Header Section
                        VStack(spacing: ISATheme.Padding.medium) {
                            Text("Meet Our Team")
                                .font(ISATheme.TextStyle.title)
                                .foregroundColor(ISATheme.navy)
                            
                            Text("The dedicated individuals behind UTD Indian Students Association")
                                .font(ISATheme.TextStyle.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .padding(.top)
                        
                        // Executive Board Section
                        TeamSection(
                            title: "Executive Board",
                            members: teamMembers.filter { 
                                ["President", "Vice President", "General Secretary", "Treasurer", "Public Relations Officer"].contains($0.position)
                            }
                        )
                        
                        // Officers Section
                        TeamSection(
                            title: "Officers",
                            members: teamMembers.filter {
                                !["President", "Vice President", "General Secretary", "Treasurer", "Public Relations Officer"].contains($0.position) &&
                                !$0.position.contains("Events & Logistics")
                            }
                        )
                        
                        // Events & Logistics Team Section
                        TeamSection(
                            title: "Events & Logistics Team",
                            members: teamMembers.filter { $0.position.contains("Events & Logistics") }
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("ISA Team")
        }
    }
}

struct TeamSection: View {
    let title: String
    let members: [TeamMember]
    
    var body: some View {
        VStack(alignment: .leading, spacing: ISATheme.Padding.medium) {
            Text(title)
                .font(ISATheme.TextStyle.heading)
                .foregroundColor(ISATheme.navy)
                .padding(.horizontal)
            
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 160), spacing: ISATheme.Padding.medium)
                ],
                spacing: ISATheme.Padding.medium
            ) {
                ForEach(members) { member in
                    TeamMemberCard(member: member)
                }
            }
        }
    }
}

struct EmptyTeamView: View {
    var body: some View {
        VStack(spacing: ISATheme.Padding.medium) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 50))
                .foregroundColor(ISATheme.saffron)
            
            Text("Team roster will be updated soon")
                .font(ISATheme.TextStyle.subheading)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(ISATheme.Padding.large)
        .background(ISATheme.CardStyle.background())
    }
}

struct TeamMemberCard: View {
    let member: TeamMember
    @State private var isExpanded = false
    
    var body: some View {
        VStack {
            // Profile Image
            Image.teamMember(member)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [ISATheme.saffron, ISATheme.green],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                )
                .shadow(color: ISATheme.CardStyle.shadowColor, radius: 5)
            
            VStack(spacing: ISATheme.Padding.small) {
                Text(member.name)
                    .font(ISATheme.TextStyle.subheading)
                    .foregroundColor(ISATheme.navy)
                    .multilineTextAlignment(.center)
                
                Text(member.position)
                    .font(ISATheme.TextStyle.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                if isExpanded {
                    Text(member.bio)
                        .font(ISATheme.TextStyle.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.top, 4)
                        .transition(.opacity)
                }
                
                HStack(spacing: ISATheme.Padding.medium) {
                    Link(destination: URL(string: "mailto:\(member.email)")!) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(ISATheme.spiceRed)
                    }
                    
                    if let linkedInURL = member.linkedInURL {
                        Link(destination: linkedInURL) {
                            Image(systemName: "link")
                                .foregroundColor(ISATheme.peacockBlue)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(ISATheme.CardStyle.background())
        .cornerRadius(ISATheme.CardStyle.cornerRadius)
        .shadow(
            color: ISATheme.CardStyle.shadowColor,
            radius: ISATheme.CardStyle.shadowRadius
        )
        .onTapGesture {
            withAnimation(.spring()) {
                isExpanded.toggle()
            }
        }
    }
}

#Preview {
    TeamRosterView()
} 