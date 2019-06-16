//
//  ContactsListViewController+ContactManagerDelegate.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation

extension ContactsListViewController: ContactManagerDelegate {
    //MARK: Contact Manager Delegate
    func didDownloadContacts() {
        self.reloadData()
        self.hideLoadingUI()
    }
    
    func didFailToDownloadContactsNoResponse() {
        self.hideLoadingUI()
        DispatchQueue.main.async {
            self.downloadFailureAlert.message = "Please check your internet connection. Would you like to try again?"
            self.present(self.downloadFailureAlert, animated: true, completion: nil)
        }
    }
    
    func didFailToDownloadContactsEmptyResponse() {
        self.hideLoadingUI()
        DispatchQueue.main.async {
            self.downloadFailureAlert.message = "We found 0 contacts. Would you like to try again?"
            self.present(self.downloadFailureAlert, animated: true, completion: nil)
        }
    }
    
    func didStartDownload() {
        self.showLoadingUI()
    }
    
    func didDownloadContactsProgress(progress: Float) {
        DispatchQueue.main.async {
            self.fadeViewLabel.text = "\(self.fadeViewLabelText) (\(round(progress*1000.0)/10.0)%)"
        }
    }
}
