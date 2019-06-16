//
//  ContactTableViewCell.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit
import PureLayout

class ContactTableViewCell: UITableViewCell {

    public let contactImageView   : UIImageView = UIImageView()
    public let nameTitleLabel     : UILabel     = UILabel()
    public let favoriteImageView  : UIImageView = UIImageView()
    
    private let contactImageWidth   : CGFloat = 40.0
    private let favoriteImageWidth  : CGFloat = 18.0
    private let favoriteImage       : UIImage = #imageLiteral(resourceName: "homeFavourite")
    private let favoriteImageTint   : UIColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contactImageView.contentMode = .scaleAspectFit
        self.contactImageView.clipsToBounds = true
        self.contactImageView.layer.cornerRadius = self.contactImageWidth / 2.0
        
        self.favoriteImageView.contentMode = .scaleAspectFit
        self.favoriteImageView.image       = self.favoriteImage
        self.favoriteImageView.tintColor   = self.favoriteImageTint
        self.favoriteImageView.isHidden    = true
        
        self.contentView.addSubview(self.contactImageView)
        self.contentView.addSubview(self.nameTitleLabel)
        self.contentView.addSubview(self.favoriteImageView)
        
        self.nameTitleLabel.numberOfLines = 2
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contactImageView.autoSetDimensions(to: CGSize(width: self.contactImageWidth, height: self.contactImageWidth))
        self.contactImageView.autoPinEdge(.top, to: .top, of: self.contentView, withOffset: 12.0)
        self.contactImageView.autoPinEdge(.left, to: .left, of: self.contentView, withOffset: 16.0)
        
        self.nameTitleLabel.autoPinEdge(.left, to: .right, of: self.contactImageView, withOffset: 16.0)
        self.nameTitleLabel.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: -30.0)
        self.nameTitleLabel.autoPinEdge(toSuperviewEdge: .top)
        self.nameTitleLabel.autoPinEdge(toSuperviewEdge: .bottom)
        self.nameTitleLabel.font = UIFont.systemFont(ofSize: 14.0, weight: UIFont.Weight.bold)
        
        self.favoriteImageView.autoPinEdge(.right, to: .right, of: self.contentView, withOffset: -32.0)
        self.favoriteImageView.autoPinEdge(.top, to: .top, of: self.contentView, withOffset: 23.0)
        self.favoriteImageView.autoSetDimensions(to: CGSize(width: self.favoriteImageWidth, height: self.favoriteImageWidth))
        
        self.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 16.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.favoriteImageView.isHidden = true
        self.nameTitleLabel.text        = nil
    }

}
