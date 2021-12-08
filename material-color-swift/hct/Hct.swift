//
//  ColorUtils.swift
//  material-color-utilities
//
//  Created by nao on 2021/12/07.
//

import Foundation


/// HCT, hue, chroma, and tone. A color system that provides a perceptually
/// accurate color measurement system that can also accurately render what
/// colors will appear as in different lighting environments.
public class HctColor {
    private var _hue: Double
    public var hue: Double {
        get { _hue }
        set {
            setInternalState(
                argb: getInt(
                    hue: MathUtils.sanitizeDegreesDouble(newValue),
                    chroma: _chroma,
                    lstar: _tone))
        }
    }
    private var _chroma: Double
    public var chroma: Double {
        get { _chroma }
        set {
            setInternalState(
                argb: getInt(
                    hue: MathUtils.sanitizeDegreesDouble(_hue),
                    chroma: newValue,
                    lstar: _tone))
        }
    }
    
    private var _tone: Double
    public var tone: Double {
        get { _tone }
        set {
            setInternalState(
                argb: getInt(
                    hue: MathUtils.sanitizeDegreesDouble(_hue),
                    chroma: _chroma,
                    lstar: newValue))
        }
    }
    
    private init(hue: Double, chroma: Double, tone: Double) {
        self._hue =  MathUtils.sanitizeDegreesDouble(hue)
        self._chroma = chroma
        self._tone = MathUtils.clampDouble(min: 0.0, max: 100.0, input: tone)
        setInternalState(argb: toInt());
    }
    
    /// 0 <= [hue] < 360; invalid values are corrected.
    /// 0 <= [chroma] <= ?; Informally, colorfulness. The color returned may be
    ///    lower than the requested chroma. Chroma has a different maximum for any
    ///    given hue and tone.
    /// 0 <= [tone] <= 100; informally, lightness. Invalid values are corrected.
    /// TODO: this method should be replaced with initializer.
    public static func from(hue: Double, chroma: Double, tone: Double) -> HctColor {
        return HctColor(hue: hue, chroma: chroma, tone: tone);
    }
    
    /// HCT representation of [argb].
    public static func fromInt(argb: Int) -> HctColor {
        let cam = Cam16.fromInt(argb: argb)
        let tone = ColorUtils.lstarFrom(argb: argb)
        return HctColor(hue: cam.hue, chroma: cam.chroma, tone: tone)
    }
    
    public func toInt() -> Int {
        return getInt(hue: _hue, chroma: _chroma, lstar: _tone)
    }
    
    
    private func setInternalState(argb: Int) {
        let cam = Cam16.fromInt(argb: argb);
        let tone = ColorUtils.lstarFrom(argb: argb);
        _hue = cam.hue;
        _chroma = cam.chroma;
        _tone = tone;
    }
}

/// When the delta between the floor & ceiling of a binary search for chroma is
/// less than this, the binary search terminates.
private let _chromaSearchEndpoint = 0.4;

/// The maximum color distance, in CAM16-UCS, between a requested color and the
/// color returned.
private let _deMax = 1.0;

/// The maximum difference between the requested L* and the L* returned.
private let _dlMax = 0.2;

/// The minimum color distance, in CAM16-UCS, between a requested color and an
/// 'exact' match. This allows the binary search during gamut mapping to
/// terminate much earlier when the error is infinitesimal.
private let _deMaxError = 0.000000001;

/// When the delta between the floor & ceiling of a binary search for J,
/// lightness in CAM16, is less than this, the binary search terminates.
let lightnessSearchEndpoint = 0.01;

func getInt(hue: Double, chroma: Double, lstar: Double) -> Int {
    return getIntInViewingConditions(hue: hue,
                                     chroma: chroma,
                                     lstar: lstar,
                                     frame: ViewingConditions.sRgb)
}

func getIntInViewingConditions(hue: Double,
                               chroma: Double,
                               lstar: Double,
                               frame: ViewingConditions) -> Int {
    if chroma < 1.0 || lstar.rounded() <= 0.0 || lstar.rounded() >= 100.0 {
        return ColorUtils.argbFrom(lstar: lstar)
    }
    
    let hue = hue < 0
    ? 0
    : hue > 360
    ? 360
    : hue
    
    // Perform a binary search to find a chroma low enough that lstar is
    // possible. For example, a high chroma, high L* red isn't available.
    
    // The highest chroma possible. Updated as binary search proceeds.
    var high = chroma
    
    // The guess for the current binary search iteration. Starts off at the highest chroma, thus,
    // if a color is possible at the requested chroma, the search can stop early.
    var mid = chroma
    var low = 0.0
    var isFirstLoop = true
    
    var answer: Cam16? = nil
    
    while abs(low - high) >= _chromaSearchEndpoint {
        // Given the current chroma guess, mid, and the desired hue, find J, lightness in CAM16 color
        // space, that creates a color with L* = `lstar` in L*a*b*
        let possibleAnswer = findCamByJ(hue: hue, chroma: mid, lstar: lstar, frame: frame)
        
        if isFirstLoop {
            if let ans = possibleAnswer {
                return ans.viewed(viewingConditions: frame)
            } else {
                // If this binary search iteration was the first iteration, and this point has been reached,
                // it means the requested chroma was not available at the requested hue and L*. Proceed to a
                // traditional binary search, starting at the midpoint between the requested chroma and 0.
                
                isFirstLoop = false
                mid = low + (high - low) / 2.0
                continue;
            }
        }
        
        if possibleAnswer == nil {
            // There isn't a CAM16 J that creates a color with L*a*b* L*. Try a lower chroma.
            high = mid
        } else {
            answer = possibleAnswer
            // It is possible to create a color with L* `lstar` and `mid` chroma. Try a higher chroma.
            low = mid
        }
        
        mid = low + (high - low) / 2.0;
    }
    
    // There was no answer: for the desired hue, there was no chroma low enough to generate a color
    // with the desired L*. All values of L* are possible when there is 0 chroma. Return a color
    // with 0 chroma, i.e. a shade of gray, with the desired L*.
    guard let ans = answer else {
        return ColorUtils.argbFrom(lstar: lstar);
    }
    
    return ans.viewed(viewingConditions: frame);
}

func findCamByJ(hue: Double,
                chroma: Double,
                lstar: Double,
                frame: ViewingConditions) -> Cam16? {
    var low = 0.0
    var high = 100.0
    var mid = 0.0
    var bestdL = Double.infinity
    var bestdE = Double.infinity
    var bestCam: Cam16?
    
    while abs(low - high) > lightnessSearchEndpoint {
        mid = low + (high - low) / 2;
        let camBeforeClip = Cam16
            .fromJchInViewingConditions(J: mid,
                                        C: chroma,
                                        h: hue,
                                        viewingConditions: frame)
        let clipped = camBeforeClip.viewed(viewingConditions: frame)
        let clippedLstar = ColorUtils.lstarFrom(argb: clipped)
        let dL = abs(lstar - clippedLstar)
        if (dL < _dlMax) {
            let camClipped = Cam16.fromIntInViewingConditions(argb: clipped, viewingConditions: frame);
            let dE = camClipped.distance(to: Cam16.fromJchInViewingConditions(
                J: camClipped.j,
                C: camClipped.chroma,
                h: hue,
                viewingConditions: frame))
            if ((dE <= _deMax && dE < bestdE) && dL < _dlMax) {
                bestdL = dL;
                bestdE = dE;
                bestCam = camClipped;
            }
        }
        
        if (bestdL == 0 && bestdE < _deMaxError) {
            break;
        }
        
        if (clippedLstar < lstar) {
            low = mid;
        } else {
            high = mid;
        }
    }
    
    return bestCam;
}
