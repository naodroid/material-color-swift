//
//  QuantizerWu.swift
//  material-color-swift
//
//  Created by 坂本　尚嗣 on 2021/12/10.
//

import Foundation

class QuantizerWu: Quantizer {
    var weights :[Int] = []
    var momentsR: [Int] = []
    var momentsG: [Int] = []
    var momentsB: [Int] = []
    var moments: [Double] = []
    var cubes: [Box] = []
    
    // A histogram of all the input colors is constructed. It has the shape of a
    // cube. The cube would be too large if it contained all 16 million colors:
    // historical best practice is to use 5 bits  of the 8 in each channel,
    // reducing the histogram to a volume of ~32,000.
    static let indexBits = 5;
    static let maxIndex = 32;
    static let sideLength = 33;
    static let totalSize = 35937;
    
    init(weights: [Int],
         momentsR: [Int],
         momentsG: [Int],
         momentsB: [Int],
         moments: [Double],
         cubes: [Box]
    ) {
        self.weights = weights
        self.momentsR = momentsR
        self.momentsG = momentsG
        self.momentsB = momentsB
        self.moments = moments
        self.cubes = cubes
    }
    
    
    func quantize(pixels: [Int], maxColors: Int) async -> QuantizerResult {
        let result = await QuantizerMap().quantize(pixels: pixels, maxColors: maxColors)
        constructHistogram(pixels: result.colorToCount)
        computeMoments()
        let createBoxesResult = createBoxes(maxColorCount: maxColors)
        let results = createResult(colorCount: createBoxesResult.resultCount)
        
        let pixels = results.reduce(into: [Int: Int]()) { (dict, elem) in
            dict[elem] = 0
        }
        return QuantizerResult(colorToCount: pixels)
    }
    
    static func getIndex(r: Int, g: Int, b: Int) -> Int {
        return (r << (QuantizerWu.indexBits * 2)) +
        (r << (QuantizerWu.indexBits + 1)) +
        (g << QuantizerWu.indexBits) +
        r +
        g +
        b
    }
    
    func constructHistogram(pixels: [Int: Int]) {
        weights = []
        momentsR = []
        momentsG = []
        momentsB = []
        moments = []
        for (pixel, count) in pixels {
            let red = ColorUtils.redFrom(argb: pixel)
            let green = ColorUtils.greenFrom(argb: pixel)
            let blue = ColorUtils.blueFrom(argb: pixel)
            let bitsToRemove = 8 - QuantizerWu.indexBits
            let iR = (red >> bitsToRemove) + 1
            let iG = (green >> bitsToRemove) + 1
            let iB = (blue >> bitsToRemove) + 1
            let index = QuantizerWu.getIndex(r: iR, g: iG, b: iB)
            weights[index] += count
            momentsR[index] += (red * count)
            momentsG[index] += (green * count)
            momentsB[index] += (blue * count)
            moments[index] += Double(count * ((red * red) + (green * green) + (blue * blue)))
        }
    }
    
    func computeMoments() {
        for r in 1..<QuantizerWu.sideLength {
            var area: [Int] = []
            var areaR: [Int] = []
            var areaG: [Int] = []
            var areaB: [Int] = []
            var area2: [Double] = []
            for g in 1..<QuantizerWu.sideLength {
                var line = 0
                var lineR = 0
                var lineG = 0
                var lineB = 0
                var line2 = 0.0
                for b in 1..<QuantizerWu.sideLength {
                    let index = QuantizerWu.getIndex(r: r, g: g, b: b)
                    line += weights[index]
                    lineR += momentsR[index]
                    lineG += momentsG[index]
                    lineB += momentsB[index]
                    line2 += moments[index]
                    
                    area[b] += line;
                    areaR[b] += lineR;
                    areaG[b] += lineG;
                    areaB[b] += lineB;
                    area2[b] += line2;
                    
                    let previousIndex = QuantizerWu.getIndex(r: r - 1, g: g, b: b)
                    weights[index] = weights[previousIndex] + area[b]
                    momentsR[index] = momentsR[previousIndex] + areaR[b]
                    momentsG[index] = momentsG[previousIndex] + areaG[b]
                    momentsB[index] = momentsB[previousIndex] + areaB[b]
                    moments[index] = moments[previousIndex] + area2[b]
                }
            }
        }
    }
    
    func createBoxes(maxColorCount: Int) -> CreateBoxesResult {
        cubes = (0..<maxColorCount).map {_ in
            Box()
        }
        cubes[0] = Box(r0: 0, r1: QuantizerWu.maxIndex,
                       g0: 0, g1: QuantizerWu.maxIndex,
                       b0: 0, b1: QuantizerWu.maxIndex,
                       vol: 0)
        var volumeVariance: [Double] = Array(repeating: 0.0, count: maxColorCount)
        var next = 0
        var generatedColorCount = maxColorCount
        var i = 1
        while i < maxColorCount {
            if cut(one: cubes[next], two: cubes[i]) {
                volumeVariance[next] = (cubes[next].vol > 1) ? variance(cube: cubes[next]) : 0.0
                volumeVariance[i] = (cubes[i].vol > 1) ? variance(cube: cubes[i]) : 0.0
            } else {
                volumeVariance[next] = 0.0
                i -= 1
            }
            i += 1
        
            next = 0
            var temp = volumeVariance[0]
            var j = 1
            while j <= i {
                if volumeVariance[j] > temp {
                    temp = volumeVariance[j];
                    next = j;
                }
                j += 1
            }
            if temp <= 0.0 {
                generatedColorCount = i + 1
                break;
            }
        }
        return CreateBoxesResult(
            requestedCount: maxColorCount, resultCount: generatedColorCount);
    }
    
    func createResult(colorCount: Int) -> [Int] {
        var colors: [Int] = []
        for i in 0..<colorCount {
            let cube = cubes[i]
            let weight = QuantizerWu.volume(cube, weights)
            if weight > 0 {
                let rf = Double(QuantizerWu.volume(cube, momentsR))
                let gf = Double(QuantizerWu.volume(cube, momentsG))
                let bf = Double(QuantizerWu.volume(cube, momentsB))
                let wf = Double(weight)
                let r = Int((rf / wf).rounded())
                let g = Int((gf / wf).rounded())
                let b = Int((bf / wf).rounded())
                let color = ColorUtils.argbFrom(red: r, green: g, blue: b);
                colors.append(color);
            }
        }
        return colors;
    }
    
    func variance(cube: Box) -> Double {
        let dr = QuantizerWu.volume(cube, momentsR)
        let dg = QuantizerWu.volume(cube, momentsG)
        let db = QuantizerWu.volume(cube, momentsB)
        let xx = moments[QuantizerWu.getIndex(r: cube.r1, g: cube.g1, b: cube.b1)] -
        moments[QuantizerWu.getIndex(r: cube.r1, g: cube.g1, b: cube.b0)] -
        moments[QuantizerWu.getIndex(r: cube.r1, g: cube.g0, b: cube.b1)] +
        moments[QuantizerWu.getIndex(r: cube.r1, g: cube.g0, b: cube.b0)] -
        moments[QuantizerWu.getIndex(r: cube.r0, g: cube.g1, b: cube.b1)] +
        moments[QuantizerWu.getIndex(r: cube.r0, g: cube.g1, b: cube.b0)] +
        moments[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b1)] -
        moments[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b0)]
        
        let hypotenuse = (dr * dr + dg * dg + db * db)
        let volume_ = QuantizerWu.volume(cube, weights)
        return Double(xx) - Double(hypotenuse) / Double(volume_)
    }
    
    func cut(one: Box, two: Box) -> Bool {
        let wholeR = QuantizerWu.volume(one, momentsR)
        let wholeG = QuantizerWu.volume(one, momentsG)
        let wholeB = QuantizerWu.volume(one, momentsB)
        let wholeW = QuantizerWu.volume(one, weights)
        
        let maxRResult = maximize(cube: one,
                                  direction: Direction.red,
                                  first: one.r0 + 1,
                                  last: one.r1,
                                  wholeR: wholeR,
                                  wholeG: wholeG,
                                  wholeB: wholeB,
                                  wholeW: wholeW)
        let maxGResult = maximize(cube: one, direction:
                                    Direction.green,
                                  first: one.g0 + 1,
                                  last: one.g1,
                                  wholeR: wholeR,
                                  wholeG: wholeG,
                                  wholeB: wholeB,
                                  wholeW: wholeW)
        let maxBResult = maximize(cube: one,
                                  direction: Direction.blue,
                                  first: one.b0 + 1,
                                  last: one.b1,
                                  wholeR: wholeR,
                                  wholeG: wholeG,
                                  wholeB: wholeB,
                                  wholeW: wholeW)
        
        let cutDirection: Direction
        let maxR = maxRResult.maximum;
        let maxG = maxGResult.maximum;
        let maxB = maxBResult.maximum;
        if maxR >= maxG && maxR >= maxB {
            cutDirection = Direction.red
            if maxRResult.cutLocation < 0 {
                return false;
            }
        } else if maxG >= maxR && maxG >= maxB {
            cutDirection = Direction.green
        } else {
            cutDirection = Direction.blue
        }
        
        two.r1 = one.r1
        two.g1 = one.g1
        two.b1 = one.b1
        
        switch cutDirection {
        case Direction.red:
            one.r1 = maxRResult.cutLocation
            two.r0 = one.r1
            two.g0 = one.g0
            two.b0 = one.b0
        case Direction.green:
            one.g1 = maxGResult.cutLocation
            two.r0 = one.r0
            two.g0 = one.g1
            two.b0 = one.b0
        case Direction.blue:
            one.b1 = maxBResult.cutLocation
            two.r0 = one.r0
            two.g0 = one.g0
            two.b0 = one.b1
        }
        one.vol = (one.r1 - one.r0) * (one.g1 - one.g0) * (one.b1 - one.b0)
        two.vol = (two.r1 - two.r0) * (two.g1 - two.g0) * (two.b1 - two.b0)
        return true
    }
    
    func maximize(cube: Box, direction: Direction, first: Int, last: Int,
                  wholeR: Int, wholeG: Int, wholeB: Int, wholeW: Int) -> MaximizeResult {
        let bottomR = QuantizerWu.bottom(cube, direction, momentsR)
        let bottomG = QuantizerWu.bottom(cube, direction, momentsG)
        let bottomB = QuantizerWu.bottom(cube, direction, momentsB)
        let bottomW = QuantizerWu.bottom(cube, direction, weights)
        
        var max = 0.0
        var cut = -1
        for i in first..<last {
            var halfR = bottomR + QuantizerWu.top(cube, direction, i, momentsR)
            var halfG = bottomG + QuantizerWu.top(cube, direction, i, momentsG)
            var halfB = bottomB + QuantizerWu.top(cube, direction, i, momentsB)
            var halfW = bottomW + QuantizerWu.top(cube, direction, i, weights)
            
            if (halfW == 0) {
                continue
            }
            
            var tempNumerator = Double(
                (halfR * halfR) + (halfG * halfG) + (halfB * halfB)
            )
            var tempDenominator = Double(halfW)
            var temp = tempNumerator / tempDenominator
            
            halfR = wholeR - halfR;
            halfG = wholeG - halfG;
            halfB = wholeB - halfB;
            halfW = wholeW - halfW;
            if halfW == 0 {
                continue
            }
            tempNumerator = Double(
                (halfR * halfR) + (halfG * halfG) + (halfB * halfB)
            )
            tempDenominator = Double(halfW)
            temp += (tempNumerator / tempDenominator)
            
            if temp > max {
                max = temp
                cut = i
            }
        }
        return MaximizeResult(cutLocation: cut, maximum: max);
    }
    
    static func volume(_ cube: Box, _ moment: [Int]) -> Int {
        return (moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g1, b: cube.b1)] -
                moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g1, b: cube.b0)] -
                moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g0, b: cube.b1)] +
                moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g0, b: cube.b0)] -
                moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g1, b: cube.b1)] +
                moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g1, b: cube.b0)] +
                moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b1)] -
                moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b0)])
    }
    
    static func bottom(_ cube: Box, _ direction: Direction, _ moment: [Int]) -> Int {
        switch (direction) {
        case Direction.red:
            return -moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g1, b: cube.b1)] +
            moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g1, b: cube.b0)] +
            moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b1)] -
            moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b0)]
        case Direction.green:
            return -moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g0, b: cube.b1)] +
            moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g0, b: cube.b0)] +
            moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b1)] -
            moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b0)]
        case Direction.blue:
            return -moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g1, b: cube.b0)] +
            moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g0, b: cube.b0)] +
            moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g1, b: cube.b0)] -
            moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: cube.b0)]
        }
    }
    
    static func top(_ cube: Box, _ direction: Direction, _ position: Int, _ moment: [Int]) -> Int {
        switch (direction) {
        case Direction.red:
            return (moment[QuantizerWu.getIndex(r: position, g: cube.g1, b: cube.b1)] -
                    moment[QuantizerWu.getIndex(r: position, g: cube.g1, b: cube.b0)] -
                    moment[QuantizerWu.getIndex(r: position, g: cube.g0, b: cube.b1)] +
                    moment[QuantizerWu.getIndex(r: position, g: cube.g0, b: cube.b0)])
        case Direction.green:
            return (moment[QuantizerWu.getIndex(r: cube.r1, g: position, b: cube.b1)] -
                    moment[QuantizerWu.getIndex(r: cube.r1, g: position, b: cube.b0)] -
                    moment[QuantizerWu.getIndex(r: cube.r0, g: position, b: cube.b1)] +
                    moment[QuantizerWu.getIndex(r: cube.r0, g: position, b: cube.b0)])
        case Direction.blue:
            return (moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g1, b: position)] -
                    moment[QuantizerWu.getIndex(r: cube.r1, g: cube.g0, b: position)] -
                    moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g1, b: position)] +
                    moment[QuantizerWu.getIndex(r: cube.r0, g: cube.g0, b: position)])
        }
    }
    
}

enum Direction: String {
    case red
    case green
    case blue
}

class MaximizeResult {
    // < 0 if cut impossible
    var cutLocation: Int
    var maximum: Double;
    
    init(cutLocation: Int, maximum: Double) {
        self.cutLocation = cutLocation
        self.maximum = maximum
    }
}

class CreateBoxesResult {
    var requestedCount: Int
    var resultCount: Int
    
    init(requestedCount: Int,  resultCount: Int) {
        self.requestedCount = requestedCount
        self.resultCount = resultCount
    }
}

class Box {
    var r0: Int
    var r1: Int
    var g0: Int
    var g1: Int
    var b0: Int
    var b1: Int
    var vol: Int
    
    init(r0: Int = 0, r1: Int = 0,
         g0: Int = 0, g1: Int = 0,
         b0: Int = 0, b1: Int = 0,
         vol: Int = 0) {
        self.r0 = r0
        self.r1 = r1
        self.g0 = g0
        self.g1 = g1
        self.b0 = b0
        self.b1 = b1
        self.vol = vol
    }
}
extension Box: CustomStringConvertible {
    var description: String {
        return "Box: R \(r0) -> \(r1) G  \(g0) -> \(g1) B \(b0) -> \(b1) VOL = \(vol)";
    }
}
