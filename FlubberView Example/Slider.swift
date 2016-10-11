//
//  Slider.swift
//  FlubberView
//
//  Created by Matthew Buckley on 10/9/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

import UIKit
import FlubberView

class Slider: UISlider {

    var callBack: ((CGFloat) -> ())?

    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        highLightLabel(forTouchLocation: touch.location(in: self).x)
        return true
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        highLightLabel(forTouchLocation: touch.location(in: self).x)
        return true
    }

    func highLightLabel(forTouchLocation touchLocation: CGFloat) -> Void {
        callBack?(max(0.0, CGFloat(touchLocation / frame.size.width)))
    }
}
