import Foundation

public class UseCaseExecutor {
    public init() {}

    public func execute<T>(
        useCase: BaseUseCaseProtocol,
        input: Any? = nil,
        success: ((T) -> Void)? = nil,
        failed: ((DomainException) -> Void)? = nil
    ) -> Cancellable? {
        useCase.execute(input: input) { result in
            switch result {
            case .success(let value):
                if let parsed = value as? T {
                    success?(parsed)
                } else {
                    let message = "UseCase result failed to casting into \(T.self) from \(value)"
                    failed?(.parsingError(message: message))
                }
            case .failed(let domainException):
                failed?(domainException)
            }
        }
    }
}
