//
//  Score.swift
//  material-color-swift
//
//  Created by nao on 2021/12/09.
//

import Foundation

///
class ArgbAndScore {
    var argb: Int
    var score: Double
    
    init(argb: Int, score: Double) {
        self.argb = argb
        self.score = score
    }
}
/// The dart code implements this comparable as "Reverse Order of Score".
extension ArgbAndScore: Comparable {
    static func == (lhs: ArgbAndScore, rhs: ArgbAndScore) -> Bool {
        lhs.score == rhs.score
    }
    static func < (lhs: ArgbAndScore, rhs: ArgbAndScore) -> Bool {
        lhs.score > rhs.score
    }
}

/// Given a large set of colors, remove colors that are unsuitable for a UI
/// theme, and rank the rest based on suitability.
///
/// Enables use of a high cluster count for image quantization, thus ensuring
/// colors aren't muddied, while curating the high cluster count to a much
///  smaller number of appropriate choices.
enum Score {
    private static let _targetChroma = 48.0
    private static let _weightProportion = 0.7
    private static let _weightChromaAbove = 0.3
    private static let _weightChromaBelow = 0.1
    private static let _cutoffChroma = 15.0
    private static let _cutoffTone = 10.0
    private static let _cutoffExcitedProportion = 0.01
    
    /// Given a map with keys of colors and values of how often the color appears,
    /// rank the colors based on suitability for being used for a UI theme.
    ///
    /// [colorsToPopulation] is a map with keys of colors and values of often the
    /// color appears, usually from a source image.
    ///
    /// The list returned is colors sorted by suitability for a UI theme. The most
    /// suitable color is the first item, the least suitable is the last. There
    /// will always be at least one color returned. If all the input colors were
    /// not suitable for a theme, a default fallback color will be provided,
    /// Google Blue.
    static func score(colorsToPopulation: [Int: Int]) -> [Int] {
        var populationSum = 0.0;
        for population in colorsToPopulation.values {
            populationSum += Double(population)
        }
        
        // Turn the count of each color into a proportion by dividing by the total
        // count. Also, fill a cache of CAM16 colors representing each color, and
        // record the proportion of colors for each CAM16 hue.
        var colorsToProportion: [Int: Double] = [:]
        var colorsToCam: [Int: Cam16] = [:];
        var hueProportions = Array(repeating: 0.0, count: 360)
        for color in colorsToPopulation.keys {
            let population = Double(colorsToPopulation[color]!)
            let proportion = population / populationSum
            colorsToProportion[color] = proportion
            
            let cam = Cam16.fromInt(argb: color)
            colorsToCam[color] = cam
            
            let hue = Int(cam.hue.rounded())
            hueProportions[hue] += proportion
        }
        
        // Determine the proportion of the colors around each color, by summing the
        // proportions around each color's hue.
        var colorsToExcitedProportion: [Int: Double] = [:]
        for (color, cam) in colorsToCam {
            let hue = cam.hue.rounded()
            
            var excitedProportion = 0.0
            let start = Int(hue - 15)
            let end = Int(hue + 15)
            for i in start..<end {
                let neighborHue = MathUtils.sanitizeDegreesInt(i)
                excitedProportion += hueProportions[neighborHue]
            }
            colorsToExcitedProportion[color] = excitedProportion
        }
        
        // Score the colors by their proportion, as well as how chromatic they are.
        var colorsToScore: [Int: Double] = [:]
        for (color, cam) in colorsToCam {
            let proportion = colorsToExcitedProportion[color]!
            
            let proportionScore = proportion * 100.0 * _weightProportion
            
            let chromaWeight = cam.chroma < _targetChroma
            ? _weightChromaBelow
            : _weightChromaAbove;
            let chromaScore = (cam.chroma - _targetChroma) * chromaWeight
            
            let score = proportionScore + chromaScore
            colorsToScore[color] = score
        }
        
        // Remove colors that are unsuitable, ex. very dark or unchromatic colors.
        // Also, remove colors that are very similar in hue.
        let filteredColors = _filter(colorsToExcitedProportion, colorsToCam)
        var filteredColorsToScore: [Int: Double] = [:]
        for color in filteredColors {
            var duplicateHue = false
            let cam = colorsToCam[color]!
            for alreadyChosenColor in filteredColorsToScore.keys {
                let alreadyChosenCam = colorsToCam[alreadyChosenColor]!
                if MathUtils.differenceDegrees(cam.hue, alreadyChosenCam.hue) < 15 {
                    duplicateHue = true
                    break;
                }
            }
            if (!duplicateHue) {
                filteredColorsToScore[color] = colorsToScore[color]!;
            }
        }
        
        // Ensure the list of colors returned is sorted such that the first in the
        // list is the most suitable, and the last is the least suitable.
        let colorsByScoreDescending = filteredColorsToScore.map {(key, value) in
            ArgbAndScore(argb: key, score: value)
        }.sorted()
        
        // Ensure that at least one color is returned.
        if colorsByScoreDescending.isEmpty {
            return [0xff4285F4] // Google Blue
        }
        return colorsByScoreDescending.map(\.argb)
    }
    
    private static func _filter(
        _ colorsToExcitedProportion: [Int: Double],
        _ colorsToCam: [Int: Cam16]
    ) -> [Int] {
        var filtered: [Int] = []
        for (color, cam) in colorsToCam {
            let proportion = colorsToExcitedProportion[color]!
            
            if cam.chroma >= _cutoffChroma &&
                ColorUtils.lstarFrom(argb: color) >= _cutoffTone &&
                proportion >= _cutoffExcitedProportion {
                filtered.append(color);
            }
        }
        return filtered;
    }
}
