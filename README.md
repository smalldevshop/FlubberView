# FlubberView
A very special `UIView` subclass.

[![Build Status](https://travis-ci.org/NiceThings/FlubberView.svg?branch=develop)](https://travis-ci.org/NiceThings/FlubberView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/BentoMap.svg?style=flat)](http://cocoapods.org/pods/FlubberView)
[![License](https://img.shields.io/cocoapods/l/BentoMap.svg?style=flat)](http://cocoapods.org/pods/FlubberView)

-------------

## Installation with Carthage

FlubberView is compatible with [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```
github "NiceThings/FlubberView"
```

## Design
FlubberView consists of a `UIView` and a collection of `subviews` arranged in a grid. Each subview is attached to the 2 views immediately horizontally adjacent to it with a `UIAttachmentBehavior`.

The `animate()` function repositions each subview, causing the grid to jiggle and eventually settle. 


<br/>
<p align="center" >
<img style="width: 20%; display: inline-block" src="https://raw.github.com/nicethings/flubberview/master/nodes.gif" alt="Overview" />
<br/>
</p>
A `CAShapeLayer` can be passed into the constructor to give your `FlubberView` coherent shape.
<br/>
<p align="center" >

<img style="width: 20%; display: inline-block; padding-right: 20px" src="https://raw.github.com/nicethings/flubberview/master/layer.gif" style="display: inline-block" alt="Overview" />
</p>
<br/>

## Usage

Configure your `FlubberView` at initialization time with the following parameters:

- `desiredSize`: a `CGSize` for your `FlubberView`
- `damping`: to put it one way, the percentage of "flubbery-ness" lost with each oscillation of your `FlubberView` (expressed as a value between 0 and 1)
- `frequency`: the speed at which your `FlubberView` oscillates
- `nodeDensity`: the relative concentration of subviews within your `FlubberView`. Enum values of `low`, `medium`, and `high` correspond to `9`, `25`, and `49`

Additionaly, you can pass a `CAShapeLayer` into the constructor to sit on top of your `FlubberView` and provide a coherent shape.


After initialization, you can modify your `FlubberView`'s `magnitude` property to change the distance that each constituent subview will "jump" during animation.


Trigger your `FlubberView`'s animation by calling `animate()`

### Inspiration

`FlubberView` was inspired by [victorBaro](https://github.com/victorBaro)'s mighty [VBFJellyView](https://github.com/victorBaro/VBFJellyView)
