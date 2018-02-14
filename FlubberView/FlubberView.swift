//
//  FlubberView.swift
//  FlubberView
//
//  Created by Matthew Buckley on 9/18/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//
import UIKit

open class FlubberView: UIView {
    
    /// Controls the distance that each node (subview)
    /// will move during the animation
    public var magnitude: Magnitude = .medium
    
    /// Storage for the attachment behaviors belonging to individual subviews
    var behaviors: NSMapTable<UIView, UISnapBehavior> = NSMapTable()
    
    /// Storage for the initial origin coordinates of each individual subview
    var nodeCenterCoordinates: NSMapTable<UIView, NSValue> = NSMapTable()
    
    // MARK: ElasticConfigurable
    var displayLink: CADisplayLink = CADisplayLink()
    var shapeLayer: CAShapeLayer?
    var shapeLayerIndex: UInt32 = 0
    
    /// The corner radius of the shape layer
    var cornerRadius: CGFloat = 0.0
    
    /// initial (non-animating) size
    var desiredSize: CGSize = .zero
    
    public var frequency: CGFloat = 0.0 {
        didSet {
            reset()
        }
    }
    public var damping: CGFloat = 0.0 {
        didSet {
            reset()
        }
    }
    var nodeDensity: NodeDensity = .medium {
        didSet {
            reset()
        }
    }
    public lazy var mainAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self)
    }()
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init(withDesiredSize desiredSize: CGSize,
                         shapeLayer: CAShapeLayer? = nil,
                         shapeLayerIndex: UInt32 = 0,
                         damping: CGFloat,
                         frequency: CGFloat,
                         nodeDensity: NodeDensity = .medium) {
        super.init(frame: .zero)
        self.damping = damping
        self.shapeLayer = shapeLayer
        self.frequency = frequency
        self.nodeDensity = nodeDensity
        self.shapeLayerIndex = shapeLayerIndex
        cornerRadius = shapeLayer?.cornerRadius ?? 0.0
        self.desiredSize = desiredSize
        frame.size = desiredSize
        compose()
    }
}

public extension FlubberView {
    
    /// Controls the elasticity of the individual nodes within the
    /// FlubberView, and the length of the animation
    enum Magnitude {
        case low, medium, high
        
        /// The distance each node will move while animating
        var elasticity: CGFloat {
            let elasticity: CGFloat
            switch self {
            case .low: elasticity = 4.0
            case .medium: elasticity = 16.0
            case .high: elasticity = 64.0
            }
            return elasticity
        }
        
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupMainLayer()
        displayLink = CADisplayLink(target: self, selector: #selector(FlubberView.redraw))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    @objc func redraw() {
        shapeLayer?.path = viewPath.cgPath
    }
    
    /// Repositions all nodes within the FlubberView, and snaps
    /// them back to their original position after a delay
    ///
    /// - parameter magnitude: controls the distance that each node
    /// will move during the animation
    func animate() {
        for v in subviews {
            let initialPoint = nodeCenterCoordinates.object(forKey: v)?.cgPointValue ??
                CGPoint(x: v.frame.midX, y: v.frame.midY)
            let elasticity = magnitude.elasticity
            let snapBehavior = UISnapBehavior(item: v, snapTo: initialPoint)
            
            snapBehavior.damping = damping
            
            let oldBehavior = behaviors.object(forKey: v)
            behaviors.setObject(snapBehavior, forKey: v)
            
            if let behavior = oldBehavior {
                mainAnimator.removeBehavior(behavior)
            }
            
            self.mainAnimator.addBehavior(snapBehavior)
            v.center = CGPoint(x: v.center.x <~> elasticity, y: v.center.y <~> elasticity)
            mainAnimator.updateItem(usingCurrentState: v)
        }
    }
    
    func pop() {
        for v in subviews {
            let initialPoint = nodeCenterCoordinates.object(forKey: v)?.cgPointValue ??
                CGPoint(x: v.frame.midX, y: v.frame.midY)
            let elasticity = magnitude.elasticity * 2
            let snapBehavior = UISnapBehavior(item: v, snapTo: initialPoint)
            
            snapBehavior.damping = 0.0
            
            let oldBehavior = behaviors.object(forKey: v)
            behaviors.setObject(snapBehavior, forKey: v)
            
            if let behavior = oldBehavior {
                mainAnimator.removeBehavior(behavior)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.mainAnimator.addBehavior(snapBehavior)
            }
            
            if subviews.index(of: v) == cornerNodeIndices[0] {
                v.center = CGPoint(x: v.center.x - elasticity, y: v.center.y - elasticity)
                mainAnimator.updateItem(usingCurrentState: v)
            } else if subviews.index(of: v) == cornerNodeIndices[1] {
                v.center = CGPoint(x: v.center.x + elasticity, y: v.center.y - elasticity)
                mainAnimator.updateItem(usingCurrentState: v)
            } else if subviews.index(of: v) == cornerNodeIndices[2] {
                v.center = CGPoint(x: v.center.x + elasticity, y: v.center.y + elasticity)
                mainAnimator.updateItem(usingCurrentState: v)
            } else if subviews.index(of: v) == cornerNodeIndices[3] {
                v.center = CGPoint(x: v.center.x - elasticity, y: v.center.y + elasticity)
                mainAnimator.updateItem(usingCurrentState: v)
            }
        }
    }
    
}

private extension FlubberView {
    
    /// The number of nodes contained inside the FlubberView
    var nodeCount: Int {
        switch nodeDensity {
        case .low:
            return 3
        case .high:
            return 7
        default:
            return 5
        }
    }
    
    
    /// A collection containing the indices of the subviews
    /// at the midpoint of each of the FlubberView's 4 side
    var controlNodeIndices: [Int] {
        switch nodeDensity {
        case .low:
            return [1, 5, 7, 3]
        case .high:
            return [2, 27, 45, 21]
        default:
            return [2, 14, 22, 15]
        }
    }
    
    
    /// A collection containing the indices of the subviews in
    /// the view's 4 corners
    var cornerNodeIndices: [Int] {
        switch nodeDensity {
        case .low:
            return [0, 2, 8, 6]
        case .high:
            return [0, 6, 48, 42]
        default:
            return [0, 4, 24, 20]
        }
    }
    
    
    /// The path for the shapeLayer (if not nil)
    var viewPath: UIBezierPath {
        
        /// Create bezier path
        let bPath: UIBezierPath = UIBezierPath()
        
        /// Point on the left side of the top edge of the FlubberView, inset by the cornerRadius
        let topEdgeLeft = CGPoint(x: subviews[cornerNodeIndices[0]].center.x + cornerRadius,
                                  y: subviews[cornerNodeIndices[0]].center.y)
        
        /// Point on the right side of the top edge of the FlubberView, inset by the cornerRadius
        let topEdgeRight = CGPoint(x: subviews[cornerNodeIndices[1]].center.x - cornerRadius,
                                   y: subviews[cornerNodeIndices[1]].center.y)
        
        /// Point at the top of the right edge of the FlubberView, inset by the cornerRadius
        let rightEdgeTop = CGPoint(x: subviews[cornerNodeIndices[1]].center.x,
                                   y: subviews[cornerNodeIndices[1]].center.y + cornerRadius)
        
        /// Point at the bottom of the right edge of the FlubberView, inset by the cornerRadius
        let rightEdgeBottom = CGPoint(x: subviews[cornerNodeIndices[2]].center.x,
                                      y: subviews[cornerNodeIndices[2]].center.y - cornerRadius)
        
        /// Point on the left side of the bottom edge of the FlubberView, inset by the cornerRadius
        let bottomEdgeLeft = CGPoint(x: subviews[cornerNodeIndices[3]].center.x + cornerRadius,
                                     y: subviews[cornerNodeIndices[3]].center.y)
        
        /// Point at the top of the left edge of the FlubberView, inset by the cornerRadius
        let leftEdgeTop = CGPoint(x: subviews[cornerNodeIndices[0]].center.x,
                                  y: subviews[cornerNodeIndices[0]].center.y + cornerRadius)
        
        // Draw a point at the top left corner
        bPath.move(to: topEdgeLeft)
        
        var center: CGPoint
        
        if desiredSize.height <= cornerRadius * 2 {
            bPath.addQuadCurve(to: topEdgeRight, controlPoint: subviews[controlNodeIndices[0]].center)
            center = CGPoint(x: topEdgeRight.x,
                             y: topEdgeRight.y + cornerRadius)
            bPath.addArc(withCenter: center,
                         radius: cornerRadius,
                         startAngle: CGFloat(-M_PI_2),
                         endAngle: CGFloat(M_PI_2),
                         clockwise: true)
            
            center = CGPoint(x: topEdgeLeft.x,
                             y: topEdgeLeft.y + cornerRadius)
            bPath.addArc(withCenter: center,
                         radius: cornerRadius,
                         startAngle: CGFloat(M_PI_2),
                         endAngle: CGFloat(-M_PI_2),
                         clockwise: true)
        } else if desiredSize.width <= cornerRadius * 2 {
            bPath.move(to: rightEdgeTop)
            center = CGPoint(x: topEdgeLeft.x,
                             y: topEdgeLeft.y + cornerRadius)
            bPath.addArc(withCenter: center,
                         radius: cornerRadius,
                         startAngle: CGFloat(-M_PI),
                         endAngle: CGFloat(0.0),
                         clockwise: true)
            bPath.addQuadCurve(to: rightEdgeBottom, controlPoint: subviews[controlNodeIndices[1]].center)
            
            center = CGPoint(x: rightEdgeBottom.x - cornerRadius,
                             y: rightEdgeBottom.y)
            bPath.addArc(withCenter: center,
                         radius: cornerRadius,
                         startAngle: CGFloat(0.0),
                         endAngle: CGFloat(-M_PI),
                         clockwise: true)
            bPath.addQuadCurve(to: leftEdgeTop, controlPoint: subviews[controlNodeIndices[3]].center)
        } else {
            // move to the right side of the top edge through the center point of
            // the middle node subview of the top edge
            bPath.addQuadCurve(to: topEdgeRight, controlPoint: subviews[controlNodeIndices[0]].center)
            center = CGPoint(x: topEdgeRight.x,
                             y: topEdgeRight.y + cornerRadius)
            bPath.addArc(withCenter: center,
                         radius: cornerRadius,
                         startAngle: CGFloat(M_PI_2),
                         endAngle: 0.0,
                         clockwise: true)
            
            // move to the bottom end of the right edge through the center point of
            // the middle node of the right edge
            bPath.addQuadCurve(to: rightEdgeBottom,
                               controlPoint: subviews[controlNodeIndices[1]].center)
            center = CGPoint(x: subviews[cornerNodeIndices[2]].center.x - cornerRadius,
                             y: subviews[cornerNodeIndices[2]].center.y - cornerRadius)
            bPath.addArc(withCenter: center,
                         radius: cornerRadius,
                         startAngle: 0,
                         endAngle: CGFloat(M_PI_2),
                         clockwise: true)
            
            // move to the left end of the bottom edge through the center point of
            // the middle node of the bottom edge
            bPath.addQuadCurve(to: bottomEdgeLeft, controlPoint: subviews[controlNodeIndices[2]].center)
            center = CGPoint(x: subviews[cornerNodeIndices[3]].center.x + cornerRadius,
                             y: subviews[cornerNodeIndices[3]].center.y - cornerRadius)
            bPath.addArc(withCenter: center,
                         radius: cornerRadius,
                         startAngle: CGFloat(-M_PI_4),
                         endAngle: CGFloat(M_PI),
                         clockwise: true)
            
            // move to the top end of the left edgee through the center point of
            // the middle node of the left edge
            bPath.addQuadCurve(to: leftEdgeTop, controlPoint: subviews[controlNodeIndices[3]].center)
            center = CGPoint(x: subviews[cornerNodeIndices[0]].center.x + cornerRadius,
                             y: subviews[cornerNodeIndices[0]].center.y + cornerRadius)
            bPath.addArc(withCenter: center,
                         radius: cornerRadius,
                         startAngle: CGFloat(M_PI),
                         endAngle: CGFloat(M_PI_2),
                         clockwise: true)
        }
        
        return bPath
    }
    
    
    /// Adds shapeLayer as a sublayer if not nil
    func setupMainLayer() {
        guard let shapeLayer = shapeLayer else {
            return
        }
        layer.insertSublayer(shapeLayer, at: shapeLayerIndex)
    }
    
    
    /// Creates evenly spaced grid of subviews and adds them as subviews
    func compose() {
        
        var tag: Int = 0
        let hSeparation = frame.size.width.separation(for: nodeCount)
        let vSeparation = frame.size.height.separation(for: nodeCount)
        
        let (hAmtToCenter, vAmtToCenter) = frame.size.distanceToCenter
        
        for i in 0..<nodeCount {
            for j in 0..<nodeCount {
                let hMultiplier = CGFloat(j)
                let vMultiplier = CGFloat(i)
                let xOrigin = bounds.origin.x + hAmtToCenter + hSeparation * hMultiplier
                let yOrigin = bounds.origin.y + vAmtToCenter + vSeparation * vMultiplier
                
                let childViewRect = CGRect(x: xOrigin,
                                           y: yOrigin,
                                           width: 3.0,
                                           height: 3.0)
                
                let childView = UIView(frame: childViewRect)
                
                childView.tag = tag
                nodeCenterCoordinates.setObject(NSValue(cgPoint: childView.frame.origin),
                                                forKey: childView)
                addSubview(childView)
                tag += 1
            }
        }
        attachViews()
    }
    
    
    
    /// Binds all subviews to their (horizontally or vertically) adjacent views using
    /// a UIAttachmentBehavior
    func attachViews() {
        
        let distanceBetweenNodes = frame.size.width/CGFloat(nodeCount - 1)
        
        for i in 0..<subviews.count {
            let view = subviews[i]
            
            for nextView in subviews {
                if (view.center.x - nextView.center.x == distanceBetweenNodes) ||
                    (view.center.y - nextView.center.y == distanceBetweenNodes) {
                    let attach: UIAttachmentBehavior = UIAttachmentBehavior(item: view,
                                                                            attachedTo: nextView)
                    
                    attach.damping = 0.1
                    attach.frequency = 1
                    
                    mainAnimator.addBehavior(attach)
                    
                    let bh: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [view])
                    bh.allowsRotation = false
                    bh.elasticity = 1
                    
                    mainAnimator.addBehavior(bh)
                }
            }
        }
    }
    
    func reset() {
        subviews.forEach({ $0.removeFromSuperview() })
        compose()
    }
    
}

private extension CGSize {
    
    /// A coordinate pair representintg the distance from
    /// any edge of a CGRect of a given size to the center
    var distanceToCenter: (CGFloat, CGFloat) {
        return (width/2 - width/2, height/2 - height/2)
    }
    
}

private extension CGFloat {
    
    /// Calculates the distance that should separate each node
    ///
    /// - parameter nodeCount: the number of nodes contained in the FlubberView
    ///
    /// - returns: the distance that should separate the nodes in the FlubberView
    func separation(for nodeCount: Int) -> CGFloat {
        return self / CGFloat(nodeCount - 1)
    }
    
}
