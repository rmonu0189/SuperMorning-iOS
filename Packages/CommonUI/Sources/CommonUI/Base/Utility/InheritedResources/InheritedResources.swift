import Foundation
import UIKit

public enum InheritedResource {
    private enum Constants {
        static let tableName = "Localizable"
    }

    public static func image(_ named: String) -> UIImage? {
        UIImage(named: named, in: .module, compatibleWith: nil)
    }

    public static func localizedString(
        key: String,
        defaultValue: String
    ) -> String {
        NSLocalizedString(
            key,
            tableName: Constants.tableName,
            bundle: .module,
            value: defaultValue,
            comment: ""
        )
    }
}
