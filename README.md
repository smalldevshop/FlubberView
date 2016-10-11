# FlubberView
A `UIView` subclass with the ability to jiggle and flop in the manner of Flubber.

[![Build Status](https://travis-ci.org/NiceThings/Mondrian.svg?branch=develop)](https://travis-ci.org/NiceThings/FlubberView)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

-------------

## Installation with Carthage

BonMot is compatible with [Carthage](https://github.com/Carthage/Carthage). To install it, simply add the following line to your Cartfile:

```
github "NiceThings/FlubberView"
```

## Design

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

`FlubberView` was inspired by @victorBaro's mighty [VBFJellyView](https://github.com/victorBaro/VBFJellyView)