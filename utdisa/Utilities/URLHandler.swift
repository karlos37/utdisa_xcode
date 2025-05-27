import SwiftUI
import SafariServices

enum URLHandler {
    static func open(_ url: URL, completion: @escaping (Bool) -> Void = { _ in }) {
        if url.scheme == "tel" || url.scheme == "mailto" {
            UIApplication.shared.open(url, options: [:], completionHandler: completion)
        } else {
            // For web URLs, first try to open in Safari View Controller if available
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                let safariVC = SFSafariViewController(url: url)
                rootViewController.present(safariVC, animated: true) {
                    completion(true)
                }
            } else {
                // Fallback to opening in Safari app
                UIApplication.shared.open(url, options: [:], completionHandler: completion)
            }
        }
    }
    
    static func openInSafari(_ url: URL, completion: @escaping (Bool) -> Void = { _ in }) {
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
    
    static func validateURL(_ urlString: String) -> URL? {
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
    
    static func formatPhoneNumber(_ phone: String) -> String {
        let cleaned = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        if cleaned.count == 10 {
            let area = cleaned.prefix(3)
            let prefix = cleaned.dropFirst(3).prefix(3)
            let number = cleaned.dropFirst(6)
            return "(\(area)) \(prefix)-\(number)"
        }
        return phone
    }
    
    static func phoneURL(from phone: String) -> URL? {
        let cleaned = phone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        return URL(string: "tel://\(cleaned)")
    }
    
    static func emailURL(from email: String) -> URL? {
        return URL(string: "mailto:\(email)")
    }
} 