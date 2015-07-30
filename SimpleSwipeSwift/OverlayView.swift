//
//  OverlayView.swift
//  SimpleSwipeSwift
//
//  Created by Yan Yu on 6/10/15.
//  Copyright © 2015 Yan Yu. All rights reserved.
//

import UIKit

enum GGOverlayViewMode: Int {
    case GGOverlatViewModeUninitialized
    case GGOverlayViewModeLeft
    case GGOverlayViewModeRight
}

class OverlayView: UIView {
    
    var mode: GGOverlayViewMode = GGOverlayViewMode.GGOverlatViewModeUninitialized
    var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        let image = UIImage(named: "noButton")
        imageView = UIImageView(image: image)
        self.addSubview(imageView!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setMode(inMode: GGOverlayViewMode) -> Void {
        
        guard let imageViewValidated: UIImageView = imageView else {
            print("Invalid imageview, everything is wrong, bail out now")
            return
        }
        
        if (mode != inMode)
        {
            mode = inMode
            
            if(mode == .GGOverlayViewModeLeft) {
                imageViewValidated.image = UIImage(named: "noButton")
            } else {
                imageViewValidated.image = UIImage(named: "yesButton")
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageViewValidated: UIImageView = imageView! else {
            print("Invalid imageview, everything is wrong, bail out now")
            return
        }
        
        imageViewValidated.frame = CGRectMake(50, 50, 100, 100)
    }
    
//    override func drawRect(rect: CGRect) {
//        // Override this if custom drawing is needed
//    }
}