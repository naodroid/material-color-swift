//
//  TonePalette.swift
//  material-color-utilities
//
//  Created by nao on 2021/12/08.
//

import Foundation

/// A convenience class for retrieving colors that are constant in hue and
/// chroma, but vary in tone.
///
/// This class can be instantiated in two ways:
/// 1. [of] From hue and chroma. (preferred)
/// 2. [fromList] From a fixed-size ([TonalPalette.commonSize]) list of ints
/// representing ARBG colors. Correctness (constant hue and chroma) of the input
/// is not enforced. [get] will only return the input colors, corresponding to
/// [commonTones].
public class TonalPalette {
    /// Commonly-used tone values.
    static let commonTones: [Int] = [
        0,
        10,
        20,
        30,
        40,
        50,
        60,
        70,
        80,
        90,
        95,
        99,
        100
    ]
    
    public static let commonSize = commonTones.count
    
    private let _hue: Double?
    private let _chroma: Double?
    private var _cache: [Int: Int]
    
    
    private init(hue: Double? = nil,
                 chroma: Double? = nil,
                 cache: [Int: Int] = [:]) {
        self._hue = hue
        self._chroma = chroma
        self._cache = cache
    }
    
    /// TODO: this should be replaced with initializer in swift
    private static func _from(hue: Double, chroma: Double) -> TonalPalette {
        return TonalPalette(hue: hue,
                           chroma: chroma)
    }
    /// TODO: this should be replaced with initializer in swift
    private static func _from(cache: [Int: Int]) -> TonalPalette {
        return TonalPalette(cache: cache)
    }
    
    /// Create colors using [hue] and [chroma].
    public static func of(hue: Double, chroma: Double) -> TonalPalette {
        return TonalPalette._from(hue: hue, chroma: chroma)
    }
    
    
    /// Create colors from a fixed-size list of ARGB color ints.
    ///
    /// Inverse of [TonalPalette.asList].
    public static func fromList(colors: [Int]) -> TonalPalette {
        assert(colors.count == commonSize);
        var cache: [Int: Int] = [:]
        TonalPalette.commonTones.enumerated().forEach { (index, toneValue) in
            cache[toneValue] = colors[index]
        }
        return TonalPalette._from(cache: cache)
    }
    
    /// Returns a fixed-size list of ARGB color ints for common tone values.
    ///
    /// Inverse of [fromList].
    /// TODO: this name doesn't sound like "Swyt",, function `asList()` is better than property.
    var asList: [Int] {
        TonalPalette.commonTones.map { getTone($0) }
    }
    
    /// Returns the ARGB representation of an HCT color.
    ///
    /// If the class was instantiated from [_hue] and [_chroma], will return the
    /// color with corresponding [tone].
    /// If the class was instantiated from a fixed-size list of color ints, [tone]
    /// must be in [commonTones].
    public func getTone(_ tone: Int) -> Int {
        if let hue = _hue, let chroma = _chroma {
            let ch = (tone >= 90) ? min(chroma, 40.0) : chroma
            if let tone = _cache[tone] {
                return tone
            }
            let value = HctColor.from(hue: hue, chroma: ch, tone: Double(tone)).toInt()
            _cache[tone] = value
            return value
        }
        if let tone = _cache[tone] {
            return tone
        }
        fatalError(
            "tone \(tone)" +
            "When a TonalPalette is created with fromList " +
            "tone must be one of \(TonalPalette.commonTones)"
        )
    }
}
extension TonalPalette: Equatable {
    public static func ==(lhs: TonalPalette, rhs: TonalPalette) -> Bool {
        if lhs._hue != nil && lhs._chroma != nil {
            return lhs._hue == rhs._hue && lhs._chroma == rhs._chroma;
        } else {
            return lhs._cache == rhs._cache
        }
    }
}
extension TonalPalette: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(_hue)
        hasher.combine(_chroma)
        hasher.combine(_cache)
    }
}
extension TonalPalette: CustomStringConvertible {
    public var description: String {
        if let hue = _hue, let chroma = _chroma {
            return "TonalPalette.of(\(hue), \(chroma))"
        } else {
            return "TonalPalette.fromList(\(_cache))"
        }
    }
}
