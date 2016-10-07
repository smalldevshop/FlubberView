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

    var flubberView = {
        return FlubberView(withDesiredSize: CGSize(width: 150, height: 150),
                         damping: 5.0,
                         frequency: 16.0,
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

