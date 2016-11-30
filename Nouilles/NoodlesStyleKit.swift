//
//  NoodlesStyleKit.swift
//  Nouilles
//
//  Created by Denis Ricard on 2016-11-30.
//  Copyright © 2016 Hexaedre. All rights reserved.
//
//  Generated by PaintCode
//  http://www.paintcodeapp.com
//



import UIKit

public class NoodlesStyleKit : NSObject {

    //// Cache

    private struct Cache {
        static let timer1: UIColor = UIColor(red: 0.994, green: 0.967, blue: 0.599, alpha: 1.000)
        static let timer2: UIColor = NoodlesStyleKit.timer1.shadow(withLevel: 0.1)
        static let timerBkg: UIColor = UIColor(red: 0.909, green: 0.685, blue: 0.075, alpha: 1.000)
        static let baseGreen: UIColor = UIColor(red: 0.602, green: 0.733, blue: 0.392, alpha: 1.000)
        static let baseYellow: UIColor = UIColor(red: 0.974, green: 0.932, blue: 0.127, alpha: 1.000)
        static let baseOrange: UIColor = UIColor(red: 1.000, green: 0.782, blue: 0.122, alpha: 1.000)
        static let lighterGreen: UIColor = NoodlesStyleKit.baseGreen.highlight(withLevel: 0.3)
        static let darkerGreen: UIColor = NoodlesStyleKit.baseGreen.shadow(withLevel: 0.3)
        static let lighterYellow: UIColor = NoodlesStyleKit.baseYellow.highlight(withLevel: 0.3)
        static let darkerYellow: UIColor = NoodlesStyleKit.baseYellow.shadow(withLevel: 0.1)
        static let lighterOrange: UIColor = NoodlesStyleKit.baseOrange.highlight(withLevel: 0.3)
        static let darkerOrange: UIColor = NoodlesStyleKit.baseOrange.shadow(withLevel: 0.3)
        static let timerGradient: CGGradient = CGGradient(colorsSpace: nil, colors: [NoodlesStyleKit.timer1.cgColor, NoodlesStyleKit.timerBkg.cgColor] as CFArray, locations: [0, 1])!
        static var imageOfScanFailure: UIImage?
        static var scanFailureTargets: [AnyObject]?
        static var imageOfScanSuccess: UIImage?
        static var scanSuccessTargets: [AnyObject]?
        static var imageOfScanProcessing: UIImage?
        static var scanProcessingTargets: [AnyObject]?
        static var imageOfNouille: UIImage?
        static var nouilleTargets: [AnyObject]?
        static var imageOfMealSizeIndicator: UIImage?
        static var mealSizeIndicatorTargets: [AnyObject]?
        static var imageOfMealSizeIndicatorSD: UIImage?
        static var mealSizeIndicatorSDTargets: [AnyObject]?
    }

    //// Colors

    public dynamic class var timer1: UIColor { return Cache.timer1 }
    public dynamic class var timer2: UIColor { return Cache.timer2 }
    public dynamic class var timerBkg: UIColor { return Cache.timerBkg }
    public dynamic class var baseGreen: UIColor { return Cache.baseGreen }
    public dynamic class var baseYellow: UIColor { return Cache.baseYellow }
    public dynamic class var baseOrange: UIColor { return Cache.baseOrange }
    public dynamic class var lighterGreen: UIColor { return Cache.lighterGreen }
    public dynamic class var darkerGreen: UIColor { return Cache.darkerGreen }
    public dynamic class var lighterYellow: UIColor { return Cache.lighterYellow }
    public dynamic class var darkerYellow: UIColor { return Cache.darkerYellow }
    public dynamic class var lighterOrange: UIColor { return Cache.lighterOrange }
    public dynamic class var darkerOrange: UIColor { return Cache.darkerOrange }

    //// Gradients

    public dynamic class var timerGradient: CGGradient { return Cache.timerGradient }

    //// Drawing Methods

    public dynamic class func drawTimerAnimation(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 200, height: 200), resizing: ResizingBehavior = .aspectFit, timerRatio: CGFloat = 0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 200, height: 200), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 200, y: resizedFrame.height / 200)



        //// Variable Declarations
        let timerDash: CGFloat = 6 + timerRatio * 478

        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 100, y: 37))
        bezierPath.addCurve(to: CGPoint(x: 71.13, y: 43.99), controlPoint1: CGPoint(x: 89.59, y: 37), controlPoint2: CGPoint(x: 79.78, y: 39.52))
        bezierPath.addCurve(to: CGPoint(x: 37, y: 100), controlPoint1: CGPoint(x: 50.86, y: 54.46), controlPoint2: CGPoint(x: 37, y: 75.61))
        bezierPath.addCurve(to: CGPoint(x: 100, y: 163), controlPoint1: CGPoint(x: 37, y: 134.79), controlPoint2: CGPoint(x: 65.21, y: 163))
        bezierPath.addCurve(to: CGPoint(x: 163, y: 100), controlPoint1: CGPoint(x: 134.79, y: 163), controlPoint2: CGPoint(x: 163, y: 134.79))
        bezierPath.addCurve(to: CGPoint(x: 100, y: 37), controlPoint1: CGPoint(x: 163, y: 65.21), controlPoint2: CGPoint(x: 134.79, y: 37))
        bezierPath.close()
        bezierPath.move(to: CGPoint(x: 190, y: 100))
        bezierPath.addCurve(to: CGPoint(x: 100, y: 190), controlPoint1: CGPoint(x: 190, y: 149.71), controlPoint2: CGPoint(x: 149.71, y: 190))
        bezierPath.addCurve(to: CGPoint(x: 10, y: 100), controlPoint1: CGPoint(x: 50.29, y: 190), controlPoint2: CGPoint(x: 10, y: 149.71))
        bezierPath.addCurve(to: CGPoint(x: 48.79, y: 25.98), controlPoint1: CGPoint(x: 10, y: 69.32), controlPoint2: CGPoint(x: 25.35, y: 42.23))
        bezierPath.addCurve(to: CGPoint(x: 100, y: 10), controlPoint1: CGPoint(x: 63.33, y: 15.9), controlPoint2: CGPoint(x: 80.97, y: 10))
        bezierPath.addCurve(to: CGPoint(x: 190, y: 100), controlPoint1: CGPoint(x: 149.71, y: 10), controlPoint2: CGPoint(x: 190, y: 50.29))
        bezierPath.close()
        context.saveGState()
        bezierPath.addClip()
        context.drawLinearGradient(NoodlesStyleKit.timerGradient, start: CGPoint(x: 100, y: 10), end: CGPoint(x: 100, y: 190), options: [])
        context.restoreGState()


        //// timerMask Drawing
        context.saveGState()
        context.translateBy(x: 100, y: 100)
        context.rotate(by: -90 * CGFloat.pi/180)

        let timerMaskPath = UIBezierPath()
        timerMaskPath.move(to: CGPoint(x: 76.5, y: 0))
        timerMaskPath.addCurve(to: CGPoint(x: -0, y: 76.5), controlPoint1: CGPoint(x: 76.5, y: 42.25), controlPoint2: CGPoint(x: 42.25, y: 76.5))
        timerMaskPath.addCurve(to: CGPoint(x: -76.5, y: 0), controlPoint1: CGPoint(x: -42.25, y: 76.5), controlPoint2: CGPoint(x: -76.5, y: 42.25))
        timerMaskPath.addCurve(to: CGPoint(x: 0, y: -76.5), controlPoint1: CGPoint(x: -76.5, y: -42.25), controlPoint2: CGPoint(x: -42.25, y: -76.5))
        timerMaskPath.addCurve(to: CGPoint(x: 76.5, y: 0), controlPoint1: CGPoint(x: 42.25, y: -76.5), controlPoint2: CGPoint(x: 76.5, y: -42.25))
        timerMaskPath.close()
        UIColor.black.setStroke()
        timerMaskPath.lineWidth = 27
        timerMaskPath.lineCapStyle = .round
        context.saveGState()
        context.setLineDash(phase: 4, lengths: [timerDash, 478])
        timerMaskPath.stroke()
        context.restoreGState()

        context.restoreGState()
        
        context.restoreGState()

    }

    public dynamic class func drawScanFailure(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 75, height: 75), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 75, height: 75), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 75, y: resizedFrame.height / 75)


        //// Color Declarations
        let failure = UIColor(red: 0.896, green: 0.200, blue: 0.200, alpha: 1.000)
        let failureCross = failure.withBrightness(0.5)

        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: 67, height: 67))
        failure.setFill()
        ovalPath.fill()
        failureCross.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()


        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: 37.45, y: 37.55)
        context.rotate(by: -45 * CGFloat.pi/180)

        let rectanglePath = UIBezierPath(rect: CGRect(x: -24.5, y: -3, width: 49, height: 6))
        failureCross.setFill()
        rectanglePath.fill()

        context.restoreGState()


        //// Rectangle 2 Drawing
        context.saveGState()
        context.translateBy(x: 37.45, y: 37.55)
        context.rotate(by: -135 * CGFloat.pi/180)

        let rectangle2Path = UIBezierPath(rect: CGRect(x: -24.5, y: -3, width: 49, height: 6))
        failureCross.setFill()
        rectangle2Path.fill()

        context.restoreGState()
        
        context.restoreGState()

    }

    public dynamic class func drawScanSuccess(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 75, height: 75), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 75, height: 75), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 75, y: resizedFrame.height / 75)


        //// Color Declarations
        let success = UIColor(red: 0.742, green: 0.927, blue: 0.079, alpha: 1.000)
        let successCheck = success.shadow(withLevel: 0.6)

        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: 67, height: 67))
        success.setFill()
        ovalPath.fill()
        successCheck.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()


        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: 42.97, y: 40.1)
        context.rotate(by: -60 * CGFloat.pi/180)

        let rectanglePath = UIBezierPath(roundedRect: CGRect(x: -21.56, y: -3, width: 43.11, height: 6), cornerRadius: 3)
        successCheck.setFill()
        rectanglePath.fill()

        context.restoreGState()


        //// Rectangle 2 Drawing
        context.saveGState()
        context.translateBy(x: 28.03, y: 51.14)
        context.rotate(by: -135 * CGFloat.pi/180)

        let rectangle2Path = UIBezierPath(roundedRect: CGRect(x: -9.78, y: -3, width: 19.55, height: 6), cornerRadius: 3)
        successCheck.setFill()
        rectangle2Path.fill()

        context.restoreGState()
        
        context.restoreGState()

    }

    public dynamic class func drawScanProcessing(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 75, height: 75), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 75, height: 75), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 75, y: resizedFrame.height / 75)


        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 4, y: 4, width: 67, height: 67))
        NoodlesStyleKit.timer1.setFill()
        ovalPath.fill()
        NoodlesStyleKit.timerBkg.setStroke()
        ovalPath.lineWidth = 1
        ovalPath.stroke()


        //// Rectangle 2 Drawing
        context.saveGState()
        context.translateBy(x: 24, y: 37)

        let rectangle2Path = UIBezierPath(rect: CGRect(x: -3.06, y: -3, width: 6.12, height: 6))
        NoodlesStyleKit.timerBkg.setFill()
        rectangle2Path.fill()

        context.restoreGState()


        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: 38, y: 37)

        let rectanglePath = UIBezierPath(rect: CGRect(x: -3.06, y: -3, width: 6.12, height: 6))
        NoodlesStyleKit.timerBkg.setFill()
        rectanglePath.fill()

        context.restoreGState()


        //// Rectangle 3 Drawing
        context.saveGState()
        context.translateBy(x: 51, y: 37)

        let rectangle3Path = UIBezierPath(rect: CGRect(x: -3.06, y: -3, width: 6.12, height: 6))
        NoodlesStyleKit.timerBkg.setFill()
        rectangle3Path.fill()

        context.restoreGState()
        
        context.restoreGState()

    }

    public dynamic class func drawNouille(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 40, height: 40), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 40, y: resizedFrame.height / 40)


        //// Color Declarations
        let principale = UIColor(red: 0.986, green: 0.777, blue: 0.000, alpha: 1.000)
        let color = principale.shadow(withLevel: 0.2)

        //// Rectangle 4 Drawing
        let rectangle4Path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 40, height: 40))
        NoodlesStyleKit.lighterYellow.setFill()
        rectangle4Path.fill()


        //// Group 2
        //// Group
        //// Rectangle 2 Drawing
        context.saveGState()
        context.translateBy(x: 10.58, y: 20.07)

        let rectangle2Path = UIBezierPath(rect: CGRect(x: -5.03, y: -10.49, width: 10.05, height: 20.98))
        NoodlesStyleKit.baseOrange.setFill()
        rectangle2Path.fill()

        context.restoreGState()


        //// Rectangle 3 Drawing
        context.saveGState()
        context.translateBy(x: 30.53, y: 20.14)

        let rectangle3Path = UIBezierPath(rect: CGRect(x: -5.03, y: -10.49, width: 10.05, height: 20.98))
        NoodlesStyleKit.baseOrange.setFill()
        rectangle3Path.fill()

        context.restoreGState()


        //// Oval 3 Drawing
        let oval3Path = UIBezierPath(ovalIn: CGRect(x: 5, y: 4, width: 10, height: 10))
        NoodlesStyleKit.lighterOrange.setFill()
        oval3Path.fill()


        //// Oval 4 Drawing
        let oval4Path = UIBezierPath(ovalIn: CGRect(x: 26, y: 25, width: 10, height: 10))
        NoodlesStyleKit.lighterOrange.setFill()
        oval4Path.fill()


        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: 20.44, y: 19.56)
        context.rotate(by: -45 * CGFloat.pi/180)

        let rectanglePath = UIBezierPath(rect: CGRect(x: -5, y: -14, width: 10, height: 28))
        NoodlesStyleKit.lighterOrange.setFill()
        rectanglePath.fill()

        context.restoreGState()


        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 5.75, y: 25.25, width: 10, height: 10))
        NoodlesStyleKit.baseOrange.setFill()
        ovalPath.fill()
        color.setStroke()
        ovalPath.lineWidth = 0.5
        ovalPath.stroke()


        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 25.75, y: 4.75, width: 10, height: 10))
        NoodlesStyleKit.baseOrange.setFill()
        oval2Path.fill()
        color.setStroke()
        oval2Path.lineWidth = 0.5
        oval2Path.stroke()


        //// Oval 5 Drawing
        let oval5Path = UIBezierPath(ovalIn: CGRect(x: 27.25, y: 6.25, width: 7, height: 7))
        color.setFill()
        oval5Path.fill()
        color.setStroke()
        oval5Path.lineWidth = 0.5
        oval5Path.stroke()


        //// Oval 6 Drawing
        let oval6Path = UIBezierPath(ovalIn: CGRect(x: 7.25, y: 26.75, width: 7, height: 7))
        color.setFill()
        oval6Path.fill()
        color.setStroke()
        oval6Path.lineWidth = 0.5
        oval6Path.stroke()






        //// Oval 7 Drawing
        let oval7Path = UIBezierPath()
        oval7Path.move(to: CGPoint(x: 7.21, y: 11.87))
        oval7Path.addCurve(to: CGPoint(x: 6, y: 9), controlPoint1: CGPoint(x: 6.46, y: 11.14), controlPoint2: CGPoint(x: 6, y: 10.12))
        oval7Path.addCurve(to: CGPoint(x: 10, y: 5), controlPoint1: CGPoint(x: 6, y: 6.79), controlPoint2: CGPoint(x: 7.79, y: 5))
        oval7Path.addCurve(to: CGPoint(x: 12.89, y: 6.23), controlPoint1: CGPoint(x: 11.14, y: 5), controlPoint2: CGPoint(x: 12.16, y: 5.47))
        NoodlesStyleKit.baseOrange.setStroke()
        oval7Path.lineWidth = 1
        oval7Path.lineCapStyle = .round
        oval7Path.stroke()


        //// Oval 8 Drawing
        context.saveGState()
        context.translateBy(x: 35, y: 34)
        context.rotate(by: -180 * CGFloat.pi/180)

        let oval8Path = UIBezierPath()
        oval8Path.move(to: CGPoint(x: 1.21, y: 6.87))
        oval8Path.addCurve(to: CGPoint(x: 0, y: 4), controlPoint1: CGPoint(x: 0.46, y: 6.14), controlPoint2: CGPoint(x: 0, y: 5.12))
        oval8Path.addCurve(to: CGPoint(x: 4, y: 0), controlPoint1: CGPoint(x: 0, y: 1.79), controlPoint2: CGPoint(x: 1.79, y: 0))
        oval8Path.addCurve(to: CGPoint(x: 6.89, y: 1.23), controlPoint1: CGPoint(x: 5.14, y: 0), controlPoint2: CGPoint(x: 6.16, y: 0.47))
        NoodlesStyleKit.baseOrange.setStroke()
        oval8Path.lineWidth = 1
        oval8Path.lineCapStyle = .round
        oval8Path.stroke()

        context.restoreGState()


        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 34.5, y: 15))
        bezierPath.addCurve(to: CGPoint(x: 34.5, y: 25), controlPoint1: CGPoint(x: 34.5, y: 25), controlPoint2: CGPoint(x: 34.5, y: 25))
        bezierPath.addLine(to: CGPoint(x: 34.5, y: 25))
        NoodlesStyleKit.lighterOrange.setStroke()
        bezierPath.lineWidth = 1
        bezierPath.lineCapStyle = .round
        bezierPath.stroke()


        //// Bezier 2 Drawing
        context.saveGState()
        context.translateBy(x: 16, y: 9.5)
        context.rotate(by: -45 * CGFloat.pi/180)

        let bezier2Path = UIBezierPath()
        bezier2Path.move(to: CGPoint(x: 0, y: 0))
        bezier2Path.addCurve(to: CGPoint(x: 0, y: 21.57), controlPoint1: CGPoint(x: 0, y: 21.57), controlPoint2: CGPoint(x: 0, y: 21.57))
        bezier2Path.addLine(to: CGPoint(x: 0, y: 21.57))
        NoodlesStyleKit.baseOrange.setStroke()
        bezier2Path.lineWidth = 1
        bezier2Path.lineCapStyle = .round
        bezier2Path.stroke()

        context.restoreGState()


        //// Bezier 3 Drawing
        context.saveGState()
        context.translateBy(x: 10, y: 15)
        context.rotate(by: -45 * CGFloat.pi/180)

        let bezier3Path = UIBezierPath()
        bezier3Path.move(to: CGPoint(x: 0, y: 0))
        bezier3Path.addCurve(to: CGPoint(x: 0, y: 21.92), controlPoint1: CGPoint(x: 0, y: 21.92), controlPoint2: CGPoint(x: 0, y: 21.92))
        bezier3Path.addLine(to: CGPoint(x: 0, y: 21.92))
        NoodlesStyleKit.baseOrange.setStroke()
        bezier3Path.lineWidth = 1
        bezier3Path.lineCapStyle = .round
        bezier3Path.stroke()

        context.restoreGState()


        //// Bezier 4 Drawing
        let bezier4Path = UIBezierPath()
        bezier4Path.move(to: CGPoint(x: 6.5, y: 15))
        bezier4Path.addCurve(to: CGPoint(x: 6.5, y: 25), controlPoint1: CGPoint(x: 6.5, y: 25), controlPoint2: CGPoint(x: 6.5, y: 25))
        bezier4Path.addLine(to: CGPoint(x: 6.5, y: 25))
        NoodlesStyleKit.lighterOrange.setStroke()
        bezier4Path.lineWidth = 1
        bezier4Path.lineCapStyle = .round
        bezier4Path.stroke()
        
        context.restoreGState()

    }

    public dynamic class func drawMealSizeIndicator(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 40, height: 40), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 40, y: resizedFrame.height / 40)


        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40))
        NoodlesStyleKit.darkerGreen.setFill()
        ovalPath.fill()


        //// Oval 2 Drawing
        let oval2Path = UIBezierPath(ovalIn: CGRect(x: 3, y: 3, width: 34, height: 34))
        NoodlesStyleKit.baseYellow.setFill()
        oval2Path.fill()
        
        context.restoreGState()

    }

    public dynamic class func drawMealSizeIndicatorSD(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40), resizing: ResizingBehavior = .aspectFit) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 40, height: 40), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 40, y: resizedFrame.height / 40)


        //// Oval Drawing
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 40, height: 40))
        NoodlesStyleKit.darkerGreen.setFill()
        ovalPath.fill()


        //// Oval 2 Drawing
        let oval2Path = UIBezierPath()
        oval2Path.move(to: CGPoint(x: 3, y: 20))
        oval2Path.addCurve(to: CGPoint(x: 20, y: 3), controlPoint1: CGPoint(x: 3, y: 10.61), controlPoint2: CGPoint(x: 10.61, y: 3))
        oval2Path.addCurve(to: CGPoint(x: 20, y: 20), controlPoint1: CGPoint(x: 20, y: 3), controlPoint2: CGPoint(x: 20, y: 10.61))
        NoodlesStyleKit.baseYellow.setFill()
        oval2Path.fill()
        
        context.restoreGState()

    }

    public dynamic class func drawRatingIndicator(frame targetFrame: CGRect = CGRect(x: 0, y: 0, width: 95, height: 20), resizing: ResizingBehavior = .aspectFit, rating: CGFloat = 0) {
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()!
        
        //// Resize to Target Frame
        context.saveGState()
        let resizedFrame: CGRect = resizing.apply(rect: CGRect(x: 0, y: 0, width: 95, height: 20), target: targetFrame)
        context.translateBy(x: resizedFrame.minX, y: resizedFrame.minY)
        context.scaleBy(x: resizedFrame.width / 95, y: resizedFrame.height / 20)



        //// Variable Declarations
        let ratingRatio: CGFloat = (5 - rating) / 5.0

        //// Star Drawing
        context.saveGState()
        context.setBlendMode(.colorBurn)

        let starPath = UIBezierPath()
        starPath.move(to: CGPoint(x: 9.5, y: 2))
        starPath.addLine(to: CGPoint(x: 12.67, y: 6.63))
        starPath.addLine(to: CGPoint(x: 18.06, y: 8.22))
        starPath.addLine(to: CGPoint(x: 14.64, y: 12.67))
        starPath.addLine(to: CGPoint(x: 14.79, y: 18.28))
        starPath.addLine(to: CGPoint(x: 9.5, y: 16.4))
        starPath.addLine(to: CGPoint(x: 4.21, y: 18.28))
        starPath.addLine(to: CGPoint(x: 4.36, y: 12.67))
        starPath.addLine(to: CGPoint(x: 0.94, y: 8.22))
        starPath.addLine(to: CGPoint(x: 6.33, y: 6.63))
        starPath.close()
        NoodlesStyleKit.lighterGreen.setFill()
        starPath.fill()

        context.restoreGState()


        //// Star 2 Drawing
        let star2Path = UIBezierPath()
        star2Path.move(to: CGPoint(x: 28.5, y: 2))
        star2Path.addLine(to: CGPoint(x: 31.67, y: 6.63))
        star2Path.addLine(to: CGPoint(x: 37.06, y: 8.22))
        star2Path.addLine(to: CGPoint(x: 33.64, y: 12.67))
        star2Path.addLine(to: CGPoint(x: 33.79, y: 18.28))
        star2Path.addLine(to: CGPoint(x: 28.5, y: 16.4))
        star2Path.addLine(to: CGPoint(x: 23.21, y: 18.28))
        star2Path.addLine(to: CGPoint(x: 23.36, y: 12.67))
        star2Path.addLine(to: CGPoint(x: 19.94, y: 8.22))
        star2Path.addLine(to: CGPoint(x: 25.33, y: 6.63))
        star2Path.close()
        NoodlesStyleKit.lighterGreen.setFill()
        star2Path.fill()


        //// Star 3 Drawing
        context.saveGState()
        context.setBlendMode(.colorBurn)

        let star3Path = UIBezierPath()
        star3Path.move(to: CGPoint(x: 47.5, y: 2))
        star3Path.addLine(to: CGPoint(x: 50.67, y: 6.63))
        star3Path.addLine(to: CGPoint(x: 56.06, y: 8.22))
        star3Path.addLine(to: CGPoint(x: 52.64, y: 12.67))
        star3Path.addLine(to: CGPoint(x: 52.79, y: 18.28))
        star3Path.addLine(to: CGPoint(x: 47.5, y: 16.4))
        star3Path.addLine(to: CGPoint(x: 42.21, y: 18.28))
        star3Path.addLine(to: CGPoint(x: 42.36, y: 12.67))
        star3Path.addLine(to: CGPoint(x: 38.94, y: 8.22))
        star3Path.addLine(to: CGPoint(x: 44.33, y: 6.63))
        star3Path.close()
        NoodlesStyleKit.lighterGreen.setFill()
        star3Path.fill()

        context.restoreGState()


        //// Star 4 Drawing
        context.saveGState()
        context.setBlendMode(.colorBurn)

        let star4Path = UIBezierPath()
        star4Path.move(to: CGPoint(x: 66.5, y: 2))
        star4Path.addLine(to: CGPoint(x: 69.67, y: 6.63))
        star4Path.addLine(to: CGPoint(x: 75.06, y: 8.22))
        star4Path.addLine(to: CGPoint(x: 71.64, y: 12.67))
        star4Path.addLine(to: CGPoint(x: 71.79, y: 18.28))
        star4Path.addLine(to: CGPoint(x: 66.5, y: 16.4))
        star4Path.addLine(to: CGPoint(x: 61.21, y: 18.28))
        star4Path.addLine(to: CGPoint(x: 61.36, y: 12.67))
        star4Path.addLine(to: CGPoint(x: 57.94, y: 8.22))
        star4Path.addLine(to: CGPoint(x: 63.33, y: 6.63))
        star4Path.close()
        NoodlesStyleKit.lighterGreen.setFill()
        star4Path.fill()

        context.restoreGState()


        //// Star 5 Drawing
        context.saveGState()
        context.setBlendMode(.colorBurn)

        let star5Path = UIBezierPath()
        star5Path.move(to: CGPoint(x: 85.5, y: 2))
        star5Path.addLine(to: CGPoint(x: 88.67, y: 6.63))
        star5Path.addLine(to: CGPoint(x: 94.06, y: 8.22))
        star5Path.addLine(to: CGPoint(x: 90.64, y: 12.67))
        star5Path.addLine(to: CGPoint(x: 90.79, y: 18.28))
        star5Path.addLine(to: CGPoint(x: 85.5, y: 16.4))
        star5Path.addLine(to: CGPoint(x: 80.21, y: 18.28))
        star5Path.addLine(to: CGPoint(x: 80.36, y: 12.67))
        star5Path.addLine(to: CGPoint(x: 76.94, y: 8.22))
        star5Path.addLine(to: CGPoint(x: 82.33, y: 6.63))
        star5Path.close()
        NoodlesStyleKit.lighterGreen.setFill()
        star5Path.fill()

        context.restoreGState()


        //// Rectangle Drawing
        context.saveGState()
        context.translateBy(x: 95, y: 0)
        context.scaleBy(x: ratingRatio, y: 1)

        context.saveGState()
        context.setBlendMode(.clear)

        let rectanglePath = UIBezierPath(rect: CGRect(x: -95, y: 0, width: 95, height: 20))
        UIColor.gray.setFill()
        rectanglePath.fill()

        context.restoreGState()

        context.restoreGState()
        
        context.restoreGState()

    }

    //// Generated Images

    public dynamic class func imageOfTimerAnimation(timerRatio: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 200, height: 200), false, 0)
            NoodlesStyleKit.drawTimerAnimation(timerRatio: timerRatio)

        let imageOfTimerAnimation = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfTimerAnimation
    }

    public dynamic class var imageOfScanFailure: UIImage {
        if Cache.imageOfScanFailure != nil {
            return Cache.imageOfScanFailure!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 75, height: 75), false, 0)
            NoodlesStyleKit.drawScanFailure()

        Cache.imageOfScanFailure = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfScanFailure!
    }

    public dynamic class var imageOfScanSuccess: UIImage {
        if Cache.imageOfScanSuccess != nil {
            return Cache.imageOfScanSuccess!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 75, height: 75), false, 0)
            NoodlesStyleKit.drawScanSuccess()

        Cache.imageOfScanSuccess = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfScanSuccess!
    }

    public dynamic class var imageOfScanProcessing: UIImage {
        if Cache.imageOfScanProcessing != nil {
            return Cache.imageOfScanProcessing!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 75, height: 75), false, 0)
            NoodlesStyleKit.drawScanProcessing()

        Cache.imageOfScanProcessing = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfScanProcessing!
    }

    public dynamic class var imageOfNouille: UIImage {
        if Cache.imageOfNouille != nil {
            return Cache.imageOfNouille!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 40, height: 40), false, 0)
            NoodlesStyleKit.drawNouille()

        Cache.imageOfNouille = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfNouille!
    }

    public dynamic class var imageOfMealSizeIndicator: UIImage {
        if Cache.imageOfMealSizeIndicator != nil {
            return Cache.imageOfMealSizeIndicator!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 40, height: 40), false, 0)
            NoodlesStyleKit.drawMealSizeIndicator()

        Cache.imageOfMealSizeIndicator = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfMealSizeIndicator!
    }

    public dynamic class var imageOfMealSizeIndicatorSD: UIImage {
        if Cache.imageOfMealSizeIndicatorSD != nil {
            return Cache.imageOfMealSizeIndicatorSD!
        }

        UIGraphicsBeginImageContextWithOptions(CGSize(width: 40, height: 40), false, 0)
            NoodlesStyleKit.drawMealSizeIndicatorSD()

        Cache.imageOfMealSizeIndicatorSD = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return Cache.imageOfMealSizeIndicatorSD!
    }

    public dynamic class func imageOfRatingIndicator(rating: CGFloat = 0) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 95, height: 20), false, 0)
            NoodlesStyleKit.drawRatingIndicator(rating: rating)

        let imageOfRatingIndicator = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return imageOfRatingIndicator
    }

    //// Customization Infrastructure

    @IBOutlet dynamic var scanFailureTargets: [AnyObject]! {
        get { return Cache.scanFailureTargets }
        set {
            Cache.scanFailureTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: NoodlesStyleKit.imageOfScanFailure)
            }
        }
    }

    @IBOutlet dynamic var scanSuccessTargets: [AnyObject]! {
        get { return Cache.scanSuccessTargets }
        set {
            Cache.scanSuccessTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setSelectedImage:"), with: NoodlesStyleKit.imageOfScanSuccess)
            }
        }
    }

    @IBOutlet dynamic var scanProcessingTargets: [AnyObject]! {
        get { return Cache.scanProcessingTargets }
        set {
            Cache.scanProcessingTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: NoodlesStyleKit.imageOfScanProcessing)
            }
        }
    }

    @IBOutlet dynamic var nouilleTargets: [AnyObject]! {
        get { return Cache.nouilleTargets }
        set {
            Cache.nouilleTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: NoodlesStyleKit.imageOfNouille)
            }
        }
    }

    @IBOutlet dynamic var mealSizeIndicatorTargets: [AnyObject]! {
        get { return Cache.mealSizeIndicatorTargets }
        set {
            Cache.mealSizeIndicatorTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setSelectedImage:"), with: NoodlesStyleKit.imageOfMealSizeIndicator)
            }
        }
    }

    @IBOutlet dynamic var mealSizeIndicatorSDTargets: [AnyObject]! {
        get { return Cache.mealSizeIndicatorSDTargets }
        set {
            Cache.mealSizeIndicatorSDTargets = newValue
            for target: AnyObject in newValue {
                let _ = target.perform(NSSelectorFromString("setImage:"), with: NoodlesStyleKit.imageOfMealSizeIndicatorSD)
            }
        }
    }




    @objc public enum ResizingBehavior: Int {
        case aspectFit /// The content is proportionally resized to fit into the target rectangle.
        case aspectFill /// The content is proportionally resized to completely fill the target rectangle.
        case stretch /// The content is stretched to match the entire target rectangle.
        case center /// The content is centered in the target rectangle, but it is NOT resized.

        public func apply(rect: CGRect, target: CGRect) -> CGRect {
            if rect == target || target == CGRect.zero {
                return rect
            }

            var scales = CGSize.zero
            scales.width = abs(target.width / rect.width)
            scales.height = abs(target.height / rect.height)

            switch self {
                case .aspectFit:
                    scales.width = min(scales.width, scales.height)
                    scales.height = scales.width
                case .aspectFill:
                    scales.width = max(scales.width, scales.height)
                    scales.height = scales.width
                case .stretch:
                    break
                case .center:
                    scales.width = 1
                    scales.height = 1
            }

            var result = rect.standardized
            result.size.width *= scales.width
            result.size.height *= scales.height
            result.origin.x = target.minX + (target.width - result.width) / 2
            result.origin.y = target.minY + (target.height - result.height) / 2
            return result
        }
    }
}



extension UIColor {
    func withHue(_ newHue: CGFloat) -> UIColor {
        var saturation: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(nil, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: newHue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    func withSaturation(_ newSaturation: CGFloat) -> UIColor {
        var hue: CGFloat = 1, brightness: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(&hue, saturation: nil, brightness: &brightness, alpha: &alpha)
        return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
    }
    func withBrightness(_ newBrightness: CGFloat) -> UIColor {
        var hue: CGFloat = 1, saturation: CGFloat = 1, alpha: CGFloat = 1
        self.getHue(&hue, saturation: &saturation, brightness: nil, alpha: &alpha)
        return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
    }
    func withAlpha(_ newAlpha: CGFloat) -> UIColor {
        var hue: CGFloat = 1, saturation: CGFloat = 1, brightness: CGFloat = 1
        self.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: nil)
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: newAlpha)
    }
    func highlight(withLevel highlight: CGFloat) -> UIColor {
        var red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red * (1-highlight) + highlight, green: green * (1-highlight) + highlight, blue: blue * (1-highlight) + highlight, alpha: alpha * (1-highlight) + highlight)
    }
    func shadow(withLevel shadow: CGFloat) -> UIColor {
        var red: CGFloat = 1, green: CGFloat = 1, blue: CGFloat = 1, alpha: CGFloat = 1
        self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return UIColor(red: red * (1-shadow), green: green * (1-shadow), blue: blue * (1-shadow), alpha: alpha * (1-shadow) + shadow)
    }
}
