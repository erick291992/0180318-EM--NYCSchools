//
//  School.swift
//  20180318-EM- NYCSchools
//
//  Created by Erick Manrique on 3/19/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//

import Foundation

// using swift 4 Decodable to parse json to object
class School: Decodable {
    var dbn: String
    var school_name: String
    var overview_paragraph: String
    var phone_number: String
    var location: String
    var schoolsScores: SchoolScores?
    var address: String {
        get {
            let toArray = location.components(separatedBy: "(")
            return toArray.first!
        }
    }
    /*
     init method
     I am force casting here because if it breaks then its an issue
     with missing data or a downcasting data
    */
    init(dictionary: [String:Any]) {
        self.dbn = dictionary["dbn"] as! String
        self.school_name = dictionary["school_name"] as! String
        self.location = dictionary["location"] as! String
        self.overview_paragraph = dictionary["overview_paragraph"] as! String
        self.phone_number = dictionary["phone_number"] as! String
    }
}
