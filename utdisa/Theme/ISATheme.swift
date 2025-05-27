import SwiftUI

struct ISATheme {
    static let saffron = Color(red: 255/255, green: 153/255, blue: 51/255)
    static let green = Color(red: 19/255, green: 136/255, blue: 8/255)
    static let navy = Color(red: 0/255, green: 0/255, blue: 128/255)
    
    static let primaryBackground = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    
    struct TextStyle {
        static let title = Font.system(size: 28, weight: .bold)
        static let heading = Font.system(size: 22, weight: .semibold)
        static let subheading = Font.system(size: 18, weight: .medium)
        static let body = Font.system(size: 16, weight: .regular)
    }
    
    struct Padding {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
    }
} 