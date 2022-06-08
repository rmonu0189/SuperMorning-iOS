import UIKit

private extension NSAttributedString.Key {
    static let styleLabelCustomAttribute = NSAttributedString.Key("StyleLabelCustomAttribute")
}

class StyleLabel: UILabel {
    init(style: FontStyle, color: UIColor? = nil) {
        super.init(frame: .zero)
        font = style.font
        numberOfLines = 0
        if let color = color { textColor = color }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTapAction(_ tap: UITapGestureRecognizer) {
        guard let label = tap.view as? StyleLabel, label == self, tap.state == .ended else {
            return
        }
        let location = tap.location(in: label)
        processInteraction(at: location, wasTap: true)
    }

    private func processInteraction(at location: CGPoint, wasTap: Bool) {
        guard let attributedText = attributedText else { return }

        let textStorage = NSTextStorage(attributedString: attributedText)
        let textContainer = NSTextContainer(size: bounds.size)
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines
        
        let characterIndex = layoutManager.characterIndex(
            for: location,
               in: textContainer,
               fractionOfDistanceBetweenInsertionPoints: nil
        )
        if characterIndex < textStorage.length {
            if let labelLink = attributedText.attribute(
                .styleLabelCustomAttribute,
                at: characterIndex,
                effectiveRange: nil
            ) as? Link {
                labelLink.callback?()
            }
        }
    }

    public func addLinks(for links: [Link]) {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapAction(_:)))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true

        let labelText = text ?? ""
        let attributedString = NSMutableAttributedString(string: labelText)
        let coreAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor : self.textColor!,
            .font: self.font!
        ]
        attributedString.setAttributes(
            coreAttributes,
            range: NSRange(location: 0, length: labelText.count)
        )

        for link in links {
            let range = (labelText as NSString).range(of: link.text)
            if range.location != NSNotFound {
                if let attribute = link.attribute {
                    var linkAttributes: [NSAttributedString.Key: Any] = [
                        .font: attribute.font,
                        .foregroundColor: attribute.color
                    ]
                    if attribute.isUnderline {
                        linkAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue
                    }
                    linkAttributes[.styleLabelCustomAttribute] = link
                    attributedString.setAttributes(linkAttributes, range: range)
                } else {
                    var additionalAttributes = coreAttributes
                    additionalAttributes[.styleLabelCustomAttribute] = link
                    attributedString.setAttributes(additionalAttributes, range: range)
                }
            }
        }
        self.attributedText = attributedString
    }
}

extension StyleLabel {
    struct Link {
        let text: String
        let attribute: AttributedText?
        let callback: (() -> Void)?
    }

    struct AttributedText {
        let font: UIFont
        let color: UIColor
        let isUnderline: Bool

        public init(font: UIFont, color: UIColor, isUnderline: Bool = false) {
            self.font = font
            self.color = color
            self.isUnderline = isUnderline
        }
    }
}
