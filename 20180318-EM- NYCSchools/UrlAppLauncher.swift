//
//  UrlAppLauncher.swift
//  20180318-EM- NYCSchools
//
//  Created by Erick Manrique on 3/20/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//

import Foundation
import UIKit

class UrlAppLauncher {
    
    /**
     launches apple maps with a given address
     - parameters:
        = address: address that will be lauched on apple maps
     */
    class func launchMapUsingAddress(address: String){
        let newAddress = address.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        let url = "http://maps.apple.com/?q=\(newAddress)"
        let targetURL = URL(string: url)!
        launchIfAppAvailable(targetURL: targetURL)
    }
    
    /**
     helper function that will check if a give url can be opened/isAvailable
     - parameters:
        = targetURL: URL that will be checked
     */
    private class func launchIfAppAvailable(targetURL: URL){
        let isAvailable = UIApplication.shared.canOpenURL(targetURL)
        if isAvailable{
            UIApplication.shared.open(targetURL, options: [:], completionHandler: nil)
        }
    }
}
