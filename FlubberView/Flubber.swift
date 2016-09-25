//
//  Flubber.swift
//  FlubberView
//
//  Created by Matthew Buckley on 9/18/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

import Foundation
import UIKit

public protocol Numeric {
    static func +(lhs: Self, rhs: Self) -> Self
    static func -(lhs: Self, rhs: Self) -> Self
    static func *(lhs: Self, rhs: Self) -> Self
    static func /(lhs: Self, rhs: Self) -> Self
}

extension CGFloat: Numeric {}
extension Int: Numeric {}
extension Double: Numeric {}
extension CGSize: Size {}

public protocol Initializable {
    init()
}

public protocol Size: Initializable {

    associatedtype NumericType: Numeric
    
    var width: NumericType { get set }
    var height: NumericType { get set }

    init(width: NumericType, height: NumericType)

}

extension Size {
    
    init(width: NumericType, height: NumericType) {
        self.init()
        self.width = width
        self.height = height
    }
    
}

public protocol Graph {

    associatedtype SizeType: Size

    var nodeCount: Int { get set }
    var size: SizeType { get set }

    init(withNodeCount nodeCount: Int,
         desiredSize: SizeType)
    
}

public protocol ElasticConfigurable: Initializable {

    var density: CGFloat { get set }
    var damping: CGFloat { get set }
    var frequency: CGFloat { get set }
    var elasticity: CGFloat { get set }
    var displayLink: CADisplayLink { get set }
    var viewLayer: CAShapeLayer { get set }
    var mainAnimator: UIDynamicAnimator { get }

    init(withDensity density: CGFloat,
         damping: CGFloat,
         frequency: CGFloat,
         elasticity: CGFloat,
         displayLink: CADisplayLink,
         viewLayer: CAShapeLayer)

}

public extension ElasticConfigurable {

    init(withDensity density: CGFloat,
         damping: CGFloat,
         frequency: CGFloat,
         elasticity: CGFloat,
         displayLink: CADisplayLink,
         viewLayer: CAShapeLayer) {
        self.init()
        self.density = density
        self.frequency = frequency
        self.elasticity = elasticity
        self.displayLink = displayLink
        self.viewLayer = viewLayer
    }
    
}
