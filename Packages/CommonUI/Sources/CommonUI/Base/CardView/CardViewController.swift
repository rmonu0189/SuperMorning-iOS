import UIKit

open class CardViewController: CoordinatedViewController {
    open var defaultBackground: UIColor { .background }
    open var topMargin: CGFloat { 0 }
    open var bottomMargin: CGFloat { 0 }
    open var isScrollEnabled: Bool { true }

    public var collectionView: UICollectionView

    private var bottomConstraint: NSLayoutConstraint?

    public var cards: [Card] = [] {
        didSet {
            sections = [cards]
        }
    }

    public var sections: [[Card]] = [] {
        didSet {
            var uniqueCards = [Card]()
            sections.forEach { cards in
                cards.forEach { card in
                    if uniqueCards.filter({ $0.cellType.self == card.cellType.self }).count == 0 {
                        uniqueCards.append(card)
                    }
                }
            }
            uniqueCards.forEach { card in
                collectionView.register(card.cellType.self, forCellWithReuseIdentifier: card.cellType.identifier())
            }
            collectionView.reloadData()
        }
    }

    public init() {
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionViewFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = .zero
        collectionViewFlowLayout.minimumInteritemSpacing = .zero
        
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: collectionViewFlowLayout)
        super.init(nibName: nil, bundle: nil)
        initializeUI()
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

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardObserver()
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }

    public func initializeUI() {
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.clipsToBounds = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isScrollEnabled = isScrollEnabled
        view.addSubview(collectionView)
        collectionView.pin(to: view)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        bottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomConstraint?.isActive = true
    }

    override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard previousTraitCollection != nil else { return }
        collectionView.collectionViewLayout.invalidateLayout()
    }

    open func navigationRightActions() -> [AppBarButtonItem] { [] }
    open func navigationLeftActions() -> [AppBarButtonItem] { [] }
    open func navigationRightAction() -> AppBarButtonItem? { nil }
    open func navigationLeftAction() -> AppBarButtonItem? { nil }

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
}

extension CardViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        sections[indexPath.section][indexPath.item].cellFor(collectionView, indexPath: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: topMargin, left: .zero, bottom: bottomMargin, right: .zero)
    }
}

extension CardViewController {
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHeightWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardHeightWillChange(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.3) {
                let bottomSafeArea = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
                self.bottomConstraint?.constant = -(keyboardSize.height + bottomSafeArea)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // Keyboard will  show notifications
    @objc private func keyboardWillHide(notification _: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.bottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
