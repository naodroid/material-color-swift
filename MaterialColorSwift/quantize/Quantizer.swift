//
//  Quantizer.swift
//  material-color-swift
//
//  Created by nao on 2021/12/09.
//

import Foundation
public protocol Quantizer {
    func quantize(pixels: [Int], maxColors: Int) -> QuantizerResult
}

public class QuantizerResult {
    public var colorToCount: [Int: Int]
    var inputPixelToClusterPixel: [Int: Int]
    
    init(colorToCount: [Int: Int],
         inputPixelToClusterPixel: [Int: Int] = [:]) {
        self.colorToCount = colorToCount
        self.inputPixelToClusterPixel = inputPixelToClusterPixel
    }
}
