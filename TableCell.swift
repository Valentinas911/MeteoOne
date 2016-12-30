//
//  TableCell.swift
//  MeteoOne
//
//  Created by Valentinas Mirosnicenko on 12/29/16.
//  Copyright © 2016 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit

class TableCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellWeekday: UILabel!
    @IBOutlet weak var cellWeather: UILabel!
    @IBOutlet weak var cellHighTemp: UILabel!
    @IBOutlet weak var cellLowTemp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateTableCell(forecast: ForecastData) {

        cellWeekday.text = forecast.date
        cellWeather.text = forecast.weather
        cellHighTemp.text = ("High Temp.: \(forecast.highTemp)")
        cellLowTemp.text = ("Low Temp.: \(forecast.lowTemp)")
        cellImage.image = UIImage(named: "\(forecast.weather) Mini")
    }
}
