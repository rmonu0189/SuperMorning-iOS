import UIKit
import CommonPresentation

open class BaseViewController: CoordinatedViewController {
    open var defaultBackground: UIColor { .background }

    public var safeAreaInsets: UIEdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    public var keyboardWillShow: ((CGFloat) -> Void)?
    public var keyboardWillHide: (() -> Void)?

    private var baseViewModel: BaseViewModelProtocol?

    public init(viewModel: BaseViewModelProtocol? = nil) {
        self.baseViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bind()
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = defaultBackground
        setupNavigationActions()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    open func navigationRightActions() -> [AppBarButtonItem] { [] }
    open func navigationLeftActions() -> [AppBarButtonItem] { [] }
    open func navigationRightAction() -> AppBarButtonItem? { nil }
    open func navigationLeftAction() -> AppBarButtonItem? { nil }

    public func addKeypadDissmissTapGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeypad))
        view.addGestureRecognizer(gesture)
    }

    @IBAction private func dismissKeypad() {
        view.endEditing(true)
    }

    private func setupNavigationActions() {
        if let action = navigationRightAction() {
            navigationItem.rightBarButtonItems = [action]
        } else {
            navigationItem.rightBarButtonItems = navigationRightActions()
        }
        if let action = navigationLeftAction() {
            navigationItem.leftBarButtonItems = [action]
        } else {
            navigationItem.leftBarButtonItems = navigationLeftActions()
        }
    }

    private func bind() {
        baseViewModel?.showException = { exception in
            ToasMessageView.show(exception: exception)
        }

        baseViewModel?.showLoader = { isShow in
            DispatchQueue.main.async {
                if isShow {
                    LoaderView.start()
                } else {
                    LoaderView.stop()
                }
            }
        }
    }
}

extension BaseViewController {
    public func listenKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    public func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    @objc private func keyboardHeightWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardWillShow?(keyboardSize.height)
        }
    }

    // Keyboard will  show notifications
    @objc private func keyboardWillHide(notification _: NSNotification) {
        keyboardWillHide?()
    }
}
