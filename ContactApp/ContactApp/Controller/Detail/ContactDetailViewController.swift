//
//  ContactDetailViewController.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit
import RealmSwift

enum ContactDetailViewControllerMode {
    case view
    case edit
    case add
}
final class ContactDetailViewController: UIViewController {
    // defining params
    var mode    : ContactDetailViewControllerMode = .view {
        didSet {
            self.updateUIForMode()
        }
    }
    private(set) var contact : Contact
    
    // header elments
    let headerView            : UIView          = UIView()
    let gradient              : CAGradientLayer = CAGradientLayer()
    let profileImageContainer : UIView          = UIView()
    let profileImageView      : UIImageView     = UIImageView()
    let nameLabel             : UILabel         = UILabel()
    
    let messageButton    : ContactDetailIconButton = ContactDetailIconButton()
    let callButton       : ContactDetailIconButton = ContactDetailIconButton()
    let emailButton      : ContactDetailIconButton = ContactDetailIconButton()
    let favoriteButton   : ContactDetailIconButton = ContactDetailIconButton()
    let cameraButton     : ContactDetailIconButton = ContactDetailIconButton()
    let messageLabel     : UILabel     = UILabel()
    let callLabel        : UILabel     = UILabel()
    let emailLabel       : UILabel     = UILabel()
    let favoriteLabel    : UILabel     = UILabel()
    
    // UI Params
    let lightGreen : UIColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    var headerConstraint : NSLayoutConstraint? = nil
    let headerLabelOffset: CGFloat = 12.0
    
    
    //table view
    let tableView: UITableView = UITableView()
    var textFields: [UITextField] = []
    var doneButton: UIBarButtonItem? = nil
    var editButton: UIBarButtonItem? = nil
    var backButton: UIBarButtonItem? = nil
    var cancelButton: UIBarButtonItem? = nil
    
    var didUpdateContact: Bool = false
    public weak var listVC: ContactsListViewController? = nil

    init(contact: Contact) {
        self.contact = contact
        super.init(nibName: nil, bundle: nil)
        
        // set nav bar item
        self.doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ContactDetailViewController.didTapDoneButton))
        
        self.editButton = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(ContactDetailViewController.didTapEditButton))
        
        self.cancelButton = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(ContactDetailViewController.didTapCancelButton))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHeaderUI()
        self.setupProfileContainerUI()
        self.setupContainerConstraints()
        self.setupIconsTouch()
        self.setupLabels()
        self.setupTableView()
        
        self.backButton = self.navigationItem.leftBarButtonItem
        self.updateUIForMode()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // set gradient frame
        self.gradient.frame = self.headerView.bounds
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // tell listVC to update data only if contact has been updated
        if self.didUpdateContact {
            self.listVC?.reloadData()
        }
    }
    
    func updateFavoriteButton() {
        DispatchQueue.main.async {
            if self.contact.isFavorite {
                self.favoriteButton.iconImageView.image = UIImage(named: "favouriteSelected")
            } else {
                self.favoriteButton.iconImageView.image = UIImage(named: "favourite")
            }
            self.favoriteButton.setNeedsDisplay()
        }
    }
    func updateUIForMode() {
        DispatchQueue.main.async {
            if self.mode == .edit || self.mode == .add {
                self.editAddUIUpdate()
                
            } else if self.mode == .view {
                self.viewModeUIUpdate()
            }
        }
        
        self.tableView.reloadData()
    }
    func updateContactsOnTapClicked() {
        // update contact
        if textFields.count != self.tableView.numberOfRows(inSection: 0) { //Four details supported
            return
        }
        let realm: Realm = try! Realm()
        try! realm.write {
            let firstNameTF = textFields[0]
            let lastNameTF = textFields[1]
            let mobileTF = textFields[2]
            let emailTF = textFields[3]
            
            if let fn = firstNameTF.text {
                if fn == "" {
                    contact.firstName = nil
                } else if contact.firstName == nil || contact.firstName! != fn {
                    contact.firstName = fn
                }
                self.didUpdateContact = true
            }
            
            if let ln = lastNameTF.text {
                if ln == "" {
                    contact.lastName = nil
                } else if contact.lastName == nil || contact.lastName! != ln {
                    contact.lastName = ln
                }
                self.didUpdateContact = true
            }
            
            if let mobile = mobileTF.text {
                if mobile == "" {
                    contact.mobile = nil
                } else if contact.mobile == nil || contact.mobile! != mobile {
                    contact.mobile = mobile
                }
                self.didUpdateContact = true
            }
            
            if let email = emailTF.text {
                if email == "" {
                    contact.email = nil
                } else if contact.email == nil || contact.email! != email {
                    contact.email = email
                }
                self.didUpdateContact = true
            }
        }
        
        self.mode = .view
    }
    
}



extension ContactDetailViewController {
    private func viewModeUIUpdate() {
        self.navigationItem.rightBarButtonItem = self.editButton
        self.navigationItem.leftBarButtonItem = self.backButton
        self.tableView.isUserInteractionEnabled = false
        
        self.cameraButton.isUserInteractionEnabled = false
        
        self.headerConstraint?.constant = self.headerLabelOffset
        UIView.animate(withDuration: 0.2, animations: {
            if self.contact.mobile != nil {
                self.callButton.isEnabled = true
                self.messageButton.isEnabled = true
            } else {
                self.callButton.isEnabled = false
                self.messageButton.isEnabled = false
            }
            if self.contact.email != nil {
                self.emailButton.isEnabled = true
            } else {
                self.emailButton.isEnabled = false
            }
            self.cameraButton.alpha = 0.0
            self.callButton.alpha = 1.0
            self.messageButton.alpha = 1.0
            self.emailButton.alpha = 1.0
            self.nameLabel.alpha = 1.0
            self.favoriteButton.alpha = 1.0
            self.messageLabel.alpha = 1.0
            self.callLabel.alpha = 1.0
            self.emailLabel.alpha = 1.0
            self.favoriteLabel.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) in
            if finished {
                self.messageButton.isUserInteractionEnabled = self.contact.mobile != nil
                self.callButton.isUserInteractionEnabled = self.contact.mobile != nil
                self.emailButton.isUserInteractionEnabled = self.contact.email != nil
                self.favoriteButton.isUserInteractionEnabled = true
            }
        })
    }
    private func editAddUIUpdate() {
        self.navigationItem.rightBarButtonItem = self.doneButton
        self.navigationItem.leftBarButtonItem = self.cancelButton
        self.tableView.isUserInteractionEnabled = true
        
        self.messageButton.isUserInteractionEnabled = false
        self.callButton.isUserInteractionEnabled = false
        self.emailButton.isUserInteractionEnabled = false
        self.favoriteButton.isUserInteractionEnabled = false
        
        self.headerConstraint?.constant = self.headerLabelOffset - 110.0
        UIView.animate(withDuration: 0.2, animations: {
            self.messageButton.alpha = 0.0
            self.callButton.alpha = 0.0
            self.emailButton.alpha = 0.0
            self.favoriteButton.alpha = 0.0
            self.nameLabel.alpha = 0.0
            self.messageLabel.alpha = 0.0
            self.callLabel.alpha = 0.0
            self.emailLabel.alpha = 0.0
            self.favoriteLabel.alpha = 0.0
            self.cameraButton.alpha = 1.0
            self.view.layoutIfNeeded()
        }, completion: {(finished: Bool) in
            if finished {
                self.cameraButton.isUserInteractionEnabled = true
            }
        })
    }
}
