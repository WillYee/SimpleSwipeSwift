//
//  Globals.swift
//  SimpleSwipeSwift
//
//  Created by Yan Yu on 6/10/15.
//  Copyright © 2015 Yan Yu. All rights reserved.
//

import UIKit

struct Globals {
    static let ACTION_MARGIN:     CGFloat = 120               // distance from center where the action applies. Higher = swipe further in order for the action to be called
    static let SCALE_STRENGTH:    CGFloat = 4                 // how quickly the card shrinks. Higher = slower shrinking
    static let SCALE_MAX:         CGFloat = 0.93              // upper bar for how much the card shrinks. Higher = shrinks less
    static let ROTATION_MAX:      CGFloat = 1                 // the maximum rotation allowed in radians.  Higher = card can keep rotating longer
    static let ROTATION_STRENGTH: CGFloat = 320               // strength of rotation. Higher = weaker rotation
    static let ROTATION_ANGLE:    CGFloat = CGFloat(M_PI / 8) // Higher = stronger rotation angle
    static let MAX_BUFFER_SIZE:   Int     = 2                 // max number of cards loaded at any given time, must be greater than 1
    static let CARD_HEIGHT:       CGFloat = 386               // height of the draggable card
    static let CARD_WDITH:        CGFloat = 290               // width of the draggable card
    
}
