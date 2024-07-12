import Foundation
import LeaderBoard

public class GameViewModel {
    
    // MARK: - Types -
    
    public typealias TimerBlock = () -> Void
    public typealias TileSelectionBlock = (Int, Selection?) -> Void
    public typealias GameOverBlock = (GameResult) -> Void
    
    // MARK: - Properties -
    
    public var title: String {
        game.config.theme.title
    }
    
    public var movesText: String {
        formattedMovesText()
    }
    
    public var scoreText: String {
        formattedScoreText()
    }
    
    public var timeLeftText: String {
        formattedTimeLeftText()
    }
    
    public var gameOverText: String {
        formattedGameOverText()
    }
    
    public var startButtonTitle: String {
        formattedStartButtonTitle()
    }
    
    public var isGameOver: Bool {
        game.gameState == .over
    }
    
    public var isGameWon: Bool {
        game.gameResult == .won
    }
    
    public var tilesCount: Int {
        game.tiles.count
    }
    
    public var rowsCount: (forPortrait: Int, forLandscape: Int) {
        gameService.params.rows
    }
    
    public var columnsCount: (forPortrait: Int, forLandscape: Int) {
        gameService.params.columns
    }
    
    /// Event fired when an update is needed.
    public var didSelectTile: TileSelectionBlock?
    public var didUpdateTime: TimerBlock?
    public var didFinishGame: GameOverBlock?
    
    private var gameService: GameService
    
    // MARK: - Lifecycle -
    
    public init() {
        let config = Self.loadConfig()
        let game = Game(config: config)
        gameService = GameService(game: game)
    }
    
    // MARK: - Public Methods -
    
    public func setupGame() {
        gameService.setupGame()
        setup()
    }
    
    public func startGame() {
        gameService.startGame()
    }
    
    public func stopGame() {
        gameService.stopGame()
    }
    
    public func selectTile(at index: Int) {
        gameService.selectTile(at: index)
    }
    
    public func tileViewModel(at index: Int) -> TileViewModel {
        let tile = game.tiles[index]
        
        return TileViewModel(tile: tile, theme: game.config.theme)
    }
    
    public func coverSelection(_ selection: Selection) {
        gameService.coverSelection(selection)
    }
    
    public func saveScore(name: String) {
        LeaderboardAPI.saveNewScore(score: Score(name: name, score: String(game.stats.score)))
    }
    
}

// MARK: - Private Methods -

private extension GameViewModel {
    
    var game: Game {
        gameService.game
    }
    
    func setup() {
        gameService.didUpdateTime = { _ in
            self.didUpdateTime?()
        }
        
        gameService.didSelectTile = didSelectTile
        gameService.didFinishGame = didFinishGame
    }
    
    func formattedTimeLeftText() -> String {
        let time = Int(game.stats.timeLeft)
        
        return "Time: \(time)"
    }
    
    func formattedGameOverText() -> String {
        guard game.gameState == .over else {
            return ""
        }
        
        switch game.gameResult {
        case .none:
            return ""
        case .won:
            return "You won!"
        case .lost:
            return "Time out! \n Game Over!"
        }
    }
    
    func formattedStartButtonTitle() -> String {
        switch game.gameState {
        case .ready:
            return "Start"
        case .over:
            return gameOverButtonTitle()
        default:
            return "Restart"
        }
    }
    
    func gameOverButtonTitle() -> String {
        switch game.gameResult {
        case .none:
            return ""
        case .won:
            return "Save score"
        case .lost:
            return "Restart"
        }
    }
    
    func formattedMovesText() -> String {
        let moves = game.stats.movesCount
        
        return "Moves: \(moves)"
    }
    
    func formattedScoreText() -> String {
        let score = game.stats.score
        
        return "Score: \(score)"
    }
    
    static func loadConfig() -> GameConfig {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        if let data = defaults.data(forKey: "config"),
           let decodedConfig = try? decoder.decode(GameConfig.self, from: data) {
            return decodedConfig
        } else {
            return GameConfigFactory().defaultConfig
        }
    }
    
}
