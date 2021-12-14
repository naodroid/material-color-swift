//
//  PointProviderLab.swift
//  material-color-swift
//
//  Created by nao on 2021/12/09.
//

import Foundation

public class PointProviderLab {
    public init() {
    }
}
extension PointProviderLab: PointProvider {
    public func fromInt(argb: Int) -> [Double] {
        return ColorUtils.labFrom(argb: argb)
    }
    public func toInt(lab: [Double]) -> Int {
        return ColorUtils.argbFrom(l: lab[0], a: lab[1], b: lab[2])
    }
    public func distance(_ one: [Double], _ two: [Double]) -> Double {
        let dL = (one[0] - two[0])
        let dA = (one[1] - two[1])
        let dB = (one[2] - two[2])
        // Standard CIE 1976 delta E formula also takes the square root, unneeded
        // here. This method is used by quantization algorithms to compare distance,
        // and the relative ordering is the same, with or without a square root.

        // This relatively minor optimization is helpful because this method is
        // called at least once for each pixel in an image.
        return (dL * dL + dA * dA + dB * dB)
    }
}
