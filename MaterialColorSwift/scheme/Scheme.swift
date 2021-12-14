//
//  Scheme.swift
//  material-color-utilities
//
//  Created by nao on 2021/12/08.
//

import Foundation

public struct Scheme {
    public let primary: Int
    public let onPrimary: Int
    public let primaryContainer: Int
    public let onPrimaryContainer: Int
    public let secondary: Int
    public let onSecondary: Int
    public let secondaryContainer: Int
    public let onSecondaryContainer: Int
    public let tertiary: Int
    public let onTertiary: Int
    public let tertiaryContainer: Int
    public let onTertiaryContainer: Int
    public let error: Int
    public let onError: Int
    public let errorContainer: Int
    public let onErrorContainer: Int
    public let background: Int
    public let onBackground: Int
    public let surface: Int
    public let onSurface: Int
    public let surfaceVariant: Int
    public let onSurfaceVariant: Int
    public let outline: Int
    public let shadow: Int
    public let inverseSurface: Int
    public let inverseOnSurface: Int
    public let inversePrimary: Int
    
    public static func light(color: Int) -> Scheme {
        let palette = CorePalette.of(argb: color)
        return Scheme.light(palette: palette)
    }
    public static func light(palette: CorePalette) -> Scheme {
        return Scheme(
            primary: palette.primary.getTone(40),
            onPrimary: palette.primary.getTone(100),
            primaryContainer: palette.primary.getTone(90),
            onPrimaryContainer: palette.primary.getTone(10),
            secondary: palette.secondary.getTone(40),
            onSecondary: palette.secondary.getTone(100),
            secondaryContainer: palette.secondary.getTone(90),
            onSecondaryContainer: palette.secondary.getTone(10),
            tertiary: palette.tertiary.getTone(40),
            onTertiary: palette.tertiary.getTone(100),
            tertiaryContainer: palette.tertiary.getTone(90),
            onTertiaryContainer: palette.tertiary.getTone(10),
            error: palette.error.getTone(40),
            onError: palette.error.getTone(100),
            errorContainer: palette.error.getTone(90),
            onErrorContainer: palette.error.getTone(10),
            background: palette.neutral.getTone(99),
            onBackground: palette.neutral.getTone(10),
            surface: palette.neutral.getTone(99),
            onSurface: palette.neutral.getTone(10),
            surfaceVariant: palette.neutralVariant.getTone(90),
            onSurfaceVariant: palette.neutralVariant.getTone(30),
            outline: palette.neutralVariant.getTone(50),
            shadow: palette.neutral.getTone(0),
            inverseSurface: palette.neutral.getTone(20),
            inverseOnSurface: palette.neutral.getTone(95),
            inversePrimary: palette.primary.getTone(80)
        )
    }
    
    public static func dark(color: Int) -> Scheme {
        let palette = CorePalette.of(argb: color)
        return Scheme.dark(palette: palette)
    }
    public static func dark(palette: CorePalette) -> Scheme {
        return Scheme(
            primary: palette.primary.getTone(80),
            onPrimary: palette.primary.getTone(20),
            primaryContainer: palette.primary.getTone(30),
            onPrimaryContainer: palette.primary.getTone(90),
            secondary: palette.secondary.getTone(80),
            onSecondary: palette.secondary.getTone(20),
            secondaryContainer: palette.secondary.getTone(30),
            onSecondaryContainer: palette.secondary.getTone(90),
            tertiary: palette.tertiary.getTone(80),
            onTertiary: palette.tertiary.getTone(20),
            tertiaryContainer: palette.tertiary.getTone(30),
            onTertiaryContainer: palette.tertiary.getTone(90),
            error: palette.error.getTone(80),
            onError: palette.error.getTone(20),
            errorContainer: palette.error.getTone(30),
            onErrorContainer: palette.error.getTone(80),
            background: palette.neutral.getTone(10),
            onBackground: palette.neutral.getTone(90),
            surface: palette.neutral.getTone(10),
            onSurface: palette.neutral.getTone(90),
            surfaceVariant: palette.neutralVariant.getTone(30),
            onSurfaceVariant: palette.neutralVariant.getTone(80),
            outline: palette.neutralVariant.getTone(60),
            shadow: palette.neutral.getTone(0),
            inverseSurface: palette.neutral.getTone(90),
            inverseOnSurface: palette.neutral.getTone(20),
            inversePrimary: palette.primary.getTone(40)
        )
    }
}
