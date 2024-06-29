import UIKit

enum ColorScheme {
    
    private struct DymanicColor {
        let dark: UIColor
        let light: UIColor
    }
    
    static var separator: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 1, green: 1, blue: 1, alpha: 0.2),
                light: UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            )
        )
    }
    
    static var overlay: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 1, green: 1, blue: 1, alpha: 0.32),
                light: UIColor(red: 0, green: 0, blue: 0, alpha: 0.06)
            )
        )
    }
    
    static var navBarBlur: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.9),
                light: UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.8)
            )
        )
    }
    
    static var labelPrimary: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                light: UIColor(red: 0, green: 0, blue: 0, alpha: 1)
            )
        )
    }
    
    static var labelSecondary: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6),
                light: UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
            )
        )
    }
    
    static var labelTertiary: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 1, green: 1, blue: 1, alpha: 0.3),
                light: UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
            )
        )
    }
    
    static var labelDisable: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 1, green: 1, blue: 1, alpha: 0.15),
                light: UIColor(red: 0, green: 0, blue: 0, alpha: 0.15)
            )
        )
    }
    
    static var red: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 1, green: 0.27, blue: 0.23, alpha: 1),
                light: UIColor(red: 1, green: 0.23, blue: 0.19, alpha: 1)
            )
        )
    }
    
    static var green: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 0.2, green: 0.84, blue: 0.29, alpha: 1),
                light: UIColor(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)
            )
        )
    }
    
    static var blue: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 0.04, green: 0.52, blue: 1, alpha: 1),
                light: UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
            )
        )
    }
    
    static var gray: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1),
                light: UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
            )
        )
    }
    
    static var grayLight: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 0.28, green: 0.28, blue: 0.29, alpha: 1),
                light: UIColor(red: 0.82, green: 0.82, blue: 0.84, alpha: 1)
            )
        )
    }
    
    static var white: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 1, green: 1, blue: 1, alpha: 1),
                light: UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            )
        )
    }
    
    static var backPrimary: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 0.09, green: 0.09, blue: 0.09, alpha: 1),
                light: UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1)
            )
        )
    }
    
    static var backSecondary: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 0.14, green: 0.14, blue: 0.16, alpha: 1),
                light: UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            )
        )
    }
    
    static var backElevated: UIColor {
        return resolveColor(
            DymanicColor(
                dark: UIColor(red: 0.23, green: 0.23, blue: 0.25, alpha: 1),
                light: UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            )
        )
    }
    
    private static func resolveColor(_ dynamicColor: DymanicColor) -> UIColor {
        return UIColor {
            $0.userInterfaceStyle == .dark ? dynamicColor.dark : dynamicColor.light
        }
    }
}
