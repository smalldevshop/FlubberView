//
//  FlubberViewTests.swift
//  FlubberViewTests
//
//  Created by Matthew Buckley on 9/18/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

import XCTest
@testable import FlubberView

class FlubberViewTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testNodeDistribution() {

        let size = CGSize(width: 120, height: 120)
        let flubberViewMediumDensity = FlubberView(withDesiredSize: size, damping: 0.0, frequency: 0.0)
        let flubberViewLowDensity = FlubberView(withDesiredSize: size, damping: 0.0, frequency: 0.0, nodeDensity: .low)
        let flubberViewHighDensity = FlubberView(withDesiredSize: size, damping: 0.0, frequency: 0.0, nodeDensity: .high)

        loopOverNodes(flubberView: flubberViewLowDensity, nodesPerRow: 3, distanceBetweenNodes: 60.0)
        loopOverNodes(flubberView: flubberViewMediumDensity, nodesPerRow: 5, distanceBetweenNodes: 30.0)
        loopOverNodes(flubberView: flubberViewHighDensity, nodesPerRow: 7, distanceBetweenNodes: 20.0)

    }

    func testTableFlushing() {

        // Behaviors should not accumulate accross
        // multiple animation runs
        
        let flubberView = FlubberView(withDesiredSize: CGSize.zero,
                                      damping: 0.0,
                                      frequency: 0.0)

        flubberView.animate()
        let behaviorCount = flubberView.mainAnimator.behaviors.count

        for _ in 0..<4 {
            flubberView.animate()
            XCTAssertEqual(behaviorCount, flubberView.mainAnimator.behaviors.count)
        }
        
    }

    func testNodeCount() {

        let flubberView = FlubberView(withDesiredSize: CGSize.zero,
                                      damping: 0.0,
                                      frequency: 0.0)

        // nodeDensity should defulat to .medium
        XCTAssert(flubberView.nodeDensity == .medium)

        // nodeDensity = .low should correspond to 9 total subviews
        flubberView.nodeDensity = .low
        XCTAssertEqual(flubberView.subviews.count, 9)

        // nodeDensity = .medium should correspond to 25 total subviews
        flubberView.nodeDensity = .medium
        XCTAssertEqual(flubberView.subviews.count, 25)

        // nodeDensity = .high should correspond to 49 total subviews
        flubberView.nodeDensity = .high
        XCTAssertEqual(flubberView.subviews.count, 49)
        
    }

    func loopOverNodes(flubberView: FlubberView, nodesPerRow: Int, distanceBetweenNodes: CGFloat) {
        var current = CGPoint.zero
        var nodeCount = 0
        flubberView.subviews.forEach({ node in
            let horizDistance = node.frame.origin.x - current.x
            let vertDistance = node.frame.origin.y - current.y
            let distance = sqrt((horizDistance * horizDistance) + (vertDistance * vertDistance))

            if nodeCount % nodesPerRow != 0 {
                XCTAssert(distance == distanceBetweenNodes)
            }
            
            current = node.frame.origin
            nodeCount += 1
        })
    }

}
