import UIKit

enum FontStyle {
    case heading1
    case heading2
    case heading3
    case title
    case subtitle
    case subtitleBold

    var font: UIFont {
        UIFont(name: fontName, size: size) ?? .systemFont(ofSize: size, weight: .regular)
    }

    public var fontName: String {
        switch self {
        case .heading1, .heading2, .heading3, .subtitleBold:
            return "PingFangHK-Semibold"
        case .title:
            return "PingFangHK-Regular"
        case .subtitle:
            return "PingFangHK-Regular"
        }
    }

    private var size: CGFloat {
        switch self {
        case .heading1: return 22
        case .heading3: return 15
        case .title: return 17
        case .heading2: return 19
        case .subtitle, .subtitleBold: return 13
        }
    }
}

extension UIFont {
    static func withStyle(_ style: FontStyle) -> UIFont {
        style.font
    }

    static func allFonts() {
        for family in UIFont.familyNames {
            print("============ \(family) =================")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("\(name)")
            }
        }
    }
}
