//
//  NavigationController.swift
//  ASiC Midterm-Exam Terry
//
//  Created by 黃偉勛 Terry on 2019/3/29.
//  Copyright © 2019 Terry. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override var childForStatusBarStyle: UIViewController? {
        
        return self.topViewController
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }

}
