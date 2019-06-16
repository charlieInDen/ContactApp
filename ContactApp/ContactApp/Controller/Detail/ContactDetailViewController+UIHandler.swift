//
//  ContactDetailViewController+UIHandler.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

extension ContactDetailViewController { //Setup UI
    func setupHeaderUI() {
        // set navbar tint color
        self.navigationController?.navigationBar.tintColor = self.lightGreen
        
        self.view.backgroundColor = .clear
        // remove nav bar separator
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.view.addSubview(self.headerView)
        self.headerView.autoPinEdge(toSuperviewEdge: .left)
        self.headerView.autoPinEdge(toSuperviewEdge: .right)
        self.headerView.autoPinEdge(toSuperviewEdge: .top)
        
        self.headerView.backgroundColor = .white
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.gradient.colors = [UIColor.white.cgColor, lightGreen.cgColor]
        self.gradient.locations = [0.06, 1.0]
        self.gradient.opacity = 0.55
        self.headerView.layer.insertSublayer(self.gradient, at: 0)
    }
    func setupProfileContainerUI() {
        self.view.addSubview(self.profileImageContainer)
        self.profileImageContainer.backgroundColor = .white
        self.profileImageContainer.autoPinEdge(.top, to: .top, of: self.headerView, withOffset: 17.0)
        self.profileImageContainer.autoAlignAxis(toSuperviewAxis: .vertical)
        let imageContainerWidth: CGFloat = 126.0
        self.profileImageContainer.autoSetDimensions(to: CGSize(width: imageContainerWidth, height: imageContainerWidth))
        self.profileImageContainer.clipsToBounds = true
        self.profileImageContainer.layer.cornerRadius = imageContainerWidth / 2.0
        
        self.profileImageContainer.addSubview(self.profileImageView)
        self.profileImageView.image = contact.image()
        
        self.profileImageView.contentMode = .scaleAspectFit
        self.profileImageView.autoAlignAxis(toSuperviewAxis: .horizontal)
        self.profileImageView.autoAlignAxis(toSuperviewAxis: .vertical)
        let imageWidth = imageContainerWidth - 6.0
        self.profileImageView.autoSetDimensions(to: CGSize(width: imageWidth, height: imageWidth))
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.cornerRadius = imageWidth / 2.0
        
        self.headerView.addSubview(self.nameLabel)
        self.nameLabel.autoPinEdge(.top, to: .bottom, of: self.profileImageContainer, withOffset: 8.0)
        self.nameLabel.autoPinEdge(toSuperviewMargin: .left)
        self.nameLabel.autoPinEdge(toSuperviewMargin: .right)
        self.nameLabel.textAlignment = .center
        self.nameLabel.autoSetDimension(.height, toSize: 24.0)
        self.nameLabel.font = UIFont.systemFont(ofSize: 20.0, weight: .bold)
        self.nameLabel.textColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
        
        
    }
    func setupContainerConstraints() {
        // icon params
        let iconWidth: CGFloat        = 44.0
        let iconSpacing: CGFloat      = 36.0
        let iconSideMargin: CGFloat   = (UIScreen.main.bounds.width - (3.0 * iconSpacing) - (4.0 * iconWidth)) / 2.0
        // constraint icons
        self.headerView.addSubview(self.messageButton)
        self.messageButton.autoPinEdge(.top, to: .bottom, of: self.nameLabel, withOffset: 20.0)
        self.messageButton.autoPinEdge(.left, to: .left, of: self.headerView, withOffset: iconSideMargin)
        self.messageButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.messageButton.iconImageView.image = UIImage(named: "messageIcon")
        
        self.headerView.addSubview(self.callButton)
        self.callButton.autoPinEdge(.top, to: .bottom, of: self.nameLabel, withOffset: 20.0)
        self.callButton.autoPinEdge(.left, to: .right, of: self.messageButton, withOffset: iconSpacing)
        self.callButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.callButton.iconImageView.image = UIImage(named: "phone")
        
        self.headerView.addSubview(self.emailButton)
        self.emailButton.autoPinEdge(.top, to: .bottom, of: self.nameLabel, withOffset: 20.0)
        self.emailButton.autoPinEdge(.left, to: .right, of: self.callButton, withOffset: iconSpacing)
        self.emailButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.emailButton.iconImageView.image = UIImage(named: "mail")
        
        self.headerView.addSubview(self.favoriteButton)
        self.favoriteButton.autoPinEdge(.top, to: .bottom, of: self.nameLabel, withOffset: 20.0)
        self.favoriteButton.autoPinEdge(.left, to: .right, of: self.emailButton, withOffset: iconSpacing)
        self.favoriteButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.updateFavoriteButton()
        
        self.view.addSubview(self.cameraButton)
        self.cameraButton.alpha = 0.0
        self.cameraButton.autoSetDimensions(to: CGSize(width: iconWidth, height: iconWidth))
        self.cameraButton.iconImageView.image = UIImage(named: "camera")
        self.cameraButton.iconImageView.tintColor = self.lightGreen
        self.cameraButton.backgroundColor = .white
        self.cameraButton.autoPinEdge(.bottom, to: .bottom, of: self.profileImageContainer)
        self.cameraButton.autoPinEdge(.right, to: .right, of: self.profileImageContainer)
        self.headerView.addSubview(self.messageLabel)
        self.headerView.addSubview(self.callLabel)
        self.headerView.addSubview(self.emailLabel)
        self.headerView.addSubview(self.favoriteLabel)
    }
    func setupIconsTouch() {
        // register touch for icons
        self.cameraButton.addTarget(self, action: #selector(ContactDetailViewController.didTapCameraIcon), for: .touchUpInside)
        self.messageButton.addTarget(self, action: #selector(ContactDetailViewController.didTapMessageIcon), for: .touchUpInside)
        self.callButton.addTarget(self, action: #selector(ContactDetailViewController.didTapCallIcon), for: .touchUpInside)
        self.emailButton.addTarget(self, action: #selector(ContactDetailViewController.didTapEmailIcon), for: .touchUpInside)
        self.favoriteButton.addTarget(self, action: #selector(ContactDetailViewController.didTapFavoriteIcon), for: .touchUpInside)
    }
    func setupLabels() {
        let iconFont = UIFont.systemFont(ofSize: 12.0, weight: .semibold)
        let iconFontColor = UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
        
        let iconButtonOffset: CGFloat = 10.0
        
        self.messageLabel.text = "message"
        self.messageLabel.font = iconFont
        self.messageLabel.textColor = iconFontColor
        self.messageLabel.textAlignment = .center
        self.messageLabel.autoSetDimensions(to: CGSize(width: 100.0, height: 13.0))
        self.messageLabel.autoAlignAxis(.vertical, toSameAxisOf: self.messageButton)
        self.messageLabel.autoPinEdge(.top, to: .bottom, of: self.messageButton, withOffset: iconButtonOffset)
        
        self.callLabel.text = "call"
        self.callLabel.font = iconFont
        self.callLabel.textColor = iconFontColor
        self.callLabel.textAlignment = .center
        self.callLabel.autoSetDimensions(to: CGSize(width: 100.0, height: 13.0))
        self.callLabel.autoAlignAxis(.vertical, toSameAxisOf: self.callButton)
        self.callLabel.autoPinEdge(.top, to: .bottom, of: self.callButton, withOffset: iconButtonOffset)
        
        self.emailLabel.text = "email"
        self.emailLabel.font = iconFont
        self.emailLabel.textColor = iconFontColor
        self.emailLabel.textAlignment = .center
        self.emailLabel.autoSetDimensions(to: CGSize(width: 100.0, height: 13.0))
        self.emailLabel.autoAlignAxis(.vertical, toSameAxisOf: self.emailButton)
        self.emailLabel.autoPinEdge(.top, to: .bottom, of: self.emailButton, withOffset: iconButtonOffset)
        
        self.favoriteLabel.text = "favorite"
        self.favoriteLabel.font = iconFont
        self.favoriteLabel.textColor = iconFontColor
        self.favoriteLabel.textAlignment = .center
        self.favoriteLabel.autoSetDimensions(to: CGSize(width: 100.0, height: 13.0))
        self.favoriteLabel.autoAlignAxis(.vertical, toSameAxisOf: self.favoriteButton)
        self.favoriteLabel.autoPinEdge(.top, to: .bottom, of: self.favoriteButton, withOffset: iconButtonOffset)
        
        self.headerConstraint = self.headerView.autoPinEdge(.bottom, to: .bottom, of: self.callLabel, withOffset: self.headerLabelOffset)
        
        self.nameLabel.text = self.contact.name()
        //TODO: add mobile number here
    }
    func setupTableView() {
        // table view setup
        self.view.addSubview(self.tableView)
        self.tableView.autoPinEdge(toSuperviewEdge: .left)
        self.tableView.autoPinEdge(toSuperviewEdge: .right)
        self.tableView.autoPinEdge(toSuperviewEdge: .bottom)
        self.tableView.autoPinEdge(.top, to: .bottom, of: self.headerView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.tableFooterView = UIView() // remove extra table view cells
        self.tableView.register(ContactDetailsTableViewCell.self, forCellReuseIdentifier: "ContactDetailCell")
        self.tableView.isScrollEnabled = false
    }
}
