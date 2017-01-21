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
                         frequency: 1.0,
                         nodeDensity: .medium)
    }()

    var magnitudeSlider: Slider = Slider()
    var frequencySlider: Slider = Slider()
    var dampingSlider: Slider = Slider()

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

        low.textColor = .white
        medium.textColor = .green
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
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor).isActive = true
        }

        low.widthAnchor.constraint(equalTo: medium.widthAnchor, multiplier: 1.0).isActive = true
        low.leftAnchor.constraint(equalTo: container.leftAnchor).isActive = true
        medium.leftAnchor.constraint(equalTo: low.rightAnchor).isActive = true
        medium.widthAnchor.constraint(equalTo: high.widthAnchor, multiplier: 1.0).isActive = true
        high.rightAnchor.constraint(equalTo: container.rightAnchor).isActive = true
        high.widthAnchor.constraint(equalToConstant: 70.0).isActive = true

        return container
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let labelStackView = labelContainer(forLabels: labels)

        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        magnitudeSlider.translatesAutoresizingMaskIntoConstraints = false
        dampingSlider.translatesAutoresizingMaskIntoConstraints = false
        frequencySlider.translatesAutoresizingMaskIntoConstraints = false
        flubberView.translatesAutoresizingMaskIntoConstraints = false

        view.backgroundColor = .purple
        view.addSubview(magnitudeSlider)
        view.addSubview(dampingSlider)
        view.addSubview(frequencySlider)
        view.addSubview(labelStackView)
        view.addSubview(flubberView)

        // layout
        labelStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80.0).isActive = true
        labelStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
        labelStackView.widthAnchor.constraint(equalToConstant: 210).isActive = true
        labelStackView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        for v in [
            magnitudeSlider,
            dampingSlider,
            frequencySlider
            ] {
            v.widthAnchor.constraint(equalToConstant: 210).isActive = true
            v.heightAnchor.constraint(equalToConstant: 50).isActive = true
        }

        let magnitudeLabel = UILabel()
        magnitudeLabel.text = "Magnitude"
        magnitudeLabel.textColor = .white
        magnitudeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(magnitudeLabel)
        magnitudeLabel.heightAnchor.constraint(equalTo: magnitudeSlider.heightAnchor).isActive = true
        magnitudeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        magnitudeLabel.centerYAnchor.constraint(equalTo: magnitudeSlider.centerYAnchor).isActive = true

        let frequencyLabel = UILabel()
        frequencyLabel.text = "Frequency"
        frequencyLabel.textColor = .white
        frequencyLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(frequencyLabel)
        frequencyLabel.heightAnchor.constraint(equalTo: frequencySlider.heightAnchor).isActive = true
        frequencyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        frequencyLabel.centerYAnchor.constraint(equalTo: frequencySlider.centerYAnchor).isActive = true

        let dampingLabel = UILabel()
        dampingLabel.text = "Damping"
        dampingLabel.textColor = .white
        dampingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dampingLabel)
        dampingLabel.heightAnchor.constraint(equalTo: dampingSlider.heightAnchor).isActive = true
        dampingLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10.0).isActive = true
        dampingLabel.centerYAnchor.constraint(equalTo: dampingSlider.centerYAnchor).isActive = true
        dampingLabel.centerYAnchor.constraint(equalTo: dampingSlider.centerYAnchor).isActive = true
        dampingLabel.centerYAnchor.constraint(equalTo: dampingSlider.centerYAnchor).isActive = true

        magnitudeSlider.topAnchor.constraint(equalTo: labelStackView.bottomAnchor).isActive = true
        frequencySlider.topAnchor.constraint(equalTo: magnitudeSlider.bottomAnchor).isActive = true
        dampingSlider.topAnchor.constraint(equalTo: frequencySlider.bottomAnchor).isActive = true
        magnitudeSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
        frequencySlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
        dampingSlider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10.0).isActive = true
        flubberView.topAnchor.constraint(equalTo: dampingSlider.bottomAnchor, constant: 30.0).isActive = true
        flubberView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        flubberView.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        flubberView.heightAnchor.constraint(equalToConstant: 150.0).isActive = true

        registerGestureRecognizers()

        // Inital Values
        magnitudeSlider.value = 0.5
        frequencySlider.value = 0.05
        dampingSlider.value = 0.5

        // Callbacks
        magnitudeSlider.callBack = { touchLocation in
            switch touchLocation {
            case let location where location < 1 / 3:
                self.labels[0].textColor = .green
                self.labels[1].textColor = .white
                self.labels[2].textColor = .white
                self.flubberView.magnitude = .low
            case let location where location > 2 / 3:
                self.labels[0].textColor = .white
                self.labels[1].textColor = .white
                self.labels[2].textColor = .green
                self.flubberView.magnitude = .high
            default:
                self.labels[0].textColor = .white
                self.labels[1].textColor = .green
                self.labels[2].textColor = .white
                self.flubberView.magnitude = .medium
            }
        }

        frequencySlider.callBack = { frequency in
            self.flubberView.frequency = frequency * 5.0
        }

        dampingSlider.callBack = { damping in
            self.flubberView.damping = damping
        }
    }

    func registerGestureRecognizers() -> Void {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        flubberView.addGestureRecognizer(gestureRecognizer)
    }

    func didTap() {
        flubberView.animate()
    }

}
