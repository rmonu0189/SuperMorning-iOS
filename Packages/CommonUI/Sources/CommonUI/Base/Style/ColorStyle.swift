import UIKit

extension UIColor {
    static var background: UIColor { colorWithName("background") }
    static var styleBorderGray: UIColor { colorWithName("styleBorderGray") }
    static var styleTextGrey: UIColor { colorWithName("styleTextGrey") }
    static var styleTextDark: UIColor { colorWithName("styleTextDark") }
    static var styleButtonBackground: UIColor { colorWithName("styleButtonBackground") }
    static var styleButtonDisable: UIColor { colorWithName("styleButtonDisable") }
    static var styleErrorBackground: UIColor { colorWithName("styleErrorBackground") }
}

extension UIColor {
    private static func colorWithName(_ name: String) -> UIColor {
        UIColor(named: name, in: .main, compatibleWith: nil) ?? .black
    }
}
