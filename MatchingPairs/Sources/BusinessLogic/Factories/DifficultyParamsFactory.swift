import Foundation

/// Factory for creating instances for dificulty params based on a given game difficulty.
public class DifficultyParamsFactory {
    
    // MARK: - Properties -
    
    public var veryEasyParams: DifficultyParams {
        DifficultyParams(tilesCount: 8, time: 30, scoreMultiplier: 0.5, rows: (forPortrait: 3, forLandscape: 2), columns: (forPortrait: 3, forLandscape: 4))
    }
    
    public var easyParams: DifficultyParams {
        DifficultyParams(tilesCount: 12, time: 40, scoreMultiplier: 1, rows: (forPortrait: 4, forLandscape: 2), columns: (forPortrait: 3, forLandscape: 6))
    }
    
    public var mediumParams: DifficultyParams {
        DifficultyParams(tilesCount: 16, time: 50, scoreMultiplier: 1.5, rows: (forPortrait: 4, forLandscape: 2), columns: (forPortrait: 4, forLandscape: 8))
    }
    
    public var hardParams: DifficultyParams {
        DifficultyParams(tilesCount: 20, time: 60, scoreMultiplier: 2, rows: (forPortrait: 5, forLandscape: 3), columns: (forPortrait: 4, forLandscape: 7))
    }
    
    public var veryHardParams: DifficultyParams {
        DifficultyParams(tilesCount: 30, time: 60, scoreMultiplier: 2.5, rows: (forPortrait: 6, forLandscape: 3), columns: (forPortrait: 5, forLandscape: 10))
    }
    
    // MARK: - Public methods -
    
    public func params(for gameDifficulty: GameDifficulty) -> DifficultyParams {
        return switch gameDifficulty {
        case .veryEasy:
            veryEasyParams
        case .easy:
            easyParams
        case .medium:
            mediumParams
        case .hard:
            hardParams
        case .veryHard:
            veryHardParams
        }
    }
    
}
