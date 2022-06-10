public enum DomainException {
    case noNetwork
    case apiError(message: String)
    case useCaseInputError
    case serverError(message: String)
    case parsingError(message: String)
    case somethingWentWrong
    case genric(message: String)
    case cancelNetworkRequest
    case noSession
}
