//
//  Blend.swift
//  material-color-utilities
//
//  Created by nao on 2021/12/08.
//

import Foundation

/// Functions for blending in HCT and CAM16.
public class Blend {
    /// Shifts [designColor]'s hue towards [sourceColor]'s, creating a slightly
    /// warmer/coolor variant of [designColor]. Hue will shift up to 15 degrees.
    public static func harmonize(designColor: Int, sourceColor: Int) -> Int {
        let fromHct = HctColor.fromInt(argb: designColor);
        let toHct = HctColor.fromInt(argb: sourceColor)
        let differenceDegrees = MathUtils
            .differenceDegrees(fromHct.hue, toHct.hue)
        let rotationDegrees = min(differenceDegrees * 0.5, 15.0)
        
        let outputHue = MathUtils
            .sanitizeDegreesDouble(fromHct.hue + rotationDegrees
                                   * _rotationDirection(from: fromHct.hue,
                                                        to: toHct.hue)
            )
        let ret = HctColor.from(hue: outputHue,
                                chroma: fromHct.chroma,
                                tone: fromHct.tone)
        return ret.toInt()
    }
    
    /// Blends [from]'s hue in HCT toward's [to]'s hue.
    public static func hctHue(from: Int, to: Int, amount: Double) -> Int {
        let ucs = Blend.cam16ucs(from: from, to: to, amount: amount)
        let ucsCam = Cam16.fromInt(argb: ucs)
        let fromCam = Cam16.fromInt(argb: from)
        let blended = HctColor.from(hue: ucsCam.hue,
                                    chroma: fromCam.chroma,
                                    tone: ColorUtils.lstarFrom(argb: from))
        return blended.toInt()
    }
    
    /// Blend [from] and [to] in the CAM16-UCS color space.
    public static func cam16ucs(from: Int, to: Int, amount: Double) -> Int {
        let fromCam = Cam16.fromInt(argb: from)
        let toCam = Cam16.fromInt(argb: to)
        
        let fromJstar = fromCam.jstar
        let fromAstar = fromCam.astar
        let fromBstar = fromCam.bstar
        
        let toJstar = toCam.jstar
        let toAstar = toCam.astar
        let toBstar = toCam.bstar
        
        let jstar = fromJstar + (toJstar - fromJstar) * amount
        let astar = fromAstar + (toAstar - fromAstar) * amount
        let bstar = fromBstar + (toBstar - fromBstar) * amount
        
        return Cam16.fromUcs(jstar: jstar,
                             astar: astar,
                             bstar: bstar).viewedInSRgb
    }
    
    /// Sign of direction change needed to travel from one angle to another.
    ///
    /// [from] is the angle travel starts from in degrees. [to] is the ending
    /// angle, also in degrees.
    ///
    /// The return value is -1 if decreasing [from] leads to the shortest travel
    /// distance,  1 if increasing from leads to the shortest travel distance.
    private static func _rotationDirection(from: Double, to: Double) -> Double {
        let a = to - from
        let b = to - from + 360.0
        let c = to - from - 360.0
        
        let aAbs = abs(a)
        let bAbs = abs(b)
        let cAbs = abs(c)
        
        if aAbs <= bAbs && aAbs <= cAbs {
            return a >= 0.0 ? 1 : -1
        } else if bAbs <= aAbs && bAbs <= cAbs {
            return b >= 0.0 ? 1 : -1
        } else {
            return c >= 0.0 ? 1 : -1
        }
    }
}

