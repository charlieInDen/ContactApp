//
//  ContactDetailViewController+ActionHandler.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import UIKit
import MessageUI
import RealmSwift

extension ContactDetailViewController {
    // MARK: Icon Touch Callbacks
    @objc public func didTapCameraIcon() {
        let camera = DSCameraHandler(delegate_: self)
        let optionMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        optionMenu.popoverPresentationController?.sourceView = self.view
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { (alert : UIAlertAction!) in
            camera.getCameraOn(self, canEdit: true)
        }
        let sharePhoto = UIAlertAction(title: "Photo Library", style: .default) { (alert : UIAlertAction!) in
            camera.getPhotoLibraryOn(self, canEdit: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert : UIAlertAction!) in
        }
        optionMenu.addAction(takePhoto)
        optionMenu.addAction(sharePhoto)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc public func didTapMessageIcon() {
        if let mobile = self.contact.mobile, MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.recipients = [mobile]
            composeVC.messageComposeDelegate = self
            self.present(composeVC, animated: true, completion: nil)
        }
    }
    
    @objc public func didTapCallIcon() {
        if let mobile = self.contact.mobile, let url = URL(string: "tel://\(mobile)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc public func didTapEmailIcon() {
        if let email = self.contact.email, MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            self.present(mail, animated: true)
        }
    }
    @objc public func didTapFavoriteIcon() {
        let realm: Realm = try! Realm()
        try! realm.write {
            self.contact.isFavorite = !self.contact.isFavorite
            self.didUpdateContact = true
        }
        self.updateFavoriteButton()
    }
    // MARK: Navigation Bar Item Callback
    @objc public func didTapCancelButton() {
        if self.mode == .add {
            self.navigationController?.popViewController(animated: true)
            return
        }
        // update contact
        if textFields.count != self.tableView.numberOfRows(inSection: 0) { //Four details supported
            return
        }
        let firstNameTF = textFields[0]
        let lastNameTF = textFields[1]
        let mobileTF = textFields[2]
        let emailTF = textFields[3]
        DispatchQueue.main.async {
            firstNameTF.text = self.contact.firstName
            lastNameTF.text = self.contact.lastName
            mobileTF.text = self.contact.mobile
            emailTF.text = self.contact.email
        }
        
        self.mode = .view
    }
    
    @objc public func didTapDoneButton() {
        self.view.endEditing(true)
        if self.mode == .add {
            //TODO: Adding contact
            self.navigationController?.popViewController(animated: true)
            return
        }
        DispatchQueue.main.async {
            self.updateContactsOnTapClicked()
        }
    }
    
    // MARK: Navigation Bar Item Callback
    @objc public func didTapEditButton() {
        self.mode = .edit
    }
    
}

extension ContactDetailViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}


extension ContactDetailViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        
        // update contact image data
        let realm: Realm = try! Realm()
        try! realm.write {
            self.contact.imageData = image.pngData()
        }
        
        // update new view profile image
        DispatchQueue.main.async {
            self.profileImageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
