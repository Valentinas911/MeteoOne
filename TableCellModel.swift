//
//  TableCellModel.swift
//  MeteoOne
//
//  Created by Valentinas Mirosnicenko on 12/29/16.
//  Copyright © 2016 Valentinas Mirosnicenko. All rights reserved.
//

import Foundation
import UIKit

class TableCellModel {

    private var _image: UIImage!
    private var _weekday: String!
    private var _weather: String!
    private var _lowTemp: String!
    private var _highTemp: String!
    
    var image: UIImage {
        get {
            return _image
        } set {
            _image = newValue
        }
    }
    
    var weekday: String {
        get {
            return _weekday
        } set {
            _weekday = newValue
        }
    }
    
    var weather: String {
        get {
            return _weather
        } set {
            _weather = newValue
        }
    }
    
    var lowTemp: String {
        get {
            return _lowTemp
        } set {
            _lowTemp = newValue
        }
    }
    
    var highTemp: String {
        get {
            return _highTemp
        } set {
            _highTemp = newValue
        }
    }
    
    init(image: UIImage, weekday: String, weather: String, lowTemp: String, highTemp: String){
        _image = image
        _weekday = weekday
        _weather = weather
        _lowTemp = lowTemp
        _highTemp = highTemp
    }
    
}
