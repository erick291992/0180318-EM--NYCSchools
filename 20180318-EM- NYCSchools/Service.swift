//
//  Service.swift
//  20180318-EM- NYCSchools
//
//  Created by Erick Manrique on 3/19/18.
//  Copyright © 2018 Erick Manrique. All rights reserved.
//


import Foundation
import Alamofire
import GooglePlaces

// Given more time I would improve on error hadling in order to be more descriptive

// Singleton service class containing all functions that will call an api
class Service {
    
    static let shared = Service()
    
    // MARK: - Google Maps Geocoding API requests
    // Link https://developers.google.com/maps/documentation/geocoding/intro
    
    /**
     retrieves information from google on a for a given address
     - parameters:
        - address: The address of the location desired. Default to Google Headquarters
        - completion: Completion block that will return a GoogleLocation and an error
     */
    func getLocationInfo(address: String = "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA", completion:@escaping (_ result: GoogleLocation?, _ error: Error?) -> Void){
        
        var parameters = [String:Any]()
        parameters["address"] = address
        parameters["key"] = Key.googleGeo
        
        Alamofire.request(Api.googleGeo, parameters: parameters).responseJSON { (response) in
            
            if let error = response.error {
                completion(nil, error)
            } else {
                if let data = response.data {
                    do {
                        // using swift 4 decoder to parse json to object
                        let location = try JSONDecoder().decode(GoogleLocation.self, from: data)
                        completion(location, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
                else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    //MARK: - GooglePlaces API requests
    
    // Given more time I would find an alternative google api call to the an image for an address
    // Link https://developers.google.com/places/ios-api/photos#attributions
    
    // The following api call tries to find an image fo the given address but it always returns
    // a result count of 0 unless you give it the address of google "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA"
    
    /**
     retrieves the first image for a given address
     - parameters:
        - address: The address of the location desired. Default to Google Headquarters
        - completion: Completion block that will return a location and an error
     */
    func getFirstPhotoForPlace(address:String = "1600 Amphitheatre Parkway, Mountain View, CA 94043, USA", completion:@escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        getLocationInfo(address: address) { (location, error) in
            if let error = error {
                completion(nil,error)
            } else {
                if let placeId = location?.results?[0].place_id {
                    self.getFirstPhotoForPlace(placeID: placeId, completion: completion)
                } else {
                    completion(nil,nil)
                }
            }
        }
    }
    
    /**
     retrieves the first image for a given placeID
     - parameters:
        - placeID: The placeID from the Google Maps Geocoding API
        - completion: Completion block that will return a location and an error
     */
    func getFirstPhotoForPlace(placeID: String, completion:@escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                completion(nil, error)
            } else {
                if let firstPhoto = photos?.results.first {
                    self.getImageFromMetadata(photoMetadata: firstPhoto, completion: completion)
                } else {
                    completion(nil, nil)
                }
            }
        }
    }
    
    /**
     retrieves an image for the given photoMetadata
     - parameters:
        - photoMetadata: The photoMetadata given to use from the GooglePlaces api
        - completion: Completion block that will return a location and an error
     */
    private func getImageFromMetadata(photoMetadata: GMSPlacePhotoMetadata, completion:@escaping (_ result: UIImage?, _ error: Error?) -> Void) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                completion(nil,error)
            } else {
                completion(photo,nil)
            }
        })
    }
    
    //MARK: - NYC Schools API requests
    
    /**
     retrieves an image for the given photoMetadata
     - parameters:
        - completion: Completion block that will return schools and an error
     */
    func getSchools(completion:@escaping (_ schools: [School]?, _ error: Error?) -> Void) {
        
        Alamofire.request(Api.highSchools, parameters: nil).responseJSON { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                if let data = response.data {
                    do {
                        // using swift 4 decoder to parse json to object
                        let schools = try JSONDecoder().decode([School].self, from: data)
                        completion(schools, nil)
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    /**
     retrieves an image for the given photoMetadata
     - parameters:
        - dbn: The dbn id of a school
        - completion: Completion block that will return schools scores and an error
     */
    func getSchoolScores(dbn:String, completion:@escaping (_ scores: SchoolScores?, _ error: Error?) -> Void) {
        
        var parameters = [String:Any]()
        parameters["dbn"] = dbn
        
        Alamofire.request(Api.highSchoolScore, parameters: parameters).responseJSON { (response) in
            if let error = response.error {
                completion(nil, error)
            } else {
                if let data = response.data {
                    do {
                        // using swift 4 decoder to parse json to object
                        let scores = try JSONDecoder().decode([SchoolScores].self, from: data)
                        if scores.count == 0 {
                            completion(nil,nil)
                        } else {
                            completion(scores.first, nil)
                        }
                    } catch {
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
}

