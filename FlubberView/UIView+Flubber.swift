//
//  UIView+Flubber.swift
//  FlubberView
//
//  Created by Matthew Buckley on 9/18/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

import UIKit

final class GraphView: UIView {

    // MARK: Graph
    var size: CGSize = CGSize.zero
    var nodeCount: Int = 3

    // MARK: ElasticConfigurable
    var density: CGFloat = 0.0
    var damping: CGFloat = 0.0
    var frequency: CGFloat = 0.0
    var elasticity: CGFloat = 0.0
    var displayLink: CADisplayLink = CADisplayLink()
    var viewLayer: CAShapeLayer = CAShapeLayer()
    lazy var mainAnimator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self)
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

extension GraphView: Graph {
    
    typealias SizeType = CGSize

    public convenience init(withNodeCount nodeCount: Int, desiredSize: CGSize) {
        self.init()
        self.nodeCount = nodeCount
        self.size = desiredSize
    }

}

extension GraphView: ElasticConfigurable {

    public convenience init() {
        self.init()
    }

}

extension GraphView {

    var viewPath: UIBezierPath {
        let bPath: UIBezierPath = UIBezierPath()

        let r = CGFloat(0.0)

        let topEdgeLeft = CGPoint(x: subviews[0].center.x + r, y: subviews[0].center.y)
        let topEdgeRight = CGPoint(x: subviews[2].center.x - r, y: subviews[2].center.y)
        let rightEdgeBottom = CGPoint(x: subviews[8].center.x, y: subviews[8].center.y - r)
        let leftEdgeTop = CGPoint(x: subviews[0].center.x, y: subviews[0].center.y + r)
        let bottomEdgeLeft = CGPoint(x: subviews[6].center.x + r, y: subviews[6].center.y)

        bPath.move(to: topEdgeLeft)
        bPath.addQuadCurve(to: topEdgeRight, controlPoint: subviews[1].center)
        var center = CGPoint(x: topEdgeRight.x, y: topEdgeRight.y + r)
        bPath.addArc(withCenter: center, radius: r, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: true)

        bPath.addQuadCurve(to: rightEdgeBottom, controlPoint: subviews[5].center)
        center = CGPoint(x: rightEdgeBottom.x - r, y: rightEdgeBottom.y)
        bPath.addArc(withCenter: center, radius: r, startAngle: 0, endAngle: CGFloat(2 * M_PI_4), clockwise: true)

        bPath.addQuadCurve(to: bottomEdgeLeft, controlPoint: subviews[7].center)
        center = CGPoint(x: bottomEdgeLeft.x, y: bottomEdgeLeft.y - r)
        bPath.addArc(withCenter: center, radius: r, startAngle: CGFloat(-M_PI_4), endAngle: CGFloat(M_PI), clockwise: true)

        bPath.addQuadCurve(to: leftEdgeTop, controlPoint: subviews[3].center)
        center = CGPoint(x: leftEdgeTop.x + r, y: leftEdgeTop.y)
        bPath.addArc(withCenter: center, radius: r, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: true)

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

}

private extension GraphView {

    func setupMainLayer() {
        let viewLayer = CAShapeLayer()
        viewLayer.path = viewPath.cgPath
        viewLayer.fillColor = UIColor.purple.cgColor
        viewLayer.cornerRadius = 5.0
        layer.addSublayer(viewLayer)
    }

    func compose() {

        var tag: Int = 0
        for i in 0..<nodeCount {
            for j in 0..<nodeCount {
                let hMultiplier = CGFloat(j)
                let vMultiplier = CGFloat(i)

                let hSeparation = size.width / CGFloat(nodeCount - 1)
                let vSeparation = size.height / CGFloat(nodeCount - 1)

                let hAmtToCenter = size.width/2 - size.width/2
                let vAmtToCenter = size.height/2 - size.height/2

                let childViewRect = CGRect(x: bounds.origin.x + hAmtToCenter + hSeparation*hMultiplier,
                                           y: bounds.origin.y + vAmtToCenter + vSeparation*vMultiplier,
                                           width: 1.0,
                                           height: 1.0)

                let childView = UIView(frame: childViewRect)

                childView.tag = tag
                childView.backgroundColor = .clear
                addSubview(childView)
                tag += 1
            }
        }

    }

    func attachViews() {

        let separation = size.width/CGFloat(nodeCount - 1)

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
