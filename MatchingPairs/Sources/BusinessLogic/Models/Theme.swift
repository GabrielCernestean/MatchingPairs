import Foundation

/// Model for game theme
public struct Theme: Codable {
    
    // MARK: - Properties -
    
    /// The color for tiles.
    public let cardColor: CardColor
    
    /// The symbol for the back of the tiles.
    public let cardSymbol: String
    
    /// The list of symbols for the tiles.
    public var symbols: [String]
    
    /// The theme title
    public let title: String
    
    // MARK: - CodingKeys -
    
    enum CodingKeys: String, CodingKey {
        case cardColor = "card_color"
        case cardSymbol = "card_symbol"
        case symbols, title
    }
    
    static func parse(json: Data) -> [Theme]? {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode([Theme].self, from: json)
            return response
        } catch {
            print("error: ", error)
        }
        
        return nil
    }
    
}
