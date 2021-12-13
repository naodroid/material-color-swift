//
//  UIKitScheme.swift
//  MaterialUIColorIOS
//
//  Created by nao on 2021/12/12.
//

import Foundation
import UIKit
import MaterialColorSwift

public struct UIKitScheme {
    public let primary: UIColor
    public let onPrimary: UIColor
    public let primaryContainer: UIColor
    public let onPrimaryContainer: UIColor
    public let secondary: UIColor
    public let onSecondary: UIColor
    public let secondaryContainer: UIColor
    public let onSecondaryContainer: UIColor
    public let tertiary: UIColor
    public let onTertiary: UIColor
    public let tertiaryContainer: UIColor
    public let onTertiaryContainer: UIColor
    public let error: UIColor
    public let onError: UIColor
    public let errorContainer: UIColor
    public let onErrorContainer: UIColor
    public let background: UIColor
    public let onBackground: UIColor
    public let surface: UIColor
    public let onSurface: UIColor
    public let surfaceVariant: UIColor
    public let onSurfaceVariant: UIColor
    public let outline: UIColor
    public let shadow: UIColor
    public let inverseSurface: UIColor
    public let inverseOnSurface: UIColor
    public let inversePrimary: UIColor
    
    public init(scheme: Scheme) {
        self.primary = UIKitScheme.from(argb: scheme.primary)
        self.onPrimary = UIKitScheme.from(argb: scheme.onPrimary)
        self.primaryContainer = UIKitScheme.from(argb: scheme.primaryContainer)
        self.onPrimaryContainer = UIKitScheme.from(argb: scheme.onPrimaryContainer)
        self.secondary = UIKitScheme.from(argb: scheme.secondary)
        self.onSecondary = UIKitScheme.from(argb: scheme.onSecondary)
        self.secondaryContainer = UIKitScheme.from(argb: scheme.secondaryContainer)
        self.onSecondaryContainer = UIKitScheme.from(argb: scheme.onSecondaryContainer)
        self.tertiary = UIKitScheme.from(argb: scheme.tertiary)
        self.onTertiary = UIKitScheme.from(argb: scheme.onTertiary)
        self.tertiaryContainer = UIKitScheme.from(argb: scheme.tertiaryContainer)
        self.onTertiaryContainer = UIKitScheme.from(argb: scheme.onTertiaryContainer)
        self.error = UIKitScheme.from(argb: scheme.error)
        self.onError = UIKitScheme.from(argb: scheme.onError)
        self.errorContainer = UIKitScheme.from(argb: scheme.errorContainer)
        self.onErrorContainer = UIKitScheme.from(argb: scheme.onErrorContainer)
        self.background = UIKitScheme.from(argb: scheme.background)
        self.onBackground = UIKitScheme.from(argb: scheme.onBackground)
        self.surface = UIKitScheme.from(argb: scheme.surface)
        self.onSurface = UIKitScheme.from(argb: scheme.onSurface)
        self.surfaceVariant = UIKitScheme.from(argb: scheme.surfaceVariant)
        self.onSurfaceVariant = UIKitScheme.from(argb: scheme.onSurfaceVariant)
        self.outline = UIKitScheme.from(argb: scheme.outline)
        self.shadow = UIKitScheme.from(argb: scheme.shadow)
        self.inverseSurface = UIKitScheme.from(argb: scheme.inverseSurface)
        self.inverseOnSurface = UIKitScheme.from(argb: scheme.inverseOnSurface)
        self.inversePrimary = UIKitScheme.from(argb: scheme.inversePrimary)
    }
    
    /// convert argb int value to SwiftUI.UIColor
    public static func from(argb: Int) -> UIColor {
        let a = (argb >> 24) & 0xFF
        let r = (argb >> 16) & 0xFF
        let g = (argb >> 8) & 0xFF
        let b = (argb) & 0xFF
        
        let da = CGFloat(a) / CGFloat(255)
        let dr = CGFloat(r) / CGFloat(255)
        let dg = CGFloat(g) / CGFloat(255)
        let db = CGFloat(b) / CGFloat(255)
        
        return UIColor(red: dr, green: dg, blue: db, alpha: da)
    }
}

public extension Scheme {
    func toSwiftUI() -> UIKitScheme {
        UIKitScheme(scheme: self)
    }
}
