//
//  ContactDetailIconButton.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

class ContactDetailIconButton: UIButton {

    public  let iconImageView : UIImageView = UIImageView()
    
    override var isEnabled: Bool {
        didSet {
            super.isEnabled = self.isEnabled
            self.iconImageView.alpha = self.isEnabled ? 1.0 : 0.6
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = frame.size.width / 2.0
        
        self.addSubview(self.iconImageView)
        self.iconImageView.isUserInteractionEnabled = false
        let inset: CGFloat = 0.0
        self.iconImageView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset))
    }

}
