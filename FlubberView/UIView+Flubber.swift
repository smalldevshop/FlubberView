//
//  UIView+Flubber.swift
//  FlubberView
//
//  Created by Matthew Buckley on 9/18/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

import UIKit

public enum ElasticError: Error {
    case nodeCount(String)
}

public final class GraphView: UIView {

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

    var controlNodeIndices: [Int] {
        switch nodeDensity {
        case .low:
            return [1,5,7,3]
        case .high:
            return [2,27,45,21]
        default:
            return [2,14,22,15]
        }
    }

    var cornerNodeIndices: [Int] {
        switch nodeDensity {
        case .low:
            return [0,2,8,6]
        case .high:
            return [0,6,48,42]
        default:
            return [0,4,24,20]
        }
    }

    // MARK: ElasticConfigurable
    public var density: CGFloat = 0.0
    public var damping: CGFloat = 0.0
    public var frequency: CGFloat = 6.0
    public var elasticity: CGFloat = 0.5
    public var displayLink: CADisplayLink = CADisplayLink()
    public var viewLayer: CAShapeLayer = CAShapeLayer()
    public var nodeDensity: NodeDensity = .medium
    lazy public var mainAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self)
    }()
    

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

}

extension GraphView: ElasticConfigurable {

    public convenience init(withDensity density: CGFloat,
                            damping: CGFloat,
                            frequency: CGFloat,
                            elasticity: CGFloat,
                            nodeDensity: NodeDensity = .medium) {
        self.init()
        self.density = density
        self.damping = damping
        self.frequency = frequency
        self.elasticity = elasticity
        self.nodeDensity = .high
        frame.size = CGSize(width: 150, height: 150)
        compose()
    }
}

public extension GraphView {

    var viewPath: UIBezierPath {
        let bPath: UIBezierPath = UIBezierPath()
        
        let topEdgeLeft = CGPoint(x: subviews[cornerNodeIndices[0]].center.x , y: subviews[cornerNodeIndices[0]].center.y)
        let topEdgeRight = CGPoint(x: subviews[cornerNodeIndices[1]].center.x , y: subviews[cornerNodeIndices[1]].center.y)
        let rightEdgeBottom = CGPoint(x: subviews[cornerNodeIndices[2]].center.x, y: subviews[cornerNodeIndices[2]].center.y )
        let bottomEdgeLeft = CGPoint(x: subviews[cornerNodeIndices[3]].center.x , y: subviews[cornerNodeIndices[3]].center.y)

        bPath.move(to: topEdgeLeft)
        bPath.addQuadCurve(to: topEdgeRight, controlPoint: subviews[controlNodeIndices[0]].center)
        var center = CGPoint(x: topEdgeRight.x, y: topEdgeRight.y )
        bPath.addArc(withCenter: center, radius: 0.0, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: true)

        bPath.addQuadCurve(to: rightEdgeBottom, controlPoint: subviews[controlNodeIndices[1]].center)
        center = CGPoint(x: rightEdgeBottom.x , y: rightEdgeBottom.y)
        bPath.addArc(withCenter: center, radius: 0.0, startAngle: 0, endAngle: CGFloat(2 * M_PI_4), clockwise: true)

        bPath.addQuadCurve(to: bottomEdgeLeft, controlPoint: subviews[controlNodeIndices[2]].center)
        center = CGPoint(x: bottomEdgeLeft.x, y: bottomEdgeLeft.y )
        bPath.addArc(withCenter: center, radius: 0.0, startAngle: CGFloat(-M_PI_4), endAngle: CGFloat(M_PI), clockwise: true)

        bPath.addQuadCurve(to: topEdgeLeft, controlPoint: subviews[controlNodeIndices[3]].center)
        center = CGPoint(x: topEdgeLeft.x , y: topEdgeLeft.y)
        bPath.addArc(withCenter: center, radius: 0.0, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: true)

        return bPath
    }

    func show() {
        setupMainLayer()
        displayLink = CADisplayLink(target: self, selector: #selector(GraphView.redraw))
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    func redraw() {
        viewLayer.path = viewPath.cgPath
    }
    
    func jiggle() {
        for v in subviews {
            if v.tag % 2 == 0 {
                let initialCenter = CGPoint(x: v.frame.midX, y: v.frame.midY)
                v.center = CGPoint(x: v.center.x - 8, y: v.center.y - 8)
                let snapBehavior = UISnapBehavior(item: v, snapTo: initialCenter)
                mainAnimator.addBehavior(snapBehavior)
                mainAnimator.updateItem(usingCurrentState: v)
            }
        }
    }

}

private extension GraphView {

    func setupMainLayer() {
        viewLayer = CAShapeLayer()
        viewLayer.path = viewPath.cgPath
        viewLayer.fillColor = UIColor.yellow.cgColor
        viewLayer.cornerRadius = 5.0
        layer.addSublayer(viewLayer)
    }

    func compose() {

        var tag: Int = 0
        for i in 0..<nodeCount {
            for j in 0..<nodeCount {
                let hMultiplier = CGFloat(j)
                let vMultiplier = CGFloat(i)

                let hSeparation = frame.size.width / CGFloat(nodeCount - 1)
                let vSeparation = frame.size.height / CGFloat(nodeCount - 1)

                let hAmtToCenter = frame.size.width/2 - frame.size.width/2
                let vAmtToCenter = frame.size.height/2 - frame.size.height/2

                let childViewRect = CGRect(x: bounds.origin.x + hAmtToCenter + hSeparation*hMultiplier,
                                           y: bounds.origin.y + vAmtToCenter + vSeparation*vMultiplier,
                                           width: 3.0,
                                           height: 3.0)

                let childView = UIView(frame: childViewRect)

                childView.tag = tag
                childView.backgroundColor = .green
                addSubview(childView)
                tag += 1
            }
        }
        attachViews()
    }

    func attachViews() {

        let separation = frame.size.width/CGFloat(nodeCount - 1)

        for i in 0..<subviews.count {
            let view = subviews[i]

            for nextView in subviews {
                if (view.center.x - nextView.center.x == separation) || (view.center.y - nextView.center.y == separation) {
                    let attach: UIAttachmentBehavior = UIAttachmentBehavior(item: view, attachedTo: nextView)

                    attach.damping = damping
                    attach.frequency = frequency
                    mainAnimator.addBehavior(attach)

                    let bh: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [view])
                    bh.elasticity = elasticity
                    bh.density = density

                    mainAnimator.addBehavior(bh)
                }
            }
        }
    }

}
