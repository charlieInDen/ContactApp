//
//  NavigationBarButtonItem.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

class NavigationBarButtonItem: UIBarButtonItem {
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override init() {
        super.init()
        setUp()
    }
    
    /**
     This function is used to set barbuttonItem with default values
     like color, width etc.
     */
    private func setUp() {
        self.tintColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
        // Default width is set to 50.0px
        self.width = 50.0
        self.style = .plain
    }
}
