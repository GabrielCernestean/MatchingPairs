import UIKit

public class TileCell: UICollectionViewCell {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var symbol: UILabel!
    
    // MARK: - Properties-
    
    private var viewModel: TileViewModel!
    private var gameViewModel: GameViewModel!
    private let animationTime = 0.5
    
    // MARK: - Lifecycle -
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // MARK: - Public Methods -
    
    public func setup(with viewModel: TileViewModel, gameViewModel: GameViewModel) {
        self.viewModel = viewModel
        self.gameViewModel = gameViewModel
        updateUI()
    }
    
    public func updateUI() {
        updateText()
        backgroundColor = viewModel.color
        isHidden = !viewModel.isVisible
    }
    
    public func flip() {
        let transition: UIView.AnimationOptions = !viewModel.isFaceUp ? .transitionFlipFromLeft : .transitionFlipFromRight
        let options: UIView.AnimationOptions = [.showHideTransitionViews, transition]
        
        UIView.transition(with: self, duration: animationTime, options: options ) {
            self.updateText()
        }
    }
    
    public func flip(completion: @escaping () -> Void) {
        let transition: UIView.AnimationOptions = !viewModel.isFaceUp ? .transitionFlipFromLeft : .transitionFlipFromRight
        let options: UIView.AnimationOptions = [.showHideTransitionViews, transition]
                
        UIView.transition(with: self, duration: animationTime, options: options) {
            self.updateText()
        } completion: { _ in
            
            completion()
        }
    }
    
    public func dismiss(completion: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: animationTime, delay: animationTime) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5) {
                self.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
                self.alpha = 0
            }
            
        } completion: { _ in
            self.updateUI()
        }
    }
    
}

// MARK: - Private Methods -

private extension TileCell {
    
    func setupUI() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowRadius = 3
    }
    
    func updateText() {
        symbol.text = viewModel.text
    }
    
}
