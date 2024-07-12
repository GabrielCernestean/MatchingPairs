import UIKit

public class GameViewController: UIViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gameOverLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - Properties -
    
    public var viewModel: GameViewModel = GameViewModel()
    
    private var selectedTiles: [(TileCell, IndexPath)] = []
    
    // MARK: - View lifecycle -
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
        updateUI()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        updateCellSize(for: view.bounds.size)
    }
    
    // MARK: - Alert -

    private func showAddScoreAlert(score: String) {
        let alertController = UIAlertController(title: "Your score is: \(score)", message: "", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let name = alertController.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty {
                self.viewModel.saveScore(name: name)
            } else {
                self.viewModel.saveScore(name: "Unknown")
            }
            
            self.navigationController?.popViewController(animated: false)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        present(alertController, animated: true, completion: nil)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { context in
            self.updateCellSize(for: size)
        }, completion: nil)
    }
    
    // MARK: - Actions -
    
    @IBAction func startButtonAction(_ sender: Any) {
        if viewModel.isGameWon {
            showAddScoreAlert(score: viewModel.scoreText)
        } else {
            collectionView.isUserInteractionEnabled = true
            viewModel.setupGame()
            viewModel.startGame()
            updateUI()
        }
    }
    
}

// MARK: - CollectionViewDataSource -

extension GameViewController: UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.tilesCount
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tileCell", for: indexPath) as! TileCell
        let tileViewModel = viewModel.tileViewModel(at: indexPath.row)
        
        cell.setup(with: tileViewModel, gameViewModel: viewModel)
        
        return cell
    }
    
}

// MARK: - CollectionViewDelegate -

extension GameViewController: UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.selectTile(at: indexPath.row)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
}

// MARK: - CollectionViewFlowDelegate -

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
}

// MARK: - Private Methods -

private extension GameViewController {
    
    func setupUI() {
        setupCollectionView()
    }
    
    func setupViewModel() {
        viewModel.didUpdateTime = updateTimeLeftLabel
        viewModel.didSelectTile = selectTile(index:selection:)
        viewModel.didFinishGame = gameOver(result:)
        viewModel.setupGame()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsMultipleSelection = true
        collectionView.isHidden = false
        collectionView.isUserInteractionEnabled = false
    }
    
    func updateUI() {
        updateTitleLabel()
        updateMovesLabel()
        updateScoreLabel()
        updateTimeLeftLabel()
        updateGameOverLabel()
        updateStartButton()
        updateCollectionView()
    }
    
    func updateTitleLabel() {
        titleLabel.text = viewModel.title
    }
    
    func updateMovesLabel() {
        movesLabel.text = viewModel.movesText
        movesLabel.isHidden = viewModel.isGameOver
    }
    
    func updateScoreLabel() {
        scoreLabel.text = viewModel.scoreText
        scoreLabel.isHidden = !viewModel.isGameOver
    }
    
    func updateTimeLeftLabel() {
        timerLabel.text = viewModel.timeLeftText
        timerLabel.isHidden = viewModel.isGameOver
    }
    
    func updateGameOverLabel() {
        gameOverLabel.text = viewModel.gameOverText
        gameOverLabel.isHidden = !viewModel.isGameOver
    }
    
    func updateStartButton() {
        startButton.setTitle(viewModel.startButtonTitle, for: .normal)
    }
    
    func updateCollectionView() {
        collectionView.isHidden = viewModel.isGameOver
        collectionView.reloadData()
    }
    
    func updateCellSize(for size: CGSize) {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        let isPortrait = size.height > size.width
        let rowsCount = isPortrait ? CGFloat(viewModel.rowsCount.forPortrait) : CGFloat(viewModel.rowsCount.forLandscape)
        let columnsCount = isPortrait ? CGFloat(viewModel.columnsCount.forPortrait) : CGFloat(viewModel.columnsCount.forLandscape)
        let height = calculateAvailableHeight(rows: rowsCount) / rowsCount
        let width = calculateAvailableWidth(columns: columnsCount) / columnsCount
        
        layout.itemSize = CGSize(width: width, height: height )
        layout.invalidateLayout()
    }
    
    func calculateAvailableWidth(columns: CGFloat) -> CGFloat {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let minimumInteritemSpacing = columns * 16.0
            let sectionInsets = layout.sectionInset
            let collectionViewWidth = collectionView.bounds.width
            let totalSpacing = sectionInsets.left + sectionInsets.right + minimumInteritemSpacing
            let availableWidth = collectionViewWidth - totalSpacing
            
            return availableWidth
        }
        
        return 0
    }
    
    func calculateAvailableHeight(rows: CGFloat) -> CGFloat {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let minimumInteritemSpacing = rows * 16.0
            let sectionInsets = layout.sectionInset
            let collectionViewHeight = collectionView.bounds.height
            let totalSpacing = sectionInsets.top + sectionInsets.bottom + minimumInteritemSpacing
            let availableHeight = collectionViewHeight -  totalSpacing
            
            return availableHeight
        }
        
        return 0
    }
    
    func selectTile(index: Int, selection: Selection?) {
        guard let selection else {
            let cell = collectionView.cellForItem(at: IndexPath(row: index, section: 0)) as! TileCell
            cell.flip()
            return
        }
        
        let cell1 = collectionView.cellForItem(at: IndexPath(row: selection.firstIndex, section: 0)) as! TileCell
        let cell2 = collectionView.cellForItem(at: IndexPath(row: selection.lastIndex, section: 0)) as! TileCell
        
        if selection.isMatch {
            cell2.flip {
                cell1.dismiss {}
                cell2.dismiss {}
            }
        } else {
            cell2.flip {
                self.viewModel.coverSelection(selection)
                cell1.flip()
                cell2.flip()
            }
        }
        
        updateMovesLabel()
        updateScoreLabel()
    }
    
    func gameOver(result: GameResult) {
        updateUI()
    }
    
}
