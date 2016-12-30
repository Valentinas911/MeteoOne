//
//  CurrentWeatherData.swift
//  MeteoOne
//
//  Created by Valentinas Mirosnicenko on 12/29/16.
//  Copyright © 2016 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit
import Alamofire

class CurrentWeatherData {
    private var _cityName: String!
    private var _date: String!
    private var _weather: String!
    private var _currentTemp: Double!
    
    var cityName: String {
        if _cityName == nil {
            _cityName = "N/A"
        }
        return _cityName

    }
    
    var date: String {
        if _date == nil {
            _date = "N/A"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        let currentDate = dateFormatter.string(from: Date())
        self._date = "Today, \(currentDate)"
        return _date
        
    }
    
    var weather: String {
        if _weather == nil {
            _weather = "N/A"
        }
        return _weather
    }
    
    var currentTemp: Double {
        if _currentTemp == nil {
            _currentTemp = 0.0
        }
        return _currentTemp
    }
    
    func downloadWeatherData(completed: @escaping DownloadComplete) {
        //Alamofire download
        //let currentWeatherURL = URL(string: CURRENT_WEATHER_URL)
        Alamofire.request(CURRENT_WEATHER_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let name = dict["name"] as? String {
                    self._cityName = name.capitalized

                }
                
                if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] {
                    if let main = weather[0]["main"] as? String {
                        self._weather = main.capitalized

                    }
                }
                
                if let main = dict["main"] as? Dictionary<String,AnyObject> {
                    if let currentTemp = main ["temp"] as? Double {
                        let kelvinToCelsius = currentTemp - 273.15
                        self._currentTemp = kelvinToCelsius.rounded(.toNearestOrAwayFromZero)

                    }
                }
                
            }
            completed() //This has to be within Alamofire.request body
        }
    }
}
