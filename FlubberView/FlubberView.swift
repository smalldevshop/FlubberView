//
//  FlubberView.swift
//  FlubberView
//
//  Created by Matthew Buckley on 9/18/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

import UIKit

//final class FlubberView: UIView {
//
//    private var nDivisions: Int = 0
//    private var viewSize: CGSize = CGSize.zero
//    private var displayLink: CADisplayLink?
//    private var viewLayer: CAShapeLayer = CAShapeLayer()
//    private var elasticity: CGFloat = 0.0
//    private var density: CGFloat = 0.0
//    private var damping: CGFloat = 0.0
//    private var frequency: CGFloat = 0.0
//    private var mainAnimator: UIDynamicAnimator = UIDynamicAnimator()
//
//    private var viewPath: UIBezierPath {
//        let bPath: UIBezierPath = UIBezierPath()
//
//        let r = 0.0
//
//        let topEdgeLeft = CGPoint(x: subviews[0].center.x + r, y: subviews[0].center.y)
//        let topEdgeRight = CGPoint(x: subviews[2].center.x - r, y: subviews[2].center.y)
//        let rightEdgeBottom = CGPoint(x: subviews[8].center.x, y: subviews[8].center.y - r)
//        let leftEdgeTop = CGPoint(x: subviews[0].center.x, y: subviews[0].center.y + r)
//        let bottomEdgeLeft = CGPoint(x: subviews[6].center.x + r, y: subviews[6].center.y)
//
//        bPath.move(to: topEdgeLeft)
//        bPath.addQuadCurve(to: topEdgeRight, controlPoint: subviews[1].center)
//        var center = CGPoint(x: topEdgeRight.x, y: topEdgeRight.y + r)
//        bPath.addArc(withCenter: center, radius: r, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: true)
//
//        bPath.addQuadCurve(to: rightEdgeBottom, controlPoint: subviews[5].center)
//        center = CGPoint(x: rightEdgeBottom.x - r, y: rightEdgeBottom.y)
//        bPath.addArc(withCenter: center, radius: r, startAngle: 0, endAngle: CGFloat(2 * M_PI_4), clockwise: true)
//
//        bPath.addQuadCurve(to: bottomEdgeLeft, controlPoint: subviews[7].center)
//        center = CGPoint(x: bottomEdgeLeft.x, y: bottomEdgeLeft.y - r)
//        bPath.addArc(withCenter: center, radius: r, startAngle: CGFloat(-M_PI_4), endAngle: CGFloat(M_PI), clockwise: true)
//
//        bPath.addQuadCurve(to: leftEdgeTop, controlPoint: subviews[3].center)
//        center = CGPoint(x: leftEdgeTop.x + r, y: leftEdgeTop.y)
//        bPath.addArc(withCenter: center, radius: r, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: true)
//
//
//        return bPath
//    }
//
//    private var fillColor: UIColor {
//        return Session.sharedInstance.currentGestureTouchColor ?? .clear
//    }
//
//    override var backgroundColor: UIColor? {
//        didSet {
//            backgroundColor = Session.sharedInstance.currentGestureTouchColor ?? .clear
//        }
//    }
//
//    convenience init(withFrame frame: CGRect,
//                                   viewSize: CGSize,
//                                   elasticity: CGFloat,
//                                   density: CGFloat,
//                                   damping: CGFloat,
//                                   frequency: CGFloat) {
//        self.init(frame: frame)
//        layer.cornerRadius = Session.sharedInstance.cornerRadius
//        self.viewSize = viewSize
//        self.elasticity = elasticity
//        self.density = density
//        self.damping = damping
//        self.frequency = frequency
//
//        setup()
//    }
//
//    func redraw() {
//        viewLayer.path = viewPath.cgPath
//    }
//
//    func show() {
//        setupMainLayer()
//        displayLink = CADisplayLink(target: self, selector: #selector(ElasticView.redraw))
//        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
//    }
//
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        jiggle()
//    }
//
//
//}
//
//private extension ElasticView {
//
//    func setup() {
//        nDivisions = 3
//
//        var tag: Int = 0
//        for i in 0..<nDivisions {
//            for j in 0..<nDivisions {
//                let hMultiplier = CGFloat(j)
//                let vMultiplier = CGFloat(i)
//
//                let hSeparation = viewSize.width / CGFloat(nDivisions - 1)
//                let vSeparation = viewSize.height / CGFloat(nDivisions - 1)
//
//                let hAmtToCenter = bounds.width/2 - viewSize.width/2
//                let vAmtToCenter = bounds.height/2 - viewSize.height/2
//
//                let childViewRect = CGRect(x: bounds.origin.x + hAmtToCenter + hSeparation*hMultiplier,
//                                           y: bounds.origin.y + vAmtToCenter + vSeparation*vMultiplier,
//                                           width: 1.0,
//                                           height: 1.0)
//
//                let childView = UIView(frame: childViewRect)
//
//                childView.tag = tag
//                childView.backgroundColor = .clear
//                addSubview(childView)
//                tag += 1
//            }
//        }
//        attachViews()
//    }
//
//    func attachViews() {
//        mainAnimator = UIDynamicAnimator(referenceView: self)
//
//        let separation = viewSize.width/CGFloat(nDivisions - 1)
//
//        for i in 0..<subviews.count {
//            let view = subviews[i]
//
//            for nextView in subviews {
//                if (view.center.x - nextView.center.x == separation) || (view.center.y - nextView.center.y == separation) {
//                    let attach: UIAttachmentBehavior = UIAttachmentBehavior(item: view, attachedTo: nextView)
//
//                    attach.damping = damping
//                    attach.frequency = frequency
//                    mainAnimator.addBehavior(attach)
//
//                    let bh: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [view])
//                    bh.elasticity = elasticity
//                    bh.density = density
//
//                    mainAnimator.addBehavior(bh)
//                }
//            }
//        }
//    }
//
//    func setupMainLayer() {
//        viewLayer = CAShapeLayer()
//        viewLayer.path = viewPath.cgPath
//        viewLayer.fillColor = fillColor.cgColor
//        viewLayer.cornerRadius = Session.sharedInstance.cornerRadius
//        layer.addSublayer(viewLayer)
//    }
//
//    func jiggle() {
//        for v in subviews {
//            if v.tag % 2 == 0 {
//                v.center = CGPoint(x: v.center.x + 8, y: v.center.y + 8)
//                mainAnimator.updateItem(usingCurrentState: v)
//            }
//        }
//    }
//
//}
