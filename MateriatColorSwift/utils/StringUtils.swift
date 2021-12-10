//
//  StringUtils.swift
//  material-color-utilities
//
//  Created by nao on 2021/12/07.
//

import Foundation

enum StringUtils {
    static func hexFrom(argb: Int, leadingHashSign: Bool = true) -> String {
        let red = ColorUtils.redFrom(argb: argb)
        let green = ColorUtils.greenFrom(argb: argb)
        let blue = ColorUtils.blueFrom(argb: argb)
        
        let signText = leadingHashSign ? "#" : ""
        let rgbText = String(format: "%02X%02X%02X", red, green, blue)
        return signText + rgbText
    }
    
    static func argbFrom(hex: String) -> Int? {
        return Int(hex, radix: 16)
    }
}
