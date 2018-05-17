//
//  Constants.swift
//  MeteoOne
//
//  Created by Valentinas Mirosnicenko on 12/29/16.
//  Copyright © 2016 Valentinas Mirosnicenko. All rights reserved.
//

import Foundation

let CURRENT_BASE_URL = "http://api.openweathermap.org/data/2.5/weather?"
let FORECAST_BASE_URL = "http://api.openweathermap.org/data/2.5/forecast/daily?"
let LATITUDE = "lat="
let LAT = Location.sharedInstance.latitude
let LONGITUDE = "&lon="
let LON = Location.sharedInstance.longitude
let FORECAST_MODE = "&cnt=11&mode=json"
let FORECAST_MODE_CITY = "&mode=json&cnt=11"
let APP_ID_KEY = "&appid=d835a231da4bb3df16b581b168d7578c"
let CITY_IDENT = "q="
typealias DownloadComplete = () -> ()







