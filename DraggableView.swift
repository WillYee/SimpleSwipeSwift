//
//  DraggableView.swift
//  SimpleSwipeSwift
//
//  Created by Yan Yu on 6/10/15.
//  Copyright © 2015 Yan Yu. All rights reserved.
//

import UIKit


protocol DraggableViewDelegate {
    func cardSwipedLeft(cardview: UIView) -> Void
    func cardSwipedRight(cardView: UIView) -> Void
}

class DraggableView: UIView {
    
    //delegate is instance of ViewController
    var delegate: DraggableViewDelegate?              = nil
    var panGestureRecognizer: UIPanGestureRecognizer? = nil
    var overlayView: OverlayView?                     = nil
    var information: UILabel?                         = nil

    var xFromCenter: CGFloat   = 0
    var yFromCenter: CGFloat   = 0
    var originalPoint: CGPoint = CGPoint(x: 0.0, y: 0.0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "beingDragged:")
        guard let panGestureRecognizerUnwrapped: UIPanGestureRecognizer = panGestureRecognizer! else { return }
        self.addGestureRecognizer(panGestureRecognizerUnwrapped)
        
        overlayView = OverlayView(frame: CGRectMake(self.frame.width/2 - 100, 0, 100, 100))
        
        guard let overlayViewValidated = overlayView else {
            print("OverlayView construction failed")
            return
        }
        
        overlayViewValidated.alpha = 0
        self.addSubview(overlayViewValidated)
        
        // placeholder stuff, replace with card-specific information
        self.information = UILabel(frame: CGRectMake(0, 50, self.frame.width, 100))
        self.backgroundColor = UIColor.whiteColor()
        
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // called when you move your finger across the screen.
    // called many times a second
    func beingDragged(gestureRecognizer: UIPanGestureRecognizer) -> Void {
        
        // This extracts the coordinate information from your swipe movement (i.e. How much did you move?)
        xFromCenter = gestureRecognizer.translationInView(self).x
        yFromCenter = gestureRecognizer.translationInView(self).y
        
        switch(gestureRecognizer.state) {
            // Just started swiping
        case UIGestureRecognizerState.Began:
            originalPoint = self.center
            break
        case UIGestureRecognizerState.Changed:
            // dictates rotation (see ROTATION_MAX and ROTATION_STRENGTH for details)
            let rotationStrength = min(xFromCenter / Globals.ROTATION_STRENGTH, Globals.ROTATION_MAX)
            
            // degree change in radians
            let rotationAngle = Globals.ROTATION_ANGLE * rotationStrength
            
            // amount the height changes when you move the card up to a certain point
            let scale = max(1 - fabs(rotationStrength) / Globals.SCALE_STRENGTH, Globals.SCALE_MAX)
            
            // move the object's center by center + gesture coordinate
            self.center = CGPointMake(self.originalPoint.x + xFromCenter, self.originalPoint.y + yFromCenter)
            
            // rotate by certain amount
            let transform: CGAffineTransform = CGAffineTransformMakeRotation(rotationAngle)
            
            // scale by certain amount
            let scaleTransform: CGAffineTransform = CGAffineTransformScale(transform, scale, scale)
            
            // apply transform
            self.transform = scaleTransform
            self.updateOverlay(xFromCenter)
            break
        case UIGestureRecognizerState.Ended:
            self.afterSwipeAction()
            break
        case UIGestureRecognizerState.Possible:break;
        case UIGestureRecognizerState.Cancelled:break;
        case UIGestureRecognizerState.Failed:break;
        };
        
    }
    
    private func setupView() -> Void {
        self.layer.cornerRadius = 10
        self.layer.shadowRadius = 3
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSizeMake(1, 1)
        
    }
    
    private func updateOverlay(distance: CGFloat) -> Void {
        
        guard let overlayViewValidated: OverlayView = overlayView else {
            print("unable to validate overlayview")
            return
        }
        
        if (distance > 0) {
            overlayViewValidated.setMode(GGOverlayViewMode.GGOverlayViewModeRight)
        }
        else {
            overlayViewValidated.setMode(GGOverlayViewMode.GGOverlayViewModeLeft)
        }
        
        overlayViewValidated.alpha = min(abs(distance)/100.0, 0.4)
    }
    
    private func afterSwipeAction() -> Void {
        if (xFromCenter > Globals.ACTION_MARGIN) {
            self.rightAction()
        } else if (xFromCenter < -Globals.ACTION_MARGIN) {
            self.leftAction()
        } else {
            UIView.animateWithDuration(0.3, animations: {
                
                guard let overlayViewValidated = self.overlayView else {
                    print("overlayView is nil, bailing out")
                    return
                }
                
                self.center = self.originalPoint
                self.transform = CGAffineTransformMakeRotation(0)
                overlayViewValidated.alpha = 0
            })
        }
    }
    
    private func rightAction() -> Void {
        
        guard let delegateValidated: DraggableViewDelegate = delegate else {
            print("Delegate is nil, bail out")
            return
        }
        
        let finishPoint = CGPointMake(500, 2*yFromCenter + self.originalPoint.y);
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
            },
            completion: {
                (value: Bool) in
                self.removeFromSuperview()
            }
        )
        
        delegateValidated.cardSwipedRight(self)
        print("YES")
        
    }
    
    private func leftAction() -> Void {
        guard let delegateValidated: DraggableViewDelegate = delegate else {
            print("Delegate is nil, bail out")
            return
        }
        
        let finishPoint = CGPointMake(-500, 2*yFromCenter + self.originalPoint.y);
        UIView.animateWithDuration(0.3,
            animations: {
                self.center = finishPoint
            },
            completion: {
                (value: Bool) in
                self.removeFromSuperview()
        })
        
        delegateValidated.cardSwipedLeft(self)
        print("NO")
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
//    override func drawRect(rect: CGRect) {
//        // Drawing code
//    }
}