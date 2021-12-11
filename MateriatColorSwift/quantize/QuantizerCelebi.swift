//
//  QuantizerCelebi.swift
//  material-color-swift
//
//  Created by 坂本　尚嗣 on 2021/12/10.
//

import Foundation


class QuantizerCelebi: Quantizer {
    func quantize(pixels: [Int], maxColors: Int) async -> QuantizerResult {
        let wu = QuantizerWu()
        let wuResult = await wu.quantize(pixels: pixels, maxColors: maxColors)
        let clusters: [Int] = Array(wuResult.colorToCount.keys)
        let wsmeansResult = QuantizerWsmeans.quantize(
            inputPixels: pixels,
            maxColors: maxColors,
            startingClusters: clusters,
            pointProvider: PointProviderLab())
        return wsmeansResult;
    }
}
