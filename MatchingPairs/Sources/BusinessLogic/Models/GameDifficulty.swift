import Foundation

/// The model for game difficulty.
public enum GameDifficulty: String, CaseIterable, Codable {
    case veryEasy = "Very Easy"
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
    case veryHard = "Very Hard"
}
