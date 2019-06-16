//
//  ContactsListViewController+TableView.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit

// MARK: Table View Extension
extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return  alphabets
    }
    // MARK: Table View Datasource
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell") as! ContactTableViewCell
        let alphabet = self.contactsSections[indexPath.section]
        
        
        if let contacts = self.contactsDict[alphabet] {
            let contact = contacts[indexPath.row]
            
            // load product image
            DispatchQueue.main.async {
                cell.contactImageView.image = contact.image()
                cell.favoriteImageView.isHidden = !contact.isFavorite
                cell.nameTitleLabel.text = contact.name()
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.contactsSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let alphabet = self.contactsSections[section]
        if let contacts = self.contactsDict[alphabet] {
            return contacts.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.contactsSections[section]
    }
    
    // MARK: Table View Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let alphabet = self.contactsSections[indexPath.section]
        
        // display contact detail VC of selected contact
        if let contacts = self.contactsDict[alphabet] {
            let contact = contacts[indexPath.row]
            let contactDetailVC = ContactDetailViewController(contact: contact)
            contactDetailVC.listVC = self
            self.navigationController?.pushViewController(contactDetailVC, animated: true)
        }
    }
}
