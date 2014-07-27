//
//  TimerView.swift
//  RepTempo
//
//  Created by Nathan Trans on 7/15/14.
//  Copyright (c) 2014 Nathan Trans. All rights reserved.
//

import UIKit

class TimerView : UIView {
    
    var currentTime : Float = 0.0;
    let radius : CGFloat = 80;
    let customGreen = UIColor(red: CGFloat(63/255), green: CGFloat(178/255), blue: CGFloat(17/255), alpha: 1.0);
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder);
    }
    
    init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    func update(atTime time: Float){
        currentTime = time;
        self.setNeedsDisplay();
    }
    
    func degreesToRadians( degrees: Double) -> CGFloat {
        return CGFloat(degrees / 180.0 * M_PI);
    }
    
    override func drawRect(rect: CGRect) {
        
        let midX = CGRectGetMidX(self.frame);
        let midY = CGRectGetMidY(self.frame);
        println("(x, y) = (\(midX), \(midY))");
        
        let minX = CGRectGetMinX(self.frame);
        let minY = CGRectGetMinY(self.frame);
        println("(x, y) = (\(minX), \(minY))");
        
        let maxX = CGRectGetMaxX(self.frame);
        let maxY = CGRectGetMaxY(self.frame);
        println("(x, y) = (\(maxX), \(maxY))");
        
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
}