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
// let LAT = Location.sharedInstance.latitude
let LAT: Double? = 52.22
let LONGITUDE = "&lon="
// let LON = Location.sharedInstance.longitude
let LON: Double? = 4.54
let FORECAST_MODE = "&cnt=11&mode=json"
let FORECAST_MODE_CITY = "&mode=json&units=metric&cnt=11"
let APP_ID_KEY = "&appid=d835a231da4bb3df16b581b168d7578c"
let CITY_IDENT = "q="
let CITY_NAME = "Sanya" //Hard-coded for now


let CURRENT_WEATHER_URL = "\(CURRENT_BASE_URL)\(LATITUDE)\(LAT!)\(LONGITUDE)\(LON!)\(APP_ID_KEY)"
let CURRENT_WEATHER_CITY_URL = "\(CURRENT_BASE_URL)\(CITY_IDENT))\(CITY_NAME)\(APP_ID_KEY)"
let FORECAST_WEATHER_URL = "\(FORECAST_BASE_URL)\(LATITUDE)\(LAT!)\(LONGITUDE)\(LON!)\(FORECAST_MODE)\(APP_ID_KEY)"
let FORECAST_WEATHER_CITY_URL = "\(FORECAST_BASE_URL)\(CITY_IDENT)\(CITY_NAME)\(FORECAST_MODE_CITY)\(APP_ID_KEY)"
typealias DownloadComplete = () -> ()







