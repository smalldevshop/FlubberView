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

    var graphView = {
        return GraphView(withDensity: 0.5, damping: 0.0, frequency: 6.0, elasticity: 1.0, nodeDensity: .low)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple
        graphView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(graphView)
        let origin = CGPoint(x: view.frame.midX - 50, y: view.frame.midY - 50)
        graphView.frame = CGRect(origin: origin, size: graphView.frame.size)
        registerGestureRecognizers()
        graphView.show()
    }

    func registerGestureRecognizers() -> Void {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        graphView.addGestureRecognizer(gestureRecognizer)
    }

    func didTap() {
        graphView.jiggle()
    }

}

