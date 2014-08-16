//
//  TimerView.swift
//  RepTempo
//
//  Created by Nathan Trans on 7/15/14.
//  Copyright (c) 2014 Nathan Trans. All rights reserved.
//

import QuartzCore
import UIKit

class TimerView : UIView {
    
    let circleLine = CAShapeLayer();
    let circlePath = UIBezierPath();
    let circleStartAngle = CGFloat(270.01 * M_PI/180);
    let circleEndAngle = CGFloat(270.00 * M_PI / 180);
    let circleRect = CGRectMake(0, 85, 320, 162);
    let circleSpeed : Float = 1.0 // + 1/60.0;
    
    let drawingAnimation  = CABasicAnimation(keyPath: "strokeEnd");
    
    let customGreen = UIColor(red: CGFloat(63.0/255.0), green: CGFloat(178.0/255.0), blue: CGFloat(17.0/255.0), alpha: 1.0);
    
    
    override init() {
        super.init();
        self.setup();
    }

    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder);
        self.setup();
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        self.setup();
    }

    func setDuration(totalTime: CFTimeInterval) {
        self.drawingAnimation.duration = totalTime;
    }
    
    func setup() {
        
        self.hidden = true;

        //self.circle.path = UIBezierPath(roundedRect: CGRectMake(0, 0, 2.0 * self.radius, 2.0 * self.radius), cornerRadius: self.radius).CGPath;
        
        //self.circle.position = CGPointMake(CGRectGetMidX(self.frame) - self.radius, CGRectGetMidY(self.frame) - self.radius);
        
        self.circleLine.fillColor = UIColor.clearColor().CGColor;
        self.circleLine.strokeColor = self.customGreen.CGColor;
        self.circleLine.lineWidth = 6.0;
        self.circleLine.lineCap = kCALineCapRound;
        
        //self.circleLine.lineWidth = self.radius / 8.5 * 0.6;
        let radius      = CGRectGetHeight(self.circleRect)/2 - self.circleLine.lineWidth*2;
        let centerPoint = CGPointMake(CGRectGetMidX(self.circleRect), CGRectGetMidY(self.circleRect) - radius - self.circleLine.lineWidth);
        //println("(x,y) = (\(centerPoint.x), \(centerPoint.y))");
        
        self.circlePath.addArcWithCenter(centerPoint,
            radius: radius,
            startAngle: self.circleStartAngle,
            endAngle:   self.circleEndAngle, clockwise: true);
        
        self.circleLine.path = self.circlePath.CGPath;

        
        self.layer.addSublayer(self.circleLine);
        
        self.drawingAnimation.duration = 10.0;
        self.drawingAnimation.repeatCount = 1.0;
        self.drawingAnimation.fromValue = 0.0;
        self.drawingAnimation.toValue = 1.0;
        
        self.drawingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut);

        self.drawingAnimation.speed = self.circleSpeed;

        self.circleLine.fillMode = kCAFillModeForwards;
        /*
        var timerFace = UIBezierPath(ovalInRect: CGRectMake(centerPoint.x - (radius/2), centerPoint.y - (radius/2), radius, radius));
        
        UIColor.grayColor().set();
        timerFace.lineWidth = self.circleLine.lineWidth;
        timerFace.stroke();
        */
    }
    
    func start(){
        
        self.circleLine.addAnimation(self.drawingAnimation, forKey: "drawCircleAnimation");
        
        /*
        let copy = drawingAnimation.copy() as CABasicAnimation;
        
        if !copy.fromValue {
            copy.fromValue = self.circleLine.valueForKeyPath(copy.keyPath);
        }
        
        self.circleLine.addAnimation(copy, forKey: copy.keyPath);
        self.setValue(copy.toValue, forKeyPath: copy.keyPath);
        */
    }
    
    func reset(){
        
        self.circleLine.removeAllAnimations(); //removeAnimationForKey("drawCircleAnimation");
        
        self.drawingAnimation.beginTime = 0.0;
        self.drawingAnimation.speed = self.circleSpeed;
        self.drawingAnimation.timeOffset = 0.0;
        
        self.update();
    }
    
    func pause(){
        
        //let rootView = self.superview as? ViewController;
        let pausedTime : CFTimeInterval = self.circleLine.convertTime(CACurrentMediaTime(), fromLayer: nil);
        
        self.drawingAnimation.speed =  0.0;
        self.update();
        
        self.drawingAnimation.timeOffset = pausedTime;
        
    }
    
    func resume(){
        
        let pausedTime : CFTimeInterval = self.drawingAnimation.timeOffset;
        
        self.drawingAnimation.speed = self.circleSpeed;
        self.drawingAnimation.timeOffset = 0.0;
        self.drawingAnimation.beginTime = 0.0;
        
        let timeSincePause : CFTimeInterval = self.circleLine.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime;
        
        self.drawingAnimation.beginTime = timeSincePause;
        
        self.update();
    }
    
    func update() {
        self.circleLine.removeAllAnimations();
        self.start();
    }
    
    // Implements CAAnimation delegate method
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        // TODO
        
        if !flag {
            return;
        }
        
        if anim === self.circleLine.animationForKey("drawCircleAnimation") {
        
            //self.reset();
            let rootView = self.superview?.valueForKey("rootView") as? ViewController;
            rootView?.stopTimer(self);
        }
    }
    
    
    
    /*
    func degreesToRadians( degrees: Double) -> CGFloat {
        return CGFloat(degrees / 180.0 * M_PI);
    }
    
    override func drawRect(rect: CGRect) {
        
        let midX = CGRectGetMidX(self.frame);
        let midY = CGRectGetMidY(self.frame);
//        println("(x, y) = (\(midX), \(midY))");
        
        let minX = CGRectGetMinX(self.frame);
        let minY = CGRectGetMinY(self.frame);
//        println("(x, y) = (\(minX), \(minY))");
        
        let maxX = CGRectGetMaxX(self.frame);
        let maxY = CGRectGetMaxY(self.frame);
//        println("(x, y) = (\(maxX), \(maxY))");
        
        let pointerScale = radius / 8.5;

        var timerFace = UIBezierPath(ovalInRect: CGRectMake(midX - (radius/2), midY - (radius + 8), radius, radius));
        
        UIColor.grayColor().set();
        timerFace.lineWidth = pointerScale * 0.6;
        timerFace.stroke();
        
        
        var currentAngle : CGFloat = degreesToRadians(270 + Double(currentTime/360));
        
        var runningTimerArc = UIBezierPath(arcCenter: CGPointMake(midX, midY), radius: radius, startAngle: 270, endAngle: currentAngle, clockwise: true);
        
        UIColor.greenColor().set();
        runningTimerArc.lineWidth = pointerScale * 0.6;
        runningTimerArc.stroke();
        
    }
    */
    
}