import Foundation
import UIKit

public class TileViewModel {
    
    // MARK: - Properties -
    
    public var text: String {
        if tile.isFaceUp {
            tile.symbol
        } else {
            theme.cardSymbol
        }
    }
    
    public var color: UIColor {
        let color = theme.cardColor
        
        return UIColor(red: color.red, green: color.green, blue: color.blue, alpha: 1.0)
    }
    
    public var isVisible: Bool {
        tile.isPresent
    }
    
    public var isFaceUp: Bool {
        tile.isFaceUp
    }
    
    private let tile: Tile
    private let theme: Theme
    
    // MARK: - Lifecycle -
    
    public init(tile: Tile, theme: Theme) {
        self.tile = tile
        self.theme = theme
    }
    
}
