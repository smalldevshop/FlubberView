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

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
