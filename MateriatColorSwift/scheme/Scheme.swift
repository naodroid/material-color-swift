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
        let core = CorePalette.of(argb: color)
        return Scheme(
            primary: core.primary.getTone(40),
            onPrimary: core.primary.getTone(100),
            primaryContainer: core.primary.getTone(90),
            onPrimaryContainer: core.primary.getTone(10),
            secondary: core.secondary.getTone(40),
            onSecondary: core.secondary.getTone(100),
            secondaryContainer: core.secondary.getTone(90),
            onSecondaryContainer: core.secondary.getTone(10),
            tertiary: core.tertiary.getTone(40),
            onTertiary: core.tertiary.getTone(100),
            tertiaryContainer: core.tertiary.getTone(90),
            onTertiaryContainer: core.tertiary.getTone(10),
            error: core.error.getTone(40),
            onError: core.error.getTone(100),
            errorContainer: core.error.getTone(90),
            onErrorContainer: core.error.getTone(10),
            background: core.neutral.getTone(99),
            onBackground: core.neutral.getTone(10),
            surface: core.neutral.getTone(99),
            onSurface: core.neutral.getTone(10),
            surfaceVariant: core.neutralVariant.getTone(90),
            onSurfaceVariant: core.neutralVariant.getTone(30),
            outline: core.neutralVariant.getTone(50),
            shadow: core.neutral.getTone(0),
            inverseSurface: core.neutral.getTone(20),
            inverseOnSurface: core.neutral.getTone(95),
            inversePrimary: core.primary.getTone(80)
        )
    }
    
    public static func dark(color: Int) -> Scheme {
        let core = CorePalette.of(argb: color)
        return Scheme(
            primary: core.primary.getTone(80),
            onPrimary: core.primary.getTone(20),
            primaryContainer: core.primary.getTone(30),
            onPrimaryContainer: core.primary.getTone(90),
            secondary: core.secondary.getTone(80),
            onSecondary: core.secondary.getTone(20),
            secondaryContainer: core.secondary.getTone(30),
            onSecondaryContainer: core.secondary.getTone(90),
            tertiary: core.tertiary.getTone(80),
            onTertiary: core.tertiary.getTone(20),
            tertiaryContainer: core.tertiary.getTone(30),
            onTertiaryContainer: core.tertiary.getTone(90),
            error: core.error.getTone(80),
            onError: core.error.getTone(20),
            errorContainer: core.error.getTone(30),
            onErrorContainer: core.error.getTone(80),
            background: core.neutral.getTone(10),
            onBackground: core.neutral.getTone(90),
            surface: core.neutral.getTone(10),
            onSurface: core.neutral.getTone(90),
            surfaceVariant: core.neutralVariant.getTone(30),
            onSurfaceVariant: core.neutralVariant.getTone(80),
            outline: core.neutralVariant.getTone(60),
            shadow: core.neutral.getTone(0),
            inverseSurface: core.neutral.getTone(90),
            inverseOnSurface: core.neutral.getTone(20),
            inversePrimary: core.primary.getTone(40)
        )
    }
}
