public enum UseCaseResult {
    case success(Any)
    case failed(DomainException)
}

public protocol Cancellable {
    func cancel()
}

public protocol BaseUseCaseProtocol {
    func execute(input: Any?, callback: @escaping (UseCaseResult) -> Void) -> Cancellable?
}

open class BaseUseCase<T: Any, R: Any>: BaseUseCaseProtocol {
    public init() {}

    func validateInput(value: Any?) -> T? {
        value as? T
    }

    open func execute(input: Any?, callback: @escaping (UseCaseResult) -> Void) -> Cancellable? {
        fatalError("UseCase execute method not implemented.")
    }
}
