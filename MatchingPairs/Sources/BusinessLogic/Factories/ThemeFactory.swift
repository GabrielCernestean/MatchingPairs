import Foundation

/// The factory for theme objects.
public class ThemeFactory {
    
    // MARK: - Properties -
    
    public var defaultTheme: Theme {
        let color = CardColor(blue: 128.0, green: 128.0, red: 128.0)
        let symbols = [
            "💟", "❣️", "💔", "❤️‍🔥", "❤️‍🩹",
            "❤️", "🩷", "🧡", "💚", "💙",
            "🩵", "💜", "🤎", "🖤", "💘"
        ]
        
        return Theme(
            cardColor: color,
            cardSymbol: "♠️",
            symbols: symbols,
            title: "Hearts (default)"
        )
    }
    
}
