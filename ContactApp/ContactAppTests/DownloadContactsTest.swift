//
//  DownloadContactsTest.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import XCTest
@testable import ContactApp

// This test requires an active internet connection
class ContactsTest: XCTestCase {
    var asyncResult: Bool? = .none
    
    // Async test code needs to fulfill the XCTestExpecation used for the test
    // when all the async operations have been completed. For this reason we need
    // to store a reference to the expectation
    var asyncExpectation: XCTestExpectation?
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // test if http manager get func is working
    func testGetRequestAndInternet() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        NetworkManager.shared.get(urlString: "http://www.google.com", completionBlock: { (data) in
            XCTAssertTrue(data != nil)
        })
    }
    
    // test if gojek api available
    func testGojekAPI() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        NetworkManager.shared.get(urlString: ContactManager.gojekUrl() , completionBlock: { (data) in
            XCTAssertTrue(data != nil)
        })
    }
    
    
    // MARK: Functional test
    func testSortingContacts() {
        // test sorting contacts
        if ContactManager.shared.contacts().count <= 0 {
            XCTFail("0 contacts available for sorting test")
        }
        
        let contactsDict = ContactManager.shared.contactsSorted()
        
        for (alphabet, contacts) in contactsDict {
            if alphabet == "#" || contacts.count <= 0 {
                continue
            }
            
            for i in 0..<contacts.count - 1 {
                let j = i + 1
                let firstContact  = contacts[i]
                let secondContact = contacts[j]
                if firstContact.isFavorite == secondContact.isFavorite {
                    XCTAssertTrue(firstContact.firstName! <= secondContact.firstName!)
                }
            }
        }
    }
}


