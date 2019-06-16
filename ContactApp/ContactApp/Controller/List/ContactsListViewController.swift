//
//  ContactsListViewController.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

final class ContactsListViewController: UIViewController {
    
    // contacts/table data
    // the table view data assumes the following, contactsDict is pre sorted
    // contact section represent the title of the tbale sections
    // the contactsDict are keyed by it's prespective elements of contactsSection (alphabets in this instance)
    private(set) var contactsDict     : [String: [Contact]]  = [String: [Contact]]() // key is alphabet, value are contacts associated to tht alphabet
    private(set) var contactsSections : [String]             = [String]()
    
    // ui elements
    private let tableView      : UITableView             = UITableView()
    
    let fadeViewLabel  : UILabel                 = UILabel()
    private let activityView   : UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
    private let fadeView       : UIView                  = UIView()
    
    let downloadFailureAlert : UIAlertController = UIAlertController(title: "Failed to Download Contacts", message: nil, preferredStyle: .alert)
    
    // ui params
    private let navBarTitle            : String  = "Contact"     // bar title (Contacts)
    private let backgroundColor        : UIColor = UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 249.0/255.0, alpha: 1.0) // background color (light gray)
    public  let rowHeight              : CGFloat = 64.0
    private let fadeViewLabelFont      : UIFont  = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
    let fadeViewLabelText      : String  = "Downloading Contacts"
    private let fadeViewLabelTextColor : UIColor = .white
    
    fileprivate let lightGreen : UIColor = UIColor(red: 80.0/255.0, green: 227.0/255.0, blue: 194.0/255.0, alpha: 1.0)
    let alphabets: [String] = ContactManager.alphabet
    private let contactDetailVC = ContactDetailViewController(contact: Contact())

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // setup UI
        self.initSetup()
        // subscribe to contact manager
        ContactManager.shared.delegate = self
        // try to fetch contacts from Gojek
        ContactManager.shared.fetchContacts()
    }
    private func initSetup() {
        // set navbar tint color
        self.navigationController?.navigationBar.tintColor = self.lightGreen
        
        // set right button
        let rightButton = NavigationBarButtonItem(barButtonSystemItem: .add,
                                                  target: self,
                                                  action: #selector(addContact))
        self.navigationItem.rightBarButtonItem  = rightButton
        
        // setup contacts data
        self.contactsDict     = ContactManager.shared.contactsSorted()
        self.contactsSections = ContactManager.alphabet
        
        // set initialized params
        self.title = self.navBarTitle
        self.view.backgroundColor = self.backgroundColor
        
        self.setupTableView()
        
        self.setupLoadingView()
        
        self.setupFailureAlert()
    }
    private func setupTableView() {
        // setup table view
        self.tableView.contentInsetAdjustmentBehavior = .never // prevent odd animation of table view cells when pushing VC
        self.tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: "ContactCell")
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = self.backgroundColor
        self.view.addSubview(self.tableView)
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.sectionIndexColor = UIColor.gray
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            guard let bottomPadding = window?.safeAreaInsets.bottom else {
                    self.tableView.autoPinEdgesToSuperviewEdges()
                    return
            }
            self.tableView.autoPinEdgesToSuperviewEdges(with: UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomPadding, right: 0.0))

        }
        else {
            self.tableView.autoPinEdgesToSuperviewEdges()
        }
       
    }
    private func setupLoadingView() {
        // setup loading view
        self.fadeView.frame = self.view.frame
        self.fadeView.backgroundColor = UIColor.black
        self.fadeView.alpha = 0.3
        self.fadeView.isHidden = true
        self.view.addSubview(fadeView)
        
        self.fadeView.addSubview(self.activityView)
        self.activityView.hidesWhenStopped = true
        self.activityView.autoAlignAxis(toSuperviewAxis: .vertical)
        self.activityView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        self.fadeView.addSubview(self.fadeViewLabel)
        self.fadeViewLabel.autoSetDimension(.height, toSize: 20.0)
        self.fadeViewLabel.autoPinEdge(toSuperviewEdge: .left)
        self.fadeViewLabel.autoPinEdge(toSuperviewEdge: .right)
        self.fadeViewLabel.autoPinEdge(.bottom, to: .top, of: self.activityView, withOffset: -30.0)
        self.fadeViewLabel.text = self.fadeViewLabelText
        self.fadeViewLabel.font = self.fadeViewLabelFont
        self.fadeViewLabel.textColor = self.fadeViewLabelTextColor
        self.fadeViewLabel.textAlignment = .center
    }
    // MARK: Loading view functions
    func showLoadingUI() {
        DispatchQueue.main.async {
            self.fadeView.isHidden = false
            self.activityView.startAnimating()
        }
    }
    
    func hideLoadingUI() {
        DispatchQueue.main.async {
            self.fadeView.isHidden = true
            self.activityView.stopAnimating()
        }
    }
    func reloadData() {
        DispatchQueue.main.async {
            self.contactsDict = ContactManager.shared.contactsSorted()
            self.tableView.reloadData()
        }
    }
    
    // MARK: Add New Contact function
    @objc func addContact() {
        contactDetailVC.listVC = self
        contactDetailVC.mode = .add
        self.navigationController?.pushViewController(contactDetailVC, animated: true)
    }
    
    private func setupFailureAlert() {
        // setup failure alert
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: { action in
            ContactManager.shared.fetchContacts()
        })
        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        self.downloadFailureAlert.addAction(okAction)
        self.downloadFailureAlert.addAction(cancelAction)
    }
}

