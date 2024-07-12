import Foundation

/// This is the model for the game configuration.
public class GameConfig: Codable {
    
    // MARK: - Properties -
    
    public var difficulty: GameDifficulty
    public var theme: Theme
    
    // MARK: - Lifecycle -
    
    public init(difficulty: GameDifficulty, theme: Theme) {
        self.difficulty = difficulty
        self.theme = theme
    }
}
