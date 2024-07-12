import Foundation

/// This is the model for the game stattistics as the game progresses.
public class GameStats {
    
    // MARK: - Properties -
    
    /// The game score
    public var score: Int = 0
    
    /// The remaining time.
    public var timeLeft: TimeInterval = 0
    
    /// The total moves made.
    public var movesCount: Int = 0
    
    /// The total matches made.
    public var matchCount: Int = 0
        
    // MARK: - Lifecycle -
    
    public init(timeLeft: TimeInterval) {
        self.timeLeft = timeLeft
    }
    
}
