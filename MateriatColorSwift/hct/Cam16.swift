//
//  ColorUtils.swift
//  material-color-utilities
//
//  Created by nao on 2021/12/07.
//

import Foundation


/// CAM16, a color appearance model. Colors are not just defined by their hex
/// code, but rather, a hex code and viewing conditions.
///
/// CAM16 instances also have coordinates in the CAM16-UCS space, called J*, a*,
/// b*, or jstar, astar, bstar in code. CAM16-UCS is included in the CAM16
/// specification, and should be used when measuring distances between colors.
///
/// In traditional color spaces, a color can be identified solely by the
/// observer's measurement of the color. Color appearance models such as CAM16
/// also use information about the environment where the color was
/// observed, known as the viewing conditions.
///
/// For example, white under the traditional assumption of a midday sun white
/// point is accurately measured as a slightly chromatic blue by CAM16.
/// (roughly, hue 203, chroma 3, lightness 100)
/// CAM16, a color appearance model. Colors are not just defined by their hex
/// code, but rather, a hex code and viewing conditions.
///
/// CAM16 instances also have coordinates in the CAM16-UCS space, called J*, a*,
/// b*, or jstar, astar, bstar in code. CAM16-UCS is included in the CAM16
/// specification, and should be used when measuring distances between colors.
///
/// In traditional color spaces, a color can be identified solely by the
/// observer's measurement of the color. Color appearance models such as CAM16
/// also use information about the environment where the color was
/// observed, known as the viewing conditions.
///
/// For example, white under the traditional assumption of a midday sun white
/// point is accurately measured as a slightly chromatic blue by CAM16.
/// (roughly, hue 203, chroma 3, lightness 100)
public struct Cam16 {
    /// Like red, orange, yellow, green, etc.
    public let hue: Double
    
    /// Informally, colorfulness / color intensity. Like saturation in HSL,
    /// except perceptually accurate.
    public let chroma: Double
    
    /// Lightness
    public let j: Double
    
    /// Brightness; ratio of lightness to white point's lightness
    public let q: Double
    
    /// Colorfulness
    public let m: Double
    
    /// Saturation; ratio of chroma to white point's chroma
    public let s: Double
    
    /// CAM16-UCS J coordinate
    public let jstar: Double
    
    /// CAM16-UCS a coordinate
    public let astar: Double
    
    /// CAM16-UCS b coordinate
    public let bstar: Double
    
    /// All of the CAM16 dimensions can be calculated from 3 of the dimensions, in
    /// the following combinations:
    ///     -  {j or q} and {c, m, or s} and hue
    ///     - jstar, astar, bstar
    /// Prefer using a static method that constructs from 3 of those dimensions.
    /// This constructor is intended for those methods to use to return all
    /// possible dimensions.
    
    /// CAM16 instances also have coordinates in the CAM16-UCS space, called J*,
    /// a*, b*, or jstar, astar, bstar in code. CAM16-UCS is included in the CAM16
    /// specification, and should be used when measuring distances between colors.
    func distance(to other: Cam16) -> Double {
        let dJ = jstar - other.jstar
        let dA = astar - other.astar
        let dB = bstar - other.bstar
        let dEPrime = sqrt(dJ * dJ + dA * dA + dB * dB)
        let dE = 1.41 * pow(dEPrime, 0.63)
        return dE;
    }
    
    /// Convert [argb] to CAM16, assuming the color was viewed in default viewing
    /// conditions.
    public static func fromInt(argb: Int) -> Cam16 {
        return fromIntInViewingConditions(argb: argb,
                                          viewingConditions: ViewingConditions.sRgb);
    }
    
    /// Given [viewingConditions], convert [argb] to CAM16.
    static func fromIntInViewingConditions(argb: Int,
                                           viewingConditions: ViewingConditions) -> Cam16 {
            // Transform ARGB int to XYZ
            let xyz = ColorUtils.xyzFrom(argb: argb)
            let x = xyz[0]
            let y = xyz[1]
            let z = xyz[2]
            
            // Transform XYZ to 'cone'/'rgb' responses
            
            let rC = 0.401288 * x + 0.650173 * y - 0.051461 * z
            let gC = -0.250268 * x + 1.204414 * y + 0.045854 * z
            let bC = -0.002079 * x + 0.048952 * y + 0.953127 * z
            
            // Discount illuminant
            let rD = viewingConditions.rgbD[0] * rC
            let gD = viewingConditions.rgbD[1] * gC
            let bD = viewingConditions.rgbD[2] * bC
            
            // chromatic adaptation
            let rAF = pow(viewingConditions.fl * abs(rD) / 100.0, 0.42)
            let gAF = pow(viewingConditions.fl * abs(gD) / 100.0, 0.42)
            let bAF = pow(viewingConditions.fl * abs(bD) / 100.0, 0.42)
            let rA = Double(MathUtils.signum(rD)) * 400.0 * rAF / (rAF + 27.13)
            let gA = Double(MathUtils.signum(gD)) * 400.0 * gAF / (gAF + 27.13)
            let bA = Double(MathUtils.signum(bD)) * 400.0 * bAF / (bAF + 27.13)
            
            // redness-greenness
            let a = (11.0 * rA + -12.0 * gA + bA) / 11.0
            // yellowness-blueness
            let b = (rA + gA - 2.0 * bA) / 9.0
            
            // auxiliary components
            let u = (20.0 * rA + 20.0 * gA + 21.0 * bA) / 20.0
            let p2 = (40.0 * rA + 20.0 * gA + bA) / 20.0
            
            // hue
            let atan2 = atan2(b, a)
            let atanDegrees = atan2 * 180.0 / Double.pi
            let hue = atanDegrees < 0
            ? atanDegrees + 360.0
            : atanDegrees >= 360
            ? atanDegrees - 360
            : atanDegrees
            let hueRadians = hue * Double.pi / 180.0
            //assert(hue >= 0 && hue < 360, 'hue was really $hue')
            
            // achromatic response to color
            let ac = p2 * viewingConditions.nbb
            
            // CAM16 lightness and brightness
            let J = 100.0 *
            pow(ac / viewingConditions.aw,
                viewingConditions.c * viewingConditions.z);
            let Q = (4.0 / viewingConditions.c) *
            sqrt(J / 100.0) *
            (viewingConditions.aw + 4.0) *
            (viewingConditions.fLRoot)
            
            let huePrime = (hue < 20.14) ? hue + 360 : hue
            let eHue =
            (1.0 / 4.0) * (cos(huePrime * Double.pi / 180.0 + 2.0) + 3.8);
            let p1 =
            50000.0 / 13.0 * eHue * viewingConditions.nC * viewingConditions.ncb;
            let t = p1 * sqrt(a * a + b * b) / (u + 0.305);
            let alpha = pow(t, 0.9) *
            pow(
                1.64 - pow(0.29, viewingConditions.backgroundYTowhitePointY),
                0.73);
            // CAM16 chroma, colorfulness, chroma
            let C = alpha * sqrt(J / 100.0)
            let M = C * viewingConditions.fLRoot
            let s = 50.0 *
            sqrt((alpha * viewingConditions.c) / (viewingConditions.aw + 4.0))
            
            // CAM16-UCS components
            let jstar = (1.0 + 100.0 * 0.007) * J / (1.0 + 0.007 * J)
            let mstar = log(1.0 + 0.0228 * M) / 0.0228
            let astar = mstar * cos(hueRadians)
            let bstar = mstar * sin(hueRadians)
            return Cam16(hue: hue,
                         chroma: C,
                         j: J,
                         q: Q,
                         m: M,
                         s: s,
                         jstar: jstar,
                         astar: astar,
                         bstar: bstar);
        }
    
    /// Create a CAM16 color from lightness [j], chroma [c], and hue [h],
    /// assuming the color was viewed in default viewing conditions.
    static func fromJch(j: Double, c: Double, h: Double) -> Cam16 {
        return fromJchInViewingConditions(J: j,
                                          C: c,
                                          h: h,
                                          viewingConditions: ViewingConditions.sRgb);
    }
    
    /// Create a CAM16 color from lightness [j], chroma [c], and hue [h],
    /// in [viewingConditions].
    static func fromJchInViewingConditions(J: Double,
                                           C: Double,
                                           h: Double,
                                           viewingConditions: ViewingConditions) -> Cam16 {
            let Q = (4.0 / viewingConditions.c) *
            sqrt(J / 100.0) *
            (viewingConditions.aw + 4.0) *
            (viewingConditions.fLRoot)
            let M = C * viewingConditions.fLRoot
            let alpha = C / sqrt(J / 100.0)
            let s = 50.0 *
            sqrt((alpha * viewingConditions.c) / (viewingConditions.aw + 4.0))
            
            let hueRadians = h * Double.pi / 180.0
            let jstar = (1.0 + 100.0 * 0.007) * J / (1.0 + 0.007 * J)
            let mstar = 1.0 / 0.0228 * log(1.0 + 0.0228 * M)
            let astar = mstar * cos(hueRadians)
            let bstar = mstar * sin(hueRadians)
            return Cam16(hue: h,
                         chroma: C,
                         j: J,
                         q: Q,
                         m: M,
                         s: s,
                         jstar: jstar,
                         astar: astar,
                         bstar: bstar);
        }
    
    /// Create a CAM16 color from CAM16-UCS coordinates [jstar], [astar], [bstar].
    /// assuming the color was viewed in default viewing conditions.
    public static func fromUcs(jstar: Double, astar: Double, bstar: Double) -> Cam16 {
        return fromUcsInViewingConditions(
            jstar: jstar,
            astar: astar,
            bstar: bstar,
            viewingConditions: ViewingConditions.standard)
    }
    
    /// Create a CAM16 color from CAM16-UCS coordinates [jstar], [astar], [bstar].
    /// in [viewingConditions].
    public static func fromUcsInViewingConditions(jstar: Double, astar: Double,
                                           bstar: Double,viewingConditions: ViewingConditions) -> Cam16 {
        let a = astar
        let b = bstar
        let m = sqrt(a * a + b * b)
        let M = (exp(m * 0.0228) - 1.0) / 0.0228
        let c = M / viewingConditions.fLRoot
        var h = atan2(b, a) * (180.0 / Double.pi)
        if h < 0.0 {
            h += 360.0
        }
        let j = jstar / (1 - (jstar - 100) * 0.007)
        
        return Cam16.fromJchInViewingConditions(J: j, C: c, h: h, viewingConditions: viewingConditions)
    }
    
    /// ARGB representation of color, assuming the color was viewed in default
    /// viewing conditions.
    var viewedInSRgb: Int { viewed(viewingConditions: ViewingConditions.sRgb) }
    
    /// ARGB representation of a color, given the color was viewed in
    /// [viewingConditions]
    func viewed(viewingConditions: ViewingConditions) -> Int {
        let alpha =
        (chroma == 0.0 || j == 0.0) ? 0.0 : chroma / sqrt(j / 100.0)
        
        let t = pow(
            alpha /
            pow(
                1.64 -
                pow(0.29, viewingConditions.backgroundYTowhitePointY),
                0.73),
            1.0 / 0.9);
        let hRad = hue * Double.pi / 180.0
        
        let eHue = 0.25 * (cos(hRad + 2.0) + 3.8);
        let ac = viewingConditions.aw *
        pow(j / 100.0, 1.0 / viewingConditions.c / viewingConditions.z)
        let p1 =
        eHue * (50000.0 / 13.0) * viewingConditions.nC * viewingConditions.ncb
        
        let p2 = (ac / viewingConditions.nbb)
        
        let hSin = sin(hRad)
        let hCos = cos(hRad)
        
        let gamma = 23.0 *
        (p2 + 0.305) *
        t /
        (23.0 * p1 + 11 * t * hCos + 108.0 * t * hSin)
        let a = gamma * hCos
        let b = gamma * hSin
        let rA = (460.0 * p2 + 451.0 * a + 288.0 * b) / 1403.0
        let gA = (460.0 * p2 - 891.0 * a - 261.0 * b) / 1403.0
        let bA = (460.0 * p2 - 220.0 * a - 6300.0 * b) / 1403.0
        
        let rCBase = max(0, (27.13 * abs(rA)) / (400.0 - abs(rA)))
        let rC = Double(MathUtils.signum(rA)) *
          (100.0 / viewingConditions.fl) *
          pow(rCBase, 1.0 / 0.42);
        let gCBase = max(0, (27.13 * abs(gA)) / (400.0 - abs(gA)))
        let gC = Double(MathUtils.signum(gA)) *
          (100.0 / viewingConditions.fl) *
          pow(gCBase, 1.0 / 0.42)
        let bCBase = max(0, (27.13 * abs(bA)) / (400.0 - abs(bA)))
        let bC = Double(MathUtils.signum(bA)) *
          (100.0 / viewingConditions.fl) *
          pow(bCBase, 1.0 / 0.42)
        let rF = rC / viewingConditions.rgbD[0]
        let gF = gC / viewingConditions.rgbD[1]
        let bF = bC / viewingConditions.rgbD[2]
        
        let x = 1.86206786 * rF - 1.01125463 * gF + 0.14918677 * bF
        let y = 0.38752654 * rF + 0.62144744 * gF - 0.00897398 * bF
        let z = -0.01584150 * rF - 0.03412294 * gF + 1.04996444 * bF
        
        let argb = ColorUtils.argbFrom(x: x, y: y, z: z)
        return argb;
    }
}
