//
//  TableCell.swift
//  MeteoOne
//
//  Created by Valentinas Mirosnicenko on 12/29/16.
//  Copyright © 2016 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var cellWeekday: UILabel!
    @IBOutlet private weak var cellWeather: UILabel!
    @IBOutlet private weak var cellHighTemp: UILabel!
    @IBOutlet private weak var cellLowTemp: UILabel!
        
    func updateTableCell(forecast: ForecastData) {

        cellWeekday.text = forecast.date
        cellWeather.text = forecast.weather
        cellHighTemp.text = ("High Temp.: \(forecast.highTemp)°")
        cellLowTemp.text = ("Low Temp.: \(forecast.lowTemp)°")
        cellImage.image = UIImage(named: "\(forecast.weather) Mini")
    }
}
