//
//  GoogleResult.swift
//  20180318-EM- NYCSchools
//
//  Created by Erick Manrique on 3/19/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//

import Foundation

// Class used to parse json data from google API
// using swift 4 Decodable to parse json to object
class GoogleResult: Decodable {
    var place_id:String?
    var formatted_address: String?
}
