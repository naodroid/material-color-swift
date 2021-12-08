//
//  PointProvider.swift
//  material-color-swift
//
//  Created by nao on 2021/12/09.
//

import Foundation

protocol PointProvider {
    func fromInt(argb: Int) -> [Double]
    func toInt(lab: [Double]) -> Int
    func distance(_ a: [Double], _ b: [Double]) -> Double
}
