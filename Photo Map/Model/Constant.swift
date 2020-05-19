//
//  Constant.swift
//  Photo Map
//
//  Created by Philip Yu on 5/19/20.
//  Copyright © 2020 Timothy Lee. All rights reserved.
//

import UIKit

struct Constant {
    
    // MARK: - Properties
    static let clientId = fetchFromPlist(forResource: "ApiKeys", forKey: "CLIENT_ID")
    static let clientSecret = fetchFromPlist(forResource: "ApiKeys", forKey: "CLIENT_SECRET")
    
    // MARK: - Functions
    static func fetchFromPlist(forResource resource: String, forKey key: String) -> String? {
        
        let filePath = Bundle.main.path(forResource: resource, ofType: "plist")
        let plist = NSDictionary(contentsOfFile: filePath!)
        let value = plist?.object(forKey: key) as? String
        
        return value
        
    }
    
}

extension UIButton {
    
    func makeCircular() {
        
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        
    }
    
}
