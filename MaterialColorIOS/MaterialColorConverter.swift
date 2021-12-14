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

private struct ColorCount: Comparable {
    let color: Int
    let count: Int
    static func ==(lhs: ColorCount, rhs: ColorCount) -> Bool {
        return lhs.count == rhs.count
    }
    static func <(lhs: ColorCount, rhs: ColorCount) -> Bool {
        return lhs.count < rhs.count
    }
}


/// Create Scheme from UIImage
/// To use the scheme in SwiftUI, use `Scheme.toSwiftUI()` for converting.
public class MaterialColorConverter {
    
    /// Create a scheme from UIImage.
    ///  - Parameters:
    ///    - uiImage : an image to be used in generation
    ///    - isDarkTheme : true if use in dark theme,
    ///   - Returns: generated scheme. if failure, returns nil
    public static func generateScheme(from uiImage: UIImage, isDarkTheme: Bool) -> Scheme? {
        guard let pixels = getPixels(from: uiImage) else {
            return nil
        }
        let size = CorePalette.size * TonalPalette.commonSize
        let colorToCount = QuantizerWsmeans.quantize(
            inputPixels: pixels,
            maxColors: size
        ).colorToCount
        let colors: [ColorCount] = colorToCount.map { (k, v) in
            ColorCount(color: k, count: v)
        }.sorted().reversed()
        
        //show histogram for debug
//        for c in colors {
//            print(String(format: "%02X, %d", c.color, c.count))
//        }
        //pick top used color
        let color = colors[0].color
        return isDarkTheme ? Scheme.dark(color: color) : Scheme.light(color: color)
    }
    
    /// Convert UIImage to argb pixel array in specified size.  
    /// The size of the returned-array is **size * size**
    /// - Parameters:
    ///   - image: an image to be used
    ///   - size: size of pixel-array
    ///  - Returns: Generated argb pixel array
    public static func getPixels(from uiImage: UIImage, size: Int = 64) -> [Int]? {
        guard let cgImage = uiImage.cgImage else {
            return nil
        }
        let outputWidth = size
        let outputHeight = size
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * outputWidth
        let bitsPerComponent = 8
        let bitmapInfo = CGImageAlphaInfo.premultipliedFirst.rawValue
        var pixels: [UInt32] = Array(repeating: 0, count: outputWidth * outputHeight)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let contextOpt = pixels.withUnsafeMutableBytes { ptr -> CGContext? in
            guard let raw = ptr.baseAddress else {
                return nil
            }
            return CGContext(data: raw,
                             width: outputWidth,
                             height: outputHeight,
                             bitsPerComponent: bitsPerComponent,
                             bytesPerRow: bytesPerRow,
                             space: colorSpace,
                             bitmapInfo: bitmapInfo)
        }
        guard let context = contextOpt else {
            return nil
        }
        // resize for reducing memory
        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: outputWidth, height: outputHeight))
        // int32-bgra to int-argb
        let result: [Int] = pixels.map {
            let b = Int(($0 >> 24) & 0xFF)
            let g = Int(($0 >> 16) & 0xFF)
            let r = Int(($0 >> 8) & 0xFF)
            let a = Int($0 & 0xFF)
            return (a << 24) | (r << 16) | (g << 8) | b
        }
        return result
    }
}
