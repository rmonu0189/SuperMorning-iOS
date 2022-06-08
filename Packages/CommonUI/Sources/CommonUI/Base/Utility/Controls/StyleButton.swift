import UIKit

class StyleButton: UIButton {
    var defaultBackgroundColor: UIColor

    init(backgroundColor: UIColor = .clear) {
        defaultBackgroundColor = backgroundColor
        super.init(frame: .zero)
        self.backgroundColor = backgroundColor
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? defaultBackgroundColor : .styleButtonDisable
            setTitleColor(.white, for: .normal)
        }
    }
}
