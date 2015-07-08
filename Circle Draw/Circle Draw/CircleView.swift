//
//  CircleView.swift
//  Circle Draw
//
//  Created by Leon Baird on 07/07/2015.
//  Copyright (c) 2015 Leon Baird. All rights reserved.
//

import UIKit

class CircleView: UIView {
    
    var position:CGPoint!
    var diameter:CGFloat =
        UIDevice.currentDevice().userInterfaceIdiom == .Phone
            ? 100.0 : 200.0
    var color = UIColor.blueColor()
    let shadowColor = UIColor.blackColor().CGColor
    
    // MARK: - Drawing code

    override func drawRect(rect: CGRect) {
        // Drawing code
        if position == nil {
            position = CGPoint(x: bounds.width/2.0, y: bounds.height/2.0)
            userInteractionEnabled = true
            multipleTouchEnabled = true
        }
        
        let ctx = UIGraphicsGetCurrentContext()
        color.setFill()
        CGContextSetShadowWithColor(ctx, CGSize(width: 3.0, height: 3.0), 5.0, shadowColor)
        let circleRect = CGRect(
            x: position.x - diameter / 2.0,
            y: position.y - diameter / 2.0,
            width: diameter,
            height: diameter
        )
        CGContextFillEllipseInRect(ctx, circleRect)
    }
    
    // MARK: - Responder Methods
    
    var touchesBeingTracked = Set<UITouch>()
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if (touchesBeingTracked.count <= 1 && touches.count == 1)
            || (touchesBeingTracked.count == 0 && touches.count <= 2 ) {
            touchesBeingTracked.unionInPlace(touches as! Set<UITouch>)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touchesBeingTracked.count == 1 {
            // Move circle
            position = touchesBeingTracked.first!.locationInView(self)
        } else {
            // pinch
            let allTouches = Array<UITouch>(touchesBeingTracked)
            let fingerPos1 = allTouches[0].locationInView(self)
            let fingerPos2 = allTouches[1].locationInView(self)
            
            let diffX = fingerPos1.x - fingerPos2.x
            let diffY = fingerPos1.y - fingerPos2.y
            
            diameter = sqrt(diffX*diffX + diffY*diffY)
            position.x = fingerPos1.x - diffX/2.0
            position.y = fingerPos1.y - diffY/2.0
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        touchesBeingTracked.subtractInPlace(touches as! Set<UITouch>)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        touchesEnded(touches, withEvent: event)
    }
    

}











