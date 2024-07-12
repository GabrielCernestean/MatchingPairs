import Foundation

/// Model for a tile on the game board.
public class Tile {
    
    // MARK: - Properties -
    
    public var symbol: String = ""
    public var isFaceUp: Bool = false
    public var isPresent: Bool = true
    
    // MARK: - Lifecycle -
    
    public init(symbol: String) {
        self.symbol = symbol
    }
    
}
