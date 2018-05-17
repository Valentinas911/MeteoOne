//
//  Location.swift
//  MeteoOne
//
//  Created by Valentinas Mirosnicenko on 12/30/16.
//  Copyright © 2016 Valentinas Mirosnicenko. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init() {}
    
    var _latitude: Double!
    var _longitude: Double!
    
    var latitude: Double! {
        get {
            return _latitude
        } set {
            _latitude = newValue
        }
    }
    
    var longitude: Double! {
        get {
            return _longitude
        } set {
            _longitude = newValue
        }
    }
    
}

class LocationCity {
    static var sharedInstance = LocationCity()
    private init() {}
    
    var _city: String! = ""
//    var _cityNew: String! = ""
    
    var city: String {
        get {
            return _city
        } set {
            _city = newValue
        }
    }
    
//    var cityNew:String {
//        get {
//            return _cityNew
//        } set {
//            _cityNew = newValue
//        }
//    }
}
