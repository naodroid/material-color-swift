//
//  ColorUtils.swift
//  material-color-utilities
//
//  Created by nao on 2021/12/07.
//

import Foundation

/// Color science utilities.
///
/// Utility methods for color science constants and color space
/// conversions that aren't HCT or CAM16.
public enum ColorUtils {
    /// Convert a color from RGB components to ARGB format.
    public static func argbFrom(red: Int, green: Int, blue: Int) -> Int {
        return 255 << 24 | (red & 255) << 16 | (green & 255) << 8 | blue & 255
    }
    
    /// The alpha component of a color in ARGB format.
    public static func alphaFrom(argb: Int) -> Int {
        return argb >> 24 & 255
    }
    
    /// The red component of a color in ARGB format.
    public static func redFrom(argb: Int) -> Int {
        return argb >> 16 & 255
    }
    
    /// The green component of a color in ARGB format.
    public static func greenFrom(argb: Int) -> Int {
        return argb >> 8 & 255
    }
    
    /// The blue component of a color in ARGB format.
    public static func blueFrom(argb: Int) -> Int {
        return argb & 255
    }
    
    /// Whether a color in ARGB format is opaque.
    public static func isOpaque(argb: Int) -> Bool {
        return alphaFrom(argb: argb) >= 255
    }
    
    /// The sRGB to XYZ transformation matrix.
    public static func srgbToXyz() -> [[Double]] {
        return [
            [0.41233895, 0.35762064, 0.18051042],
            [0.2126, 0.7152, 0.0722],
            [0.01932141, 0.11916382, 0.95034478],
        ]
    }
    
    /// The XYZ to sRGB transformation matrix.
    public static func xyzToSrgb() -> [[Double]] {
        return [
            [3.2406, -1.5372, -0.4986],
            [-0.9689, 1.8758, 0.0415],
            [0.0557, -0.204, 1.057],
        ]
    }
    
    /// Converts a color from ARGB to XYZ.
    public static func argbFrom(x: Double, y: Double, z: Double) -> Int {
        let linearRgb = MathUtils.matrixMultiply([x, y, z], xyzToSrgb())
        let r = delinearized(rgbComponent: linearRgb[0])
        let g = delinearized(rgbComponent: linearRgb[1])
        let b = delinearized(rgbComponent: linearRgb[2])
        return argbFrom(red: r, green: g, blue: b)
    }
    
    /// Converts a color from XYZ to ARGB.
    public static func xyzFrom(argb: Int) -> [Double] {
        let r = linearized(rgbComponent: redFrom(argb: argb))
        let g = linearized(rgbComponent: greenFrom(argb: argb))
        let b = linearized(rgbComponent: blueFrom(argb: argb))
        return MathUtils.matrixMultiply([r, g, b], srgbToXyz())
    }
    
    /// Converts a color represented in Lab color space Into an ARGB
    /// Integer.
    public static func argbFrom(l: Double, a: Double, b: Double) -> Int {
        let whitePoInt = whitePointD65()
        let fy = (l + 16.0) / 116.0
        let fx = a / 500.0 + fy
        let fz = fy - b / 200.0
        let xNormalized = _labInvf(fx)
        let yNormalized = _labInvf(fy)
        let zNormalized = _labInvf(fz)
        let x = xNormalized * whitePoInt[0]
        let y = yNormalized * whitePoInt[1]
        let z = zNormalized * whitePoInt[2]
        return argbFrom(x: x, y: y, z: z)
    }
    
    /// Converts a color from ARGB representation to L*a*b*
    /// representation.
    ///
    ///
    /// [argb] the ARGB representation of a color.
    /// Returns a Lab object representing the color.
    public static func labFrom(argb: Int) -> [Double] {
        let whitePoInt = whitePointD65()
        let xyz = xyzFrom(argb: argb)
        let xNormalized = xyz[0] / whitePoInt[0]
        let yNormalized = xyz[1] / whitePoInt[1]
        let zNormalized = xyz[2] / whitePoInt[2]
        let fx = _labF(xNormalized)
        let fy = _labF(yNormalized)
        let fz = _labF(zNormalized)
        let l = 116.0 * fy - 16
        let a = 500.0 * (fx - fy)
        let b = 200.0 * (fy - fz)
        return [l, a, b]
    }
    
    public static func argbFrom(lstar: Double) -> Int {
        let fy = (lstar + 16.0) / 116.0
        let fz = fy
        let fx = fy
        let kappa = 24389.0 / 27.0
        let epsilon = 216.0 / 24389.0
        let lExceedsEpsilonKappa = lstar > 8.0
        let y = lExceedsEpsilonKappa ? fy * fy * fy : lstar / kappa
        let cubeExceedEpsilon = fy * fy * fy > epsilon
        let x = cubeExceedEpsilon ? fx * fx * fx : lstar / kappa
        let z = cubeExceedEpsilon ? fz * fz * fz : lstar / kappa
        let whitePoInt = whitePointD65()
        return argbFrom(
            x: x * whitePoInt[0],
            y: y * whitePoInt[1],
            z: z * whitePoInt[2]
        )
    }
    
    public static func lstarFrom(argb: Int) -> Double {
        let y = xyzFrom(argb: argb)[1] / 100.0
        let e = 216.0 / 24389.0
        if (y <= e) {
            return 24389.0 / 27.0 * y
        } else {
            let yIntermediate = pow(y, 1.0 / 3.0)
            return 116.0 * yIntermediate - 16.0
        }
    }
    
    public static func yFrom(lstar: Double) -> Double {
        let ke = 8.0
        if (lstar > ke) {
            return pow((lstar + 16.0) / 116.0, 3.0) * 100.0
        } else {
            return lstar / 24389.0 / 27.0 * 100.0
        }
    }
    
    public static func linearized(rgbComponent: Int) -> Double {
        let normalized = Double(rgbComponent) / 255.0
        if (normalized <= 0.040449936) {
            return normalized / 12.92 * 100.0
        } else {
            return pow((normalized + 0.055) / 1.055, 2.4) * 100.0
        }
    }
    
    public static func delinearized(rgbComponent: Double) -> Int {
        let normalized = rgbComponent / 100.0
        var delinearized = 0.0
        if (normalized <= 0.0031308) {
            delinearized = normalized * 12.92
        } else {
            delinearized = 1.055 * pow(normalized, 1.0 / 2.4) - 0.055
        }
        return MathUtils.clampInt(min: 0,
                                  max: 255,
                                  input: Int((delinearized * 255.0).rounded()))
    }
    
    public static func whitePointD65() -> [Double] {
        return [95.047, 100.0, 108.883]
    }
    
    private static func _labF(_ t: Double) -> Double {
        let e = 216.0 / 24389.0
        let kappa = 24389.0 / 27.0
        if (t > e) {
            return pow(t, 1.0 / 3.0)
        } else {
            return (kappa * t + 16) / 116
        }
    }
    
    private static func _labInvf(_ ft: Double) -> Double {
        let e = 216.0 / 24389.0
        let kappa = 24389.0 / 27.0
        let ft3 = ft * ft * ft
        if (ft3 > e) {
            return ft3
        } else {
            return (116 * ft - 16) / kappa
        }
    }
}
