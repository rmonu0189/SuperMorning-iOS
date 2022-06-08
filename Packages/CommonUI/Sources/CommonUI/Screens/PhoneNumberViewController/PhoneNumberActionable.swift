public protocol PhoneNumberActionable {
    var onBackAction: (() -> Void)? { get set }
    var onTermsAndConditionAction: (() -> Void)? { get set }
    var onContinueAction: ((String, String) -> Void)? { get set }
}
