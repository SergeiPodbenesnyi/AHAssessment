//
//  AppConfiguration.swift
//  AHAssessment
//
//  Created by Sergei Podnebesnyi on 19.04.2023.
//

import Foundation

class AppConfiguration {
    
    private var dict: NSDictionary
    
    static var rijksApiKey = "rijksApiKey"
    
    internal init() {
        // Read AppConfiguration
        let path = Bundle.init(for: type(of: self)).path(forResource: "AppConfiguration", ofType: "plist")
        self.dict = (NSDictionary(contentsOfFile: path!) as? [String: AnyObject])! as NSDictionary
    }
    
    func getConfig(_ configKey: String) -> String {
        return dict[configKey] as! String
    }
}

