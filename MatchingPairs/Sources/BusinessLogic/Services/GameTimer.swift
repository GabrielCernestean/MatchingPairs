import Foundation

/// This is a service that count from the startTime to 0 and delivers events on time change.
public class GameTimer {
    
    // MARK: - Types -
    
    public typealias Block = () -> Void
    
    // MARK: - Properties -
    
    /// The number of seconds from which the timer starts to count down.
    public private(set) var startTime: TimeInterval = 30
    
    /// The current number of seconds left.
    public private(set) var currentTime: TimeInterval = 0
    
    /// Event fired when the timer has updated.
    public var didUpdate: Block?
    
    /// Event fired when the timer has reached 0.
    public var didFinish: Block?
    
    private var step: TimeInterval = 0.2
    private var timer: Timer?
    private var lastTime: TimeInterval = 0
    
    // MARK: - Lifecycle -
    
    public init(startAt time: TimeInterval, step: TimeInterval = 0.2) {
        self.startTime = time
        self.step = step
        self.currentTime = time
    }
    
    // MARK: - Public methods -

    public func start() {
        currentTime = startTime
        startTimer()
        lastTime = Date().timeIntervalSince1970
    }
    
    public func stop() {
        invalidateTimer()
        lastTime = 0
        currentTime = 0
    }
    
    public func pause() {
        invalidateTimer()
    }
    
    public func resume() {
        lastTime = Date().timeIntervalSince1970
        startTimer()
    }
    
}

// MARK: - Private methods -

private extension GameTimer {
    
    func startTimer() {
        invalidateTimer()
        timer = Timer.scheduledTimer(withTimeInterval: step, repeats: true, block: { [weak self] timer in
            self?.updateTime()
            self?.didUpdate?()
            self?.stopIfFinished()
        })
    }
    
    func invalidateTimer() {
        guard let timer, timer.isValid else { return }
        timer.invalidate()
        self.timer = nil
    }
    
    func updateTime() {
        let now = Date().timeIntervalSince1970
        
        currentTime -= now - lastTime
        lastTime = now
    }
    
    func stopIfFinished() {
        if self.currentTime <= 0 {
            self.invalidateTimer()
            self.didFinish?()
        }
    }
}
