//
//  QuantizerWsmeans.swift
//  material-color-swift
//
//  Created by 坂本　尚嗣 on 2021/12/11.
//

import Foundation

class DistanceAndIndex {
    var distance: Double
    var index: Int
    
    init(
        distance: Double,
        index: Int
    ) {
        self.distance = distance
        self.index = index
    }
}
extension DistanceAndIndex: Comparable {
    static func < (lhs: DistanceAndIndex, rhs: DistanceAndIndex) -> Bool {
        return lhs.distance < rhs.distance
    }
    
    static func == (lhs: DistanceAndIndex, rhs: DistanceAndIndex) -> Bool {
        return lhs.distance == rhs.distance
    }
}

public class QuantizerWsmeans {
    static let maxIterations = 10
    static let minMovementDistance = 3.0
    
    public static func quantize(
        inputPixels: [Int],
        maxColors: Int,
        startingClusters: [Int] = [],
        pointProvider: PointProvider = PointProviderLab()
    )  -> QuantizerResult {
        var pixelToCount: [Int: Int] = [:]
        var points: [[Double]] = []
        var pixels: [Int] = []
        var pointCount = 0
        
        for inputPixel in inputPixels {
            if let p = pixelToCount[inputPixel] {
                pixelToCount[inputPixel] = p + 1
            } else {
                pixelToCount[inputPixel] = 1
                pointCount += 1
                let d = pointProvider.fromInt(argb: inputPixel)
                points.append(d)
                pixels.append(inputPixel)
            }
        }
        
        var counts: [Int] = Array(repeating: 0, count: pointCount)
        for i in 0..<pointCount {
            let pixel = pixels[i]
            let count = pixelToCount[pixel]!
            counts[i] = count
        }
        
        var clusterCount = min(maxColors, pointCount)
        if !startingClusters.isEmpty {
            clusterCount = min(clusterCount, startingClusters.count)
        }
        
        var clusters: [[Double]] = startingClusters.map {
            pointProvider.fromInt(argb: $0)
        }
        let additionalClustersNeeded = clusterCount - clusters.count
        if startingClusters.isEmpty && additionalClustersNeeded > 0 {
            //values from this random object are different from dart-code.
            let random = Random(seed: 0x42688)
            for _ in 0..<additionalClustersNeeded {
                let a = -100.0 + random.nextDouble() * 200.0
                let b = -100.0 + random.nextDouble() * 200.0
                let l = 0.0 + random.nextDouble() * 100.0
                clusters.append([l, a, b])
            }
        }
        
        // not used : let clusterIndexRandom = Random(seed: 0x42688)
        var clusterIndices: [Int] = (0..<pointCount).map { $0 % clusterCount }
        var indexMatrix: [[Int]] = (0..<clusterCount).map { _ in
            Array(repeating: 0, count: clusterCount)
        }
        
        var distanceToIndexMatrix: [[DistanceAndIndex]] = (0..<clusterCount).map { i -> [DistanceAndIndex] in
            return (0..<clusterCount).map { (j) -> DistanceAndIndex in
                return DistanceAndIndex(distance: 0, index: j)
            }
        }
        
        var pixelCountSums = Array(repeating: 0, count: clusterCount)
        for iteration in 0..<maxIterations {
            var pointsMoved = 0
            for i in 0..<clusterCount {
                for j in (i + 1)..<clusterCount {
                    let distance = pointProvider.distance(clusters[i], clusters[j])
                    distanceToIndexMatrix[j][i].distance = distance
                    distanceToIndexMatrix[j][i].index = i
                    distanceToIndexMatrix[i][j].distance = distance
                    distanceToIndexMatrix[i][j].index = j
                }
                distanceToIndexMatrix[i].sort()
                for j in 0..<clusterCount {
                    indexMatrix[i][j] = distanceToIndexMatrix[i][j].index
                }
            }
            
            for i in 0..<pointCount {
                let point = points[i]
                let previousClusterIndex = clusterIndices[i]
                let previousCluster = clusters[previousClusterIndex]
                let previousDistance = pointProvider.distance(point, previousCluster)
                var minimumDistance = previousDistance
                var newClusterIndex = -1
                for j in 0..<clusterCount {
                    if distanceToIndexMatrix[previousClusterIndex][j].distance >=
                        4 * previousDistance {
                        continue
                    }
                    let distance = pointProvider.distance(point, clusters[j])
                    if distance < minimumDistance {
                        minimumDistance = distance
                        newClusterIndex = j
                    }
                }
                if newClusterIndex != -1 {
                    let distanceChange =
                    abs(sqrt(minimumDistance) - sqrt(previousDistance))
                    if distanceChange > minMovementDistance {
                        pointsMoved += 1
                        clusterIndices[i] = newClusterIndex
                    }
                }
            }
            
            if pointsMoved == 0 && iteration != 0 {
                break
            }
            
            var componentASums = Array(repeating: 0.0, count: clusterCount)
            var componentBSums = Array(repeating: 0.0, count: clusterCount)
            var componentCSums = Array(repeating: 0.0, count: clusterCount)
            
            for i in 0..<clusterCount {
                pixelCountSums[i] = 0
            }
            for i in 0..<pointCount {
                let clusterIndex = clusterIndices[i]
                let point = points[i]
                let count = counts[i]
                pixelCountSums[clusterIndex] += count
                componentASums[clusterIndex] += (point[0] * Double(count))
                componentBSums[clusterIndex] += (point[1] * Double(count))
                componentCSums[clusterIndex] += (point[2] * Double(count))
            }
            for i in 0..<clusterCount {
                let count = pixelCountSums[i]
                if count == 0 {
                    clusters[i] = [0.0, 0.0, 0.0]
                    continue
                }
                let a = componentASums[i] / Double(count)
                let b = componentBSums[i] / Double(count)
                let c = componentCSums[i] / Double(count)
                clusters[i] = [a, b, c]
            }
        }
        
        var clusterArgbs: [Int] = []
        var clusterPopulations: [Int] = []
        for i in 0..<clusterCount {
            let count = pixelCountSums[i]
            if (count == 0) {
                continue
            }
            
            let possibleNewCluster = pointProvider.toInt(lab: clusters[i])
            if clusterArgbs.contains(possibleNewCluster) {
                continue
            }
            
            clusterArgbs.append(possibleNewCluster)
            clusterPopulations.append(count)
        }
        var dict: [Int: Int] = [:]
        for i in 0..<clusterArgbs.count {
            dict[clusterArgbs[i]] = clusterPopulations[i]
        }
        return QuantizerResult(colorToCount: dict)
        //return QuantizerResult(Map.fromIterables(clusterArgbs, clusterPopulations));
    }
}

/// Seeding random generator.
/// This uses very easy algorithm because this program uses random values for "FIXED" value.
/// So we don't need a complex/secure generator.
private class Random {
    private var value: Int64
    init(seed: Int64) {
        self.value = seed
    }
    func nextDouble() -> Double {
        self.value = (self.value * 553013 + 872023) % 1000000007
        return Double(self.value) / 1000000007.0
    }
}
