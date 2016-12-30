//
//  ViewController.swift
//  MeteoOne
//
//  Created by Valentinas Mirosnicenko on 12/28/16.
//  Copyright © 2016 Valentinas Mirosnicenko. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire

class MeteoOneVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var tableCellData = [TableCell]()
    var currentWeather: CurrentWeatherData!
    var forecast: ForecastData!
    var forecasts = [ForecastData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationAuthStatus()
    }
    
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            Location.sharedInstance.latitude = currentLocation.coordinate.latitude
            Location.sharedInstance.longitude = currentLocation.coordinate.longitude
            currentWeather = CurrentWeatherData()
            currentWeather.downloadWeatherData {
                self.downloadForecastData {
                    self.downloadWeatherData()
                }
            }
            print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
            print(Location.sharedInstance.latitude, Location.sharedInstance.longitude)
            print(CURRENT_WEATHER_URL)
            print(FORECAST_WEATHER_URL)
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return tableCellData.count
        return forecasts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? TableCell {
            let forecast = forecasts[indexPath.row]
            tableCell.updateTableCell(forecast: forecast)
            return tableCell
        } else {
            return TableCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func downloadWeatherData(){
        dateLabel.text = currentWeather.date
        temperatureLabel.text = "\(currentWeather.currentTemp)°"
        cityLabel.text = currentWeather.cityName
        weatherLabel.text = currentWeather.weather
        weatherImage.image = UIImage(named: currentWeather.weather)
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //let forecastWeatherURL = URL(string: FORECAST_WEATHER_URL)!
        Alamofire.request(FORECAST_WEATHER_URL).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = ForecastData(weatherDict: obj)
                        self.forecasts.append(forecast)
                        print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed() //This has to be within Alamofire.request body
        }
    }
}






