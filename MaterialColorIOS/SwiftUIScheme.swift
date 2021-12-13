//
//  SwiftUIScheme.swift
//  MaterialColorIOS
//
//  Created by nao on 2021/12/12.
//

#if canImport(SwiftUI)
import Foundation
import SwiftUI
import MaterialColorSwift

public struct SwiftUIScheme: Equatable {
    public let primary: Color
    public let onPrimary: Color
    public let primaryContainer: Color
    public let onPrimaryContainer: Color
    public let secondary: Color
    public let onSecondary: Color
    public let secondaryContainer: Color
    public let onSecondaryContainer: Color
    public let tertiary: Color
    public let onTertiary: Color
    public let tertiaryContainer: Color
    public let onTertiaryContainer: Color
    public let error: Color
    public let onError: Color
    public let errorContainer: Color
    public let onErrorContainer: Color
    public let background: Color
    public let onBackground: Color
    public let surface: Color
    public let onSurface: Color
    public let surfaceVariant: Color
    public let onSurfaceVariant: Color
    public let outline: Color
    public let shadow: Color
    public let inverseSurface: Color
    public let inverseOnSurface: Color
    public let inversePrimary: Color
    
    public init(scheme: Scheme) {
        self.primary = SwiftUIScheme.from(argb: scheme.primary)
        self.onPrimary = SwiftUIScheme.from(argb: scheme.onPrimary)
        self.primaryContainer = SwiftUIScheme.from(argb: scheme.primaryContainer)
        self.onPrimaryContainer = SwiftUIScheme.from(argb: scheme.onPrimaryContainer)
        self.secondary = SwiftUIScheme.from(argb: scheme.secondary)
        self.onSecondary = SwiftUIScheme.from(argb: scheme.onSecondary)
        self.secondaryContainer = SwiftUIScheme.from(argb: scheme.secondaryContainer)
        self.onSecondaryContainer = SwiftUIScheme.from(argb: scheme.onSecondaryContainer)
        self.tertiary = SwiftUIScheme.from(argb: scheme.tertiary)
        self.onTertiary = SwiftUIScheme.from(argb: scheme.onTertiary)
        self.tertiaryContainer = SwiftUIScheme.from(argb: scheme.tertiaryContainer)
        self.onTertiaryContainer = SwiftUIScheme.from(argb: scheme.onTertiaryContainer)
        self.error = SwiftUIScheme.from(argb: scheme.error)
        self.onError = SwiftUIScheme.from(argb: scheme.onError)
        self.errorContainer = SwiftUIScheme.from(argb: scheme.errorContainer)
        self.onErrorContainer = SwiftUIScheme.from(argb: scheme.onErrorContainer)
        self.background = SwiftUIScheme.from(argb: scheme.background)
        self.onBackground = SwiftUIScheme.from(argb: scheme.onBackground)
        self.surface = SwiftUIScheme.from(argb: scheme.surface)
        self.onSurface = SwiftUIScheme.from(argb: scheme.onSurface)
        self.surfaceVariant = SwiftUIScheme.from(argb: scheme.surfaceVariant)
        self.onSurfaceVariant = SwiftUIScheme.from(argb: scheme.onSurfaceVariant)
        self.outline = SwiftUIScheme.from(argb: scheme.outline)
        self.shadow = SwiftUIScheme.from(argb: scheme.shadow)
        self.inverseSurface = SwiftUIScheme.from(argb: scheme.inverseSurface)
        self.inverseOnSurface = SwiftUIScheme.from(argb: scheme.inverseOnSurface)
        self.inversePrimary = SwiftUIScheme.from(argb: scheme.inversePrimary)
    }
    
    /// convert argb int value to SwiftUI.Color
    public static func from(argb: Int) -> Color {
        let a = (argb >> 24) & 0xFF
        let r = (argb >> 16) & 0xFF
        let g = (argb >> 8) & 0xFF
        let b = (argb) & 0xFF
        
        let da = CGFloat(a) / CGFloat(255)
        let dr = CGFloat(r) / CGFloat(255)
        let dg = CGFloat(g) / CGFloat(255)
        let db = CGFloat(b) / CGFloat(255)
        
        return Color(red: dr, green: dg, blue: db).opacity(da)
    }
}

public extension Scheme {
    func toSwiftUI() -> SwiftUIScheme {
        SwiftUIScheme(scheme: self)
    }
}
#endif
