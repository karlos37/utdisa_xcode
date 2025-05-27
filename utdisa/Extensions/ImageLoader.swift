import SwiftUI

extension String {
    var assetImageName: String {
        // Remove file extension and convert to asset-friendly name
        self.components(separatedBy: ".").first?
            .replacingOccurrences(of: " - ", with: "_")
            .replacingOccurrences(of: " ", with: "_")
            .lowercased() ?? self
    }
}

extension TeamMember {
    var profileImageName: String {
        // Convert the full name and position to asset name format
        let sanitizedPosition = position
            .replacingOccurrences(of: " ", with: "_")
            .lowercased()
        
        let sanitizedName = name
            .replacingOccurrences(of: " ", with: "_")
            .lowercased()
        
        return "\(sanitizedName)_\(sanitizedPosition)"
    }
    
    var profileImage: Image {
        Image(profileImageName)
    }
}

extension Image {
    static func teamMember(_ member: TeamMember) -> some View {
        member.profileImage
            .resizable()
            .aspectRatio(contentMode: .fill)
    }
} 