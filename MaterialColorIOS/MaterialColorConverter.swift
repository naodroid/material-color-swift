//
//  MaterialColorIOS.swift
//  MaterialColorIOS
//
//  Created by nao on 2021/12/12.
//

import Foundation
import UIKit
import CoreGraphics
import CoreImage
import MaterialColorSwift


public class MaterialColorConverter {
    
    public static func fromImage(_ uiImage: UIImage, isDarkTheme: Bool) -> Scheme? {
        guard let pixels = imageToPixels(uiImage) else {
            return nil
        }
        let size = CorePalette.size * TonalPalette.commonSize
        let colorToCount = QuantizerWsmeans.quantize(
            inputPixels: pixels,
            maxColors: size
        ).colorToCount
        let colors = Array(colorToCount.keys)
        for (c, k) in colorToCount {
            print(String(format: "%02X %d", c, k))
        }
        return isDarkTheme ? Scheme.light(color: colors[0]) : Scheme.dark(color: colors[0])
    }
    /// convert uiimage to argb pixel array in specified size (width, height=size)
    public static func imageToPixels(_ uiImage: UIImage, size: Int = 16) -> [Int]? {
        guard let cgImage = uiImage.cgImage else {
            return nil
        }
        let inputWidth = cgImage.width
        let inputHeight = cgImage.height
        let outputWidth = size
        let outputHeight = size
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * inputWidth
        let bitsPerComponent = 8
        
        var pixels: [UInt32] = Array(repeating: 1, count: inputWidth * inputHeight)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let contextOpt = pixels.withUnsafeMutableBytes { ptr -> CGContext? in
            guard let raw = ptr.baseAddress else {
                return nil
            }
            return CGContext(data: raw,
                             width: inputWidth,
                             height: inputHeight,
                             bitsPerComponent: bitsPerComponent,
                             bytesPerRow: bytesPerRow,
                             space: colorSpace,
                             bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        }
        guard let context = contextOpt else {
            return nil
        }
        // resize for reducing memory
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: outputWidth, height: outputHeight))
        // int32 to int
        let result: [Int] = pixels.map {
            print(String(format: "%02X", $0))
            return Int($0)
        }
        return result
    }
}
