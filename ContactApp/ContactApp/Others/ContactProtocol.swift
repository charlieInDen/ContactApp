//
//  ContactProtocol.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation

@objc protocol ContactManagerDelegate: class {
    // TODO: Can make didDownloadContacts more descriptive by providing reason for failure
    @objc optional func didDownloadContacts()                        // called when the manager has completed downloading all the contacts and has saved them to Realm
    @objc optional func didFailToDownloadContactsNoResponse()        // failure when no response from api (most likely no internet connection or api down)
    @objc optional func didFailToDownloadContactsEmptyResponse()     // failure when a response has no data
    @objc optional func didDownloadContactsProgress(progress: Float) // called when the manager has is downloading contacts
    @objc optional func didStartDownload()                           // called when the manager has started downloading contacts
}
