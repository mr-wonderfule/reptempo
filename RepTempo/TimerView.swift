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
    let circleStartAngle = CGFloat(0.01 * M_PI/180);
    let circleEndAngle = CGFloat(0.0);
    let circleRect = CGRectMake(0, 85, 320, 162);
    
    let drawingAnimation  = CABasicAnimation(keyPath: "strokeEnd");
    
    let customGreen = UIColor(red: CGFloat(63/255), green: CGFloat(178/255), blue: CGFloat(17/255), alpha: 1.0);
    
    
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
        super.frame = self.frame;
    }

    func setDuration(totalTime: CFTimeInterval) {
        self.drawingAnimation.duration = totalTime;
    }
    
    func setup() {
        
        self.frame = self.circleRect;
        self.hidden = true;

        //self.circle.path = UIBezierPath(roundedRect: CGRectMake(0, 0, 2.0 * self.radius, 2.0 * self.radius), cornerRadius: self.radius).CGPath;
        
        //self.circle.position = CGPointMake(CGRectGetMidX(self.frame) - self.radius, CGRectGetMidY(self.frame) - self.radius);
        
        self.circleLine.fillColor = UIColor.clearColor().CGColor;
        self.circleLine.strokeColor = self.customGreen.CGColor;
        self.circleLine.lineWidth = 10.0;
        //self.circleLine.lineCap = kCALineCapRound;
        
        //self.circleLine.lineWidth = self.radius / 8.5 * 0.6;
        
        let centerPoint = CGPointMake(CGRectGetMidX(circleRect), CGRectGetMidY(circleRect));
        let radius      = CGRectGetHeight(circleRect)/2 - self.circleLine.lineWidth;
        
        self.circlePath.addArcWithCenter(centerPoint, radius: radius, startAngle: self.circleStartAngle, endAngle: self.circleEndAngle, clockwise: true);
        
        self.circleLine.path = self.circlePath.CGPath;

        
        self.layer.addSublayer(self.circleLine);
        
        self.drawingAnimation.repeatCount = 1.0;
        self.drawingAnimation.fromValue = 0.0;
        self.drawingAnimation.toValue = 1.0;
        
        self.drawingAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut);

        
    }
    
    func start(){
        
        self.circleLine.addAnimation(self.drawingAnimation, forKey: "drawCircleAnimation");
    }
    
    func reset(){
        
        self.circleLine.removeAnimationForKey("drawCircleAnimation");
    }
    
    func pause(){
        
        let pausedTime : CFTimeInterval = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil);
        
        self.drawingAnimation.speed =  0.0;
        self.drawingAnimation.timeOffset = pausedTime;
    }
    
    func resume(){
        
        let pausedTime : CFTimeInterval = self.drawingAnimation.timeOffset;
        
        self.drawingAnimation.speed = 1.0;
        self.drawingAnimation.timeOffset = 0.0;
        self.drawingAnimation.beginTime = 0.0;
        
        let timeSincePause : CFTimeInterval = self.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime;
        
        self.drawingAnimation.beginTime = timeSincePause;
    }
    
    // Implements CAAnimation delegate method
    override func animationDidStop(anim: CAAnimation!, finished flag: Bool) {
        // TODO
        
        if anim == self.layer.animationForKey("drawCircleAnimation") {
            
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