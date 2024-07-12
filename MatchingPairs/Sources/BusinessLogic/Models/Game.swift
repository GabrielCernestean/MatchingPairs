import Foundation

/// This is the model for the game board.
public class Game {
    
    // MARK: - Properties -
    
    /// The game configuration used to initialize a game
    public var config: GameConfig
    
    /// The list of tiles on the game board.
    public var tiles: [Tile] = []
    
    /// The current statistics for this game
    public var stats: GameStats = GameStats(timeLeft: 0)
    
    /// Current game state.
    public var gameState: GameState = .ready
    
    /// The game result. Unkown/Irrelevant state for the ongoing game.
    public var gameResult: GameResult = .none
    
    // MARK: - Lifecycle -
    
    public init(config: GameConfig) {
        self.config = config
    }
    
}
