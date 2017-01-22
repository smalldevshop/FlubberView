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


/// Used to specify the number of nodes to be
/// distributed inside the FlubberView
///
/// - low:    9 nodes total
/// - medium: 25 nodes total
/// - high:   49 nodes total
public enum NodeDensity {
    case low, medium, high
}

protocol ElasticConfigurable: Initializable {

    /// The amount of damping (energy lost per oscillation)
    /// to apply to individual nodes within the FlubberView
    var damping: CGFloat { get set }

    /// The frequency of oscillation (oscillations per second)
    /// for the attachment behavior that connects individual nodes
    /// within the FlubberView
    var frequency: CGFloat { get set }

    /// The duration of the animation (view snaps back into place
    /// after the duration has elapsed)
    var duration: TimeInterval { get set }

    /// A CADisplayLink instance to handle redrawing the FlubberView
    /// at regular intervals
    var displayLink: CADisplayLink { get }

    /// The layer that sits on top of the frame of the FlubberView
    var shapeLayer: CAShapeLayer? { get }

    /// The mainAnimator provides physics-related animations to
    /// the FlubberView, which is its referenceView
    var mainAnimator: UIDynamicAnimator { get }

    /// Controls the number of nodes distributed inside the FlubberView
    var nodeDensity: NodeDensity { get }

    init(withDesiredSize desiredSize: CGSize,
         shapeLayer: CAShapeLayer?,
         damping: CGFloat,
         frequency: CGFloat,
         nodeDensity: NodeDensity)

}
