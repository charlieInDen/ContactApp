//
//  ViewController.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {

    private let contactsVC: ContactsListViewController = ContactsListViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set nav bar to be solid
        self.navigationBar.isTranslucent = false
        
        // set initial root vc
        self.pushViewController(self.contactsVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

