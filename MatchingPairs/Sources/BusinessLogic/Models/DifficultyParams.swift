import Foundation

/// The model for the game difficulty parameters.
public struct DifficultyParams {
    
    // MARK: - Properties -
    
    /// The number of tiles on the board.
    public var tilesCount: Int = 0
    
    /// The time limit for completing the game.
    public var time: TimeInterval = 0.0
    
    /// The score multiplier applied according to difficulty.
    public var scoreMultiplier: Float = 1.0
    
    /// The number of rows in section.
    public var rows: (forPortrait: Int, forLandscape: Int) = (1, 1)
    
    /// The number of columns in section.
    public var columns: (forPortrait: Int, forLandscape: Int) = (1, 1)
    
    // MARK: - Lifecycle -
    
    public init() {
        
    }
    
    public init(tilesCount: Int, time: TimeInterval, scoreMultiplier: Float, rows: (forPortrait: Int, forLandscape: Int), columns: (forPortrait: Int, forLandscape: Int)) {
        self.tilesCount = tilesCount
        self.time = time
        self.scoreMultiplier = scoreMultiplier
        self.rows = rows
        self.columns = columns
    }
    
}
