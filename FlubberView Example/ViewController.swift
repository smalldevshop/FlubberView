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
                         shapeLayer: nil,
                         damping: 0.1,
                         frequency: 2.0,
                         nodeDensity: .medium)
    }()

    var slider: Slider = Slider()

    var labels: [UILabel] = [
        UILabel(),
        UILabel(),
        UILabel()
    ]

    func labelContainer(forLabels labels: [UILabel]) -> UIStackView {
        let container = UIStackView()
        container.axis = .horizontal

        let low = labels[0]
        let medium = labels[1]
        let high = labels[2]

        low.textColor = .green
        medium.textColor = .white
        high.textColor = .white

        low.textAlignment = .left
        medium.textAlignment = .center
        high.textAlignment = .right

        low.text = "low"
        medium.text = "medium"
        high.text = "high"

        for label: UILabel in [low, medium, high] {
            label.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(label)
        }

        low.widthAnchor.constraint(equalTo: medium.widthAnchor, multiplier: 1.0).isActive = true
        medium.leftAnchor.constraint(equalTo: low.rightAnchor).isActive = true
        medium.widthAnchor.constraint(equalTo: high.widthAnchor, multiplier: 1.0).isActive = true
        high.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        high.widthAnchor.constraint(equalToConstant: 100.0).isActive = true

        return container
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let labelStackView = labelContainer(forLabels: labels)
        view.backgroundColor = .purple
        view.addSubview(slider)
        view.addSubview(labelStackView)
        view.addSubview(flubberView)
        let origin = CGPoint(x: view.frame.midX - flubberView.frame.width / 2,
                             y: view.frame.midY - flubberView.frame.height / 2)
        slider.labels = labels
        slider.frame = CGRect(origin: CGPoint(x: origin.x - 75,
                                              y: origin.y - 100),
                                              size: CGSize(width: 300, height: 50))
        slider.flubberView = flubberView
        labelStackView.frame = CGRect(origin: CGPoint(x: slider.frame.origin.x,
                                              y: slider.frame.origin.y - 50),
                              size: slider.frame.size)
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
