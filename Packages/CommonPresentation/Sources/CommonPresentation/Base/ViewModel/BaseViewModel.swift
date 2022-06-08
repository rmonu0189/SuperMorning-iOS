import CommonDomain

public protocol BaseViewModelProtocol {
    var showException: ((DomainException) -> Void)? { get set }
    var showLoader: ((Bool) -> Void)? { get set }

    func addTask(_ task: Cancellable?)
    func cancelAllTask()
}

public class BaseViewModel: BaseViewModelProtocol {
    private var cancellableUseCases: [Cancellable] = []

    public var showException: ((DomainException) -> Void)?
    public var showLoader: ((Bool) -> Void)?

    public func addTask(_ task: Cancellable?) {
        guard let task = task else { return }
        cancellableUseCases.append(task)
    }

    public func cancelAllTask() {
        _ = cancellableUseCases.map { $0.cancel() }
        cancellableUseCases.removeAll()
    }

    deinit {
        cancelAllTask()
        print("🎈 \(String(describing: self)) deinitialized.")
    }
}
