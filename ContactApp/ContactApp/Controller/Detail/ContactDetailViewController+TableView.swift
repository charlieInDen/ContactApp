//
//  ContactDetailViewController+TableView.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

extension ContactDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Table View Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let height: CGFloat = 58.0
        
        
        if self.mode == .view {
            // only return height if the contact info on the row is not nil, otherwise hide it by having 0.00 height
            if indexPath.row == 0 && self.contact.firstName != nil {
                return height
            }
            
            if indexPath.row == 1 && self.contact.lastName != nil {
                return height
            }
            
            if indexPath.row == 2 && self.contact.mobile != nil {
                return height
            }
            
            if indexPath.row == 3 && self.contact.email != nil {
                return height
            }
            
            return 0.0
        } else {
            // if editing show all
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "ContactDetailCell") as! ContactDetailsTableViewCell
        if indexPath.row == 0 {
            cell.mainLabel.text = "First Name"
            cell.contentField.text = self.contact.firstName
            cell.contentField.keyboardType = .namePhonePad
        } else if indexPath.row == 1 {
            cell.mainLabel.text = "Last Name"
            cell.contentField.text = self.contact.lastName
            cell.contentField.keyboardType = .namePhonePad
        } else if indexPath.row == 2 {
            cell.mainLabel.text = "mobile"
            cell.contentField.text = self.contact.mobile
            cell.contentField.keyboardType = .phonePad
        } else if indexPath.row == 3 {
            cell.mainLabel.text = "email"
            cell.contentField.text = self.contact.email
            cell.contentField.keyboardType = .emailAddress
        }
        cell.selectionStyle = .none
        if indexPath.row >= textFields.count {
            textFields.append(cell.contentField)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        return
    }
}
