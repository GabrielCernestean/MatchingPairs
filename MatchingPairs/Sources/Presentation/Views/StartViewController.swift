import UIKit
import LeaderBoard

public class StartViewController: UIViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var gameLevelPicker: UIPickerView!
    @IBOutlet weak var gameThemePicker: UIPickerView!
    
    // MARK: - Properties -
    
    private var viewModel: StartViewModel = StartViewModel()
    
    // MARK: - Lifecycle -
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        updateUI()
        loadThemes()
    }
    
    // MARK: - Actions -
    
    @IBAction func showLeaderBoard(_ sender: Any) {
        LeaderboardAPI.displayLeaderboard(viewController: self)
    }
    
}

// MARK: - PickerViewDelegate -

extension StartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == gameLevelPicker {
            viewModel.difficultyCount
        } else {
            viewModel.themesCount
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == gameLevelPicker {
             viewModel.difficultyText(at: row)
        } else {
             viewModel.themeText(at: row)
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == gameLevelPicker {
            viewModel.selectDifficulty(at: row)
        } else {
            viewModel.selectTheme(at: row)
        }
    }
    
}

// MARK: - Private Methods -

private extension StartViewController {
    
    func setupUI() {
        gameLevelPicker.delegate = self
        gameLevelPicker.dataSource = self
        gameThemePicker.delegate = self
        gameThemePicker.dataSource = self
    }
    
    func updateUI() {
        gameLevelPicker.selectRow(viewModel.selectedThemeIndex, inComponent: 0, animated: false)
        gameThemePicker.selectRow(viewModel.selectedThemeIndex, inComponent: 0, animated: false)
        gameLevelPicker.reloadAllComponents()
        gameThemePicker.reloadAllComponents()
    }
    
    func loadThemes() {
        viewModel.getThemes {
            self.updateUI()
        } failure: {
            self.showRetryAlert()
        }
    }
    
    func showRetryAlert() {
        let alertController = UIAlertController(title: "Error! Retrieve themes unsuccessfully.", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Retry", style: .default) { _ in
            self.loadThemes()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
}
