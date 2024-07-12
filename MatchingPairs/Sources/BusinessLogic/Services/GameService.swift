import Foundation

/// This is a service that count from the startTime to 0 and delivers events on time change.
public class GameService {
    
    // MARK: - Types -
    
    public typealias TimerBlock = (TimeInterval) -> Void
    public typealias TileSelectionBlock = (Int, Selection?) -> Void
    public typealias GameOverBlock = (GameResult) -> Void
    
    // MARK: - Properties -
    
    public private(set) var game: Game
    public private(set) var timer: GameTimer = GameTimer(startAt: 30)
    public private(set) var params: DifficultyParams = DifficultyParams()
    
    /// Event fired when a tile is selected.
    public var didSelectTile: TileSelectionBlock?
    
    /// Event fired when the game is over.
    public var didFinishGame: GameOverBlock?
    
    /// Event fired when the time changes.
    public var didUpdateTime: TimerBlock?
    
    private var lastIndex: Int?
    private let pointsPerMatch: Int = 10
    private let pointsPerSecond: Float = 6.0
    private let penaltyPoints: Int = 3
    
    // MARK: - Lifecycle -
    
    public init(game: Game) {
        self.game = game
        
        setupDifficultyParams()
    }
    
    // MARK: - Public methods -
    
    public func setupGame() {
        setupTimer()
        setupTiles()
        setupGameStats()
        game.gameState = .ready
        game.gameResult = .none
    }
    
    public func startGame() {
        coverTiles()
        timer.start()
        game.gameState = .inProgress
    }
    
    public func stopGame() {
        timer.stop()
    }
    
    public func selectTile(at index: Int) {
        let currentTile = game.tiles[index]
        
        guard currentTile.isPresent && !currentTile.isFaceUp else {
            return
        }
        
        game.tiles[index].isFaceUp = true
        
        if let firstIndex = lastIndex {
            let firstTile = game.tiles[firstIndex]
            let isMatch = currentTile.symbol == firstTile.symbol
            let selection = Selection(firstIndex: firstIndex, lastIndex: index, isMatch: isMatch)
            
            if isMatch {
                game.tiles[firstIndex].isPresent = false
                game.tiles[index].isPresent = false
            }
            
            lastIndex = nil
            incrementMoves(isMatch: isMatch)
            updatePartialScore()
            
            if game.stats.matchCount == game.tiles.count / 2 {
                triggerGameWon()
            } else {
                didSelectTile?(index, selection)
            }
        } else {
            lastIndex = index
            didSelectTile?(index, nil)
        }
    }
    
    public func coverSelection(_ selection: Selection) {
        game.tiles[selection.firstIndex].isFaceUp = false
        game.tiles[selection.lastIndex].isFaceUp = false
    }
    
}

// MARK: - Private methods -

private extension GameService {
    
    func setupDifficultyParams() {
        let factory = DifficultyParamsFactory()
        
        params = factory.params(for: game.config.difficulty)
    }
    
    func setupTimer() {
        timer = GameTimer(startAt: params.time)
        timer.didFinish = triggerGameLost
        timer.didUpdate = updateTime
    }
    
    func setupGameStats() {
        game.stats.movesCount = 0
        game.stats.matchCount = 0
        game.stats.score = 0
        game.stats.timeLeft = params.time
    }
    
    func setupTiles() {
        let pairsCount = params.tilesCount / 2
        let symbols = game.config.theme.symbols
        
        game.tiles = []
        
        for _ in 1...pairsCount {
            let symbol = symbols.randomElement() ?? "💔"
            let tile1 = Tile(symbol: symbol)
            let tile2 = Tile(symbol: symbol)
            
            game.tiles.append(tile1)
            game.tiles.append(tile2)
        }
        
        game.tiles.shuffle()
    }
    
    func coverTiles() {
        for (index, _) in game.tiles.enumerated() {
            game.tiles[index].isFaceUp = false
        }
    }
    
    func triggerGameLost() {
        game.gameState = .over
        game.gameResult = .lost
        updateScore()
        didFinishGame?(game.gameResult)
    }
    
    func triggerGameWon() {
        timer.stop()
        game.gameState = .over
        game.gameResult = .won
        updateScore()
        didFinishGame?(game.gameResult)
    }
    
    func updateTime() {
        game.stats.timeLeft = timer.currentTime
        didUpdateTime?(game.stats.timeLeft)
    }
    
    func incrementMoves(isMatch: Bool) {
        game.stats.movesCount += 1
        
        if isMatch {
            game.stats.matchCount += 1
        }
    }
    
    func updateScore() {
        let timeLeft = max(0.0, Float(game.stats.timeLeft))
        let bonusTimeScore = Int(timeLeft * pointsPerSecond * params.scoreMultiplier)
        
        updatePartialScore()
        game.stats.score += bonusTimeScore
    }
    
    func updatePartialScore() {
        let matchScore = game.stats.matchCount * pointsPerMatch
        let wrongMoves = game.stats.movesCount - game.stats.matchCount
        let penalty = wrongMoves * penaltyPoints
        
        game.stats.score = matchScore - penalty
        game.stats.score = max(0, game.stats.score)
    }
    
}
