//
//  ViewController.swift
//  FlubberView Example
//
//  Created by Matthew Buckley on 9/24/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

import UIKit
import FlubberView

class ViewController: UIViewController {

    var flubberView = { () -> FlubberView in
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.yellow.cgColor
        return FlubberView(withDesiredSize: CGSize(width: 150, height: 150),
                         shapeLayer: layer,
                         damping: 0.1,
                         frequency: 2.0,
                         nodeDensity: .medium)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple
        flubberView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(flubberView)
        let origin = CGPoint(x: view.frame.midX - flubberView.frame.width / 2,
                             y: view.frame.midY - flubberView.frame.height / 2)
        flubberView.frame = CGRect(origin: origin, size: flubberView.frame.size)
        registerGestureRecognizers()
    }

    func registerGestureRecognizers() -> Void {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        flubberView.addGestureRecognizer(gestureRecognizer)
    }

    func didTap() {
        flubberView.animate()
    }

}
