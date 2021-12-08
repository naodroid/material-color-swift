//
//  Quantizer.swift
//  material-color-swift
//
//  Created by nao on 2021/12/09.
//

import Foundation
protocol Quantizer {
    func quantize(pixels: [Int], maxColors: Int) async -> QuantizerResult
}

class QuantizerResult {
    var colorToCount: [Int: Int]
    var inputPixelToClusterPixel: [Int: Int]
    
    init(colorToCount: [Int: Int],
         inputPixelToClusterPixel: [Int: Int] = [:]) {
        self.colorToCount = colorToCount
        self.inputPixelToClusterPixel = inputPixelToClusterPixel
    }
}
