import Foundation

public enum APIEndpoint {
    case theme
    
    public var url: String {
        switch self {
        case .theme:
            return "https://firebasestorage.googleapis.com/v0/b/concentrationgame-20753.appspot.com/o/themes.json?alt=media&token=6898245a-0586-4fed-b30e-5078faeba078"
        }
    }
}
