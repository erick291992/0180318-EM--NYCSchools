//
//  Constants.swift
//  20180318-EM- NYCSchools
//
//  Created by Erick Manrique on 3/19/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//

import Foundation

enum Api {
    static let googleGeo = "https://maps.googleapis.com/maps/api/geocode/json"
    static let highSchools = "https://data.cityofnewyork.us/resource/97mf-9njv.json"
    static let highSchoolScore = "https://data.cityofnewyork.us/resource/734v-jeq5.json"
}

enum Key {
    static let googleGeo = "AIzaSyBpyCBCNNJiKvE2N7c8yqdgvsIr2mXWbis"
    static let googlePlaces = "AIzaSyAQx14iiNbP3n60n3d0_tF6jd-vGVmAC2A"
}

enum Csv {
    static let schoolsInfoPath =  "2017_DOE_High_School_Directory"
    static let fileType = "csv"
}
