//
//  QuantizerMap.swift
//  material-color-swift
//
//  Created by nao on 2021/12/09.
//

import Foundation

public class QuantizerMap: Quantizer {
    public func quantize(pixels: [Int], maxColors: Int) -> QuantizerResult {
        var countByColor: [Int: Int] = [:]
        for pixel in pixels {
            let alpha = ColorUtils.alphaFrom(argb: pixel)
            if alpha < 255 {
                continue
            }
            countByColor[pixel] = (countByColor[pixel] ?? 0) + 1
        }
        return QuantizerResult(colorToCount: countByColor)
    }
}
