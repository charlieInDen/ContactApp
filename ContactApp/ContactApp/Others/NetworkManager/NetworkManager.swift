//
//  NetworkManager.swift
//  ContactApp
//
//  Created by Nishant Sharma on 6/16/19.
//  Copyright © 2019 Nishant Sharma. All rights reserved.
//

import Foundation
// Singleton used to execute HTTP request and return it's response
// currently just support GET request and simply returns the content
// without error codes or messages, returns nil in case of error

class NetworkManager {
    
    private init() { }
    
    // MARK: Shared Instance
    static let shared: NetworkManager = NetworkManager()
    
    // get request, run synchronously for threading simplicity
    public func get(urlString: String, completionBlock: ((Data?) -> Void)?) {
        
        let url = URL(string: urlString)
        if let usableUrl = url {
            let request = URLRequest(url: usableUrl)
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                completionBlock?(data)
            })
            task.resume()
        }
    }
}
