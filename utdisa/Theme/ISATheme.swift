import SwiftUI

struct ISATheme {
    // Core Indian Flag Colors
    static let saffron = Color(red: 255/255, green: 153/255, blue: 51/255)
    static let green = Color(red: 19/255, green: 136/255, blue: 8/255)
    static let navy = Color(red: 0/255, green: 0/255, blue: 128/255)
    
    // Additional Indian-inspired Colors
    static let peacockBlue = Color(red: 51/255, green: 161/255, blue: 201/255)
    static let mehendi = Color(red: 141/255, green: 168/255, blue: 50/255)
    static let deepSaffron = Color(red: 229/255, green: 110/255, blue: 16/255)
    static let spiceRed = Color(red: 193/255, green: 57/255, blue: 43/255)
    
    // Background Colors - Always white, independent of system theme
    static let primaryBackground = Color.white
    static let secondaryBackground = Color(red: 248/255, green: 248/255, blue: 248/255) // Very light gray
    static let accentBackground = Color(red: 253/255, green: 247/255, blue: 237/255) // Soft cream color
    
    // Gradients
    static let indianGradient = LinearGradient(
        colors: [saffron.opacity(0.8), accentBackground, green.opacity(0.8)],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let peacockGradient = LinearGradient(
        colors: [peacockBlue, navy],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
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
    
    struct CardStyle {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 4
        static let borderWidth: CGFloat = 1
        
        static var shadowColor: Color {
            Color.black.opacity(0.1)
        }
        
        static func background(_ isSelected: Bool = false) -> some View {
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(isSelected ? accentBackground : Color.white)
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: 2)
        }
    }
    
    struct Decoration {
        static let paisleyPattern = Image("paisley") // Add a paisley pattern asset
        static let borderPattern = Image("border") // Add a decorative border asset
    }
} 