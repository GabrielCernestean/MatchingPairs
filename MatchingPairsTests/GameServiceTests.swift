import XCTest
@testable import MatchingPairs

final class GameServiceTests: XCTestCase {
    
    private var game: Game!
    private var gameService: GameService!
    
    override func setUpWithError() throws {
        let config = GameConfig(difficulty: .easy, theme: ThemeFactory().defaultTheme)
        game = Game(config: config)
        gameService = GameService(game: game)
    }
    
    override func tearDownWithError() throws {
        gameService = nil
        game = nil
    }
    
    func testSetupGame() {
        gameService.setupGame()
        
        XCTAssertEqual(game.gameState, .ready)
        XCTAssertEqual(game.gameResult, .none)
        XCTAssertFalse(game.tiles.isEmpty)
        XCTAssertEqual(game.stats.movesCount, 0)
        XCTAssertEqual(game.stats.matchCount, 0)
        XCTAssertEqual(game.stats.score, 0)
        XCTAssertEqual(game.stats.timeLeft, gameService.params.time)
    }
    
    func testStartGame() {
        gameService.startGame()
        
        XCTAssertEqual(game.gameState, .inProgress)
        XCTAssertTrue(gameService.timer.currentTime != 0)
        XCTAssertTrue(game.tiles.allSatisfy { !$0.isFaceUp })
    }
    
    func testStopGame() {
        gameService.startGame()
        gameService.stopGame()
        
        XCTAssertFalse(gameService.timer.currentTime != 0)
    }
    
    func testSelectTile() {
        gameService.setupGame()
        gameService.startGame()
        
        let firstIndex = 0
        let secondIndex = 1
        
        gameService.selectTile(at: firstIndex)
        XCTAssertTrue(game.tiles[firstIndex].isFaceUp)
        
        gameService.selectTile(at: secondIndex)
        
        if game.tiles[firstIndex].symbol == game.tiles[secondIndex].symbol {
            XCTAssertFalse(game.tiles[firstIndex].isPresent)
            XCTAssertFalse(game.tiles[secondIndex].isPresent)
        } else {
            XCTAssertTrue(game.tiles[firstIndex].isFaceUp)
            XCTAssertTrue(game.tiles[secondIndex].isFaceUp)
        }
    }
    
}
