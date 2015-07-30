//
//  ViewController.swift
//  SimpleSwipeSwift
//
//  Created by Yan Yu on 6/10/15.
//  Copyright © 2015 Yan Yu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let background = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(background)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

