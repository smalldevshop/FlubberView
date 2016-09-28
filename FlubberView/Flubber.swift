//
//  Flubber.swift
//  FlubberView
//
//  Created by Matthew Buckley on 9/18/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

import Foundation
import UIKit

public protocol Initializable {
    init()
}

public enum NodeDensity {
    case low, medium, high
}

public protocol ElasticConfigurable: Initializable {

    var density: CGFloat { get }
    var damping: CGFloat { get }
    var frequency: CGFloat { get }
    var elasticity: CGFloat { get }
    var displayLink: CADisplayLink { get }
    var viewLayer: CAShapeLayer { get }
    var mainAnimator: UIDynamicAnimator { get }
    var nodeDensity: NodeDensity { get }

    init(withDensity density: CGFloat,
         damping: CGFloat,
         frequency: CGFloat,
         elasticity: CGFloat,
         nodeDensity: NodeDensity)

}
