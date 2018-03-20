//
//  Alert.swift
//  20180318-EM- NYCSchools
//
//  Created by Erick Manrique on 3/19/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//

import Foundation
import UIKit

// Custom alert class
class Alert {
    
    /**
     Creates a UIAlertController and presents in on the viewController passed in.
     - parameters:
        = title: Title of the UIAlertController
        - message: Message for the UIAlertController
        - actionTitle: title for UIAlertAction. Default "Dismiss"
        = vc: The viewController that will call the alert
     */
    class func showBasic(title:String, message: String, actionTitle: String = "Dismiss", vc: UIViewController){
        let alertController = UIAlertController(title: title, message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: actionTitle, style: UIAlertActionStyle.default,handler: nil))
        
        DispatchQueue.main.async { [weak vc] in
            vc?.present(alertController, animated: true, completion: nil)
        }
    }
}
