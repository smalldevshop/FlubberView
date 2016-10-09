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

    var labels: [UILabel] = []
    var flubberView: FlubberView?

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
        switch touchLocation {
        case let location where location < frame.size.width / 3:
            labels[0].textColor = .green
            labels[1].textColor = .white
            labels[2].textColor = .white
            flubberView?.magnitude = .low
        case let location where location > (2 * (frame.size.width / 3)):
            labels[0].textColor = .white
            labels[1].textColor = .white
            labels[2].textColor = .green
            flubberView?.magnitude = .high
        default:
            labels[0].textColor = .white
            labels[1].textColor = .green
            labels[2].textColor = .white
            flubberView?.magnitude = .medium
        }
    }
}
