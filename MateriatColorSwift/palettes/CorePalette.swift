//
//  CorePalette.swift
//  material-color-utilities
//
//  Created by nao on 2021/12/08.
//

import Foundation



/// An intermediate concept between the key color for a UI theme, and a full
/// color scheme. 5 tonal palettes are generated, all except one use the same
/// hue as the key color, and all vary in chroma.
class CorePalette {
    /// The number of generated tonal palettes.
    static let size = 5
    
    let primary: TonalPalette
    let secondary: TonalPalette
    let tertiary: TonalPalette
    let neutral: TonalPalette
    let neutralVariant: TonalPalette
    let error = TonalPalette.of(hue: 25, chroma: 84);
    
    
    /// Create a [CorePalette] from a source ARGB color.
    static func of(argb: Int) -> CorePalette {
        let cam = Cam16.fromInt(argb: argb)
        return CorePalette(hue: cam.hue, chroma: cam.chroma)
    }
    
    private init(hue: Double, chroma: Double) {
        primary = TonalPalette.of(hue: hue, chroma: max(48, chroma))
        secondary = TonalPalette.of(hue: hue, chroma: 16)
        tertiary = TonalPalette.of(hue: hue + 60, chroma: 24)
        neutral = TonalPalette.of(hue: hue, chroma: 4)
        neutralVariant = TonalPalette.of(hue: hue, chroma: 8)
    }
    
    
    /// Create a [CorePalette] from a fixed-size list of ARGB color ints
    /// representing concatenated tonal palettes.
    ///
    /// Inverse of [asList].
    static func fromList(_ colors: [Int]) -> CorePalette {
        return CorePalette(fromList: colors)
    }
    private init(fromList colors: [Int]) {
        assert(colors.count == CorePalette.size * TonalPalette.commonSize)
        primary = TonalPalette.fromList(
            colors: _getPartition(colors, 0, TonalPalette.commonSize))
        secondary = TonalPalette.fromList(
            colors: _getPartition(colors, 1, TonalPalette.commonSize))
        tertiary = TonalPalette.fromList(
            colors: _getPartition(colors, 2, TonalPalette.commonSize))
        neutral = TonalPalette.fromList(
            colors: _getPartition(colors, 3, TonalPalette.commonSize))
        neutralVariant = TonalPalette.fromList(
            colors: _getPartition(colors, 4, TonalPalette.commonSize))
    }
    
    
    /// Returns a list of ARGB color [int]s from concatenated tonal palettes.
    ///
    /// Inverse of [CorePalette.fromList].
    func asList() -> [Int] {
        primary.asList
        + secondary.asList
        + tertiary.asList
        + neutral.asList
        + neutralVariant.asList
    }
}
extension CorePalette: Equatable {
    static func ==(lhs: CorePalette, rhs: CorePalette) -> Bool {
        return lhs.primary == rhs.primary
        && lhs.secondary == rhs.secondary
        && lhs.tertiary == rhs.tertiary
        && lhs.neutral == rhs.neutral
        && lhs.neutralVariant == rhs.neutralVariant
        && lhs.error == rhs.error
    }
}
extension CorePalette: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(primary)
        hasher.combine(secondary)
        hasher.combine(tertiary)
        hasher.combine(neutral)
        hasher.combine(neutralVariant)
        hasher.combine(error)
    }
}
extension CorePalette: CustomStringConvertible {
    var description: String {
        return "primary: \(primary)\n"
        + "secondary: \(secondary)\n"
        + "tertiary: \(tertiary)\n"
        + "neutral: \(neutral)\n"
        + "neutralVariant: \(neutralVariant)\n"
        + "error: \(error)\n"
    }
}

// Returns a partition from a list.
//
// For example, given a list with 2 partitions of size 3.
// range = [1, 2, 3, 4, 5, 6];
//
// range.getPartition(0, 3) // [1, 2, 3]
// range.getPartition(1, 3) // [4, 5, 6]
private func _getPartition(_ list: [Int],
                           _ partitionNumber: Int,
                           _ partitionSize: Int) -> [Int] {
    let start = partitionNumber * partitionSize
    let end = (partitionNumber + 1) * partitionSize
    return Array(list[start..<end])
}
