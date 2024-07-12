import Foundation

public class StartViewModel {
    
    // MARK: - Properties -
    
    public var difficultyCount: Int {
        GameDifficulty.allCases.count
    }
    
    public var themesCount: Int {
        themes.count
    }
    
    public private(set) var selectedDifficultyIndex: Int = 0
    public private(set) var selectedThemeIndex: Int = 0
    
    private var networkService = Request(.theme)
    private var themes : [Theme] = []
    private var difficulties: [String] = []
    private var config: GameConfig = GameConfigFactory().defaultConfig
    private let configKey = "config"
    
    // MARK: - Lifecycle -
    
    public init() {
        setup()
        loadConfig()
    }
    
    // MARK: - Public methods -
    
    public func difficultyText(at index: Int) -> String {
        return difficulties[index]
    }
    
    public func themeText(at index: Int) -> String {
        return themes[index].title
    }
    
    public func selectDifficulty(at index: Int) {
        selectedDifficultyIndex = index
        config.difficulty = GameDifficulty(rawValue: difficulties[index]) ?? .easy
        saveConfig()
    }
    
    public func selectTheme(at index: Int) {
        selectedThemeIndex = index
        config.theme = themes[index]
        saveConfig()
    }
    
    public func getThemes(success: @escaping () -> Void, failure: @escaping () -> Void) {
        let defaultTheme = ThemeFactory().defaultTheme
        self.themes = [defaultTheme]
        
        self.networkService.request { result in
            switch result {
            case .success(let data):
                if let items = Theme.parse(json: data) {
                    DispatchQueue.main.async {
                        self.themes += items
                        success()
                    }
                }
            case.failure(let error):
                failure()
                print(error)
            }
        }
    }
    
    public func saveConfig() {
        let defaults = UserDefaults.standard
        let encoder = JSONEncoder()
        
        if let data = try? encoder.encode(config) {
            defaults.set(data, forKey: configKey)
        }
    }
    
    public func loadConfig() {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        
        if let data = defaults.data(forKey: configKey),
           let decodedConfig = try? decoder.decode(GameConfig.self, from: data) {
            config = decodedConfig
        } else {
            config = GameConfigFactory().defaultConfig
        }
    }
    
}

// MARK: - Private methods -

private extension StartViewModel {
    
    func setup() {
        let defaultTheme = ThemeFactory().defaultTheme
        
        themes = [defaultTheme]
        difficulties = GameDifficulty.allCases.map { $0.rawValue }
    }
    
}
