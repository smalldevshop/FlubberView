//
//  RandomOperator.swift
//  FlubberView
//
//  Created by Matthew Buckley on 9/18/16.
//  Copyright © 2016 Nice Things. All rights reserved.
//

infix operator <~> : normal

precedencegroup normal {
    associativity: left
}

func <~> (lhs: CGFloat, rhs: CGFloat) -> CGFloat {

    return arc4random_uniform(2) == 0 ? lhs - rhs : lhs + rhs

}
