import Foundation

/// Game configuration factory.
public class GameConfigFactory {
    
    // MARK: - Properties -
    
    public var defaultConfig: GameConfig {
        GameConfig(difficulty: .veryEasy, theme: themeFactory.defaultTheme)
    }
    
    private let themeFactory = ThemeFactory()
    
}
