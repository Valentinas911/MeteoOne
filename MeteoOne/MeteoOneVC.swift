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
    @IBOutlet weak var cityNameField: UITextField!
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    var tableCellData = [TableCell]()
    var currentWeather: CurrentWeatherData!
    var forecast: ForecastData!
    var forecasts = [ForecastData]()
    var forecastMethodSelector: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
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
            updateAllData()
//            print(currentLocation.coordinate.latitude, currentLocation.coordinate.longitude)
//            print(Location.sharedInstance.latitude, Location.sharedInstance.longitude)
//            print(CURRENT_WEATHER_URL)
//            print(FORECAST_WEATHER_URL)
//            print("Current weather for city URL: \(CURRENT_WEATHER_CITY_URL)")
//            print("Weather forecast for city URL: \(FORECAST_WEATHER_CITY_URL)")
            
//            if LocationCity.sharedInstance.city == "" {
//                print("LocationCity.sharedInstance.city == NIL")
//            } else {
//                print(LocationCity.sharedInstance.city)
//            }
//            
//            if CITY_NAME == "" {
//                print("CITY_NAME == NIL")
//            } else {
//                print(CITY_NAME)
//            }
            
            } else {
            locationManager.requestWhenInUseAuthorization()
            locationAuthStatus()
        }
    }
    
    func updateAllData() {
        currentWeather.downloadWeatherData {
            self.downloadForecastData {
                self.updateWeatherData()
            }
        }
        print("Data Request Completed")
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
    
    func updateWeatherData(){
        dateLabel.text = currentWeather.date
        temperatureLabel.text = "\(currentWeather.currentTemp)°"
        cityLabel.text = currentWeather.cityName
        weatherLabel.text = currentWeather.weather
        weatherImage.image = UIImage(named: currentWeather.weather)
    }
    
    func downloadForecastData(completed: @escaping DownloadComplete) {
        //let forecastWeatherURL = URL(string: FORECAST_WEATHER_URL)!
        var forecastMethod: URL!
        
        if forecastMethodSelector == 0 {
            forecastMethod = URL(string: "\(FORECAST_BASE_URL)\(LATITUDE)\(LAT!)\(LONGITUDE)\(LON!)\(FORECAST_MODE)\(APP_ID_KEY)")
        } else if forecastMethodSelector == 1 {
            forecastMethod = URL(string: "\(FORECAST_BASE_URL)\(CITY_IDENT)\(LocationCity.sharedInstance.city)\(FORECAST_MODE_CITY)\(APP_ID_KEY)")
        }
        
        print("List of Data passed into downloadForecastData() function")
        print("Current Weather Method Selector \(forecastMethodSelector)")
        print("Current Weather Method \(forecastMethod)"

            
        )
        
        Alamofire.request(forecastMethod!).responseJSON { response in
            let result = response.result
            print("Forecast Method Within Alamofire request - \(forecastMethod)")
            self.tableView.allowsSelection = false
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = ForecastData(weatherDict: obj)
                        self.forecasts.append(forecast)
                        // print(obj)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed() //This has to be within Alamofire.request body
            self.tableView.allowsSelection = true
            print("Forecast Data Downloaded")
        }
    }
    
    
    
    @IBAction func manualCitySelectionPressed(_ sender: Any) {
        let defaultCity: String = "London"
        
        if cityNameField.text != "" {
            LocationCity.sharedInstance.city = cityNameField.text!
            print("Setting Selected City")
        } else {
            LocationCity.sharedInstance.city = defaultCity
            print("Setting Default City")
        }
        
        if currentWeather.currentWeatherMethodSelector != 1 {
            currentWeather.currentWeatherMethodSelector = 1
            print("Current Weather Method Selected to \(currentWeather.currentWeatherMethodSelector)")
        }
        
        if forecastMethodSelector != 1 {
            forecastMethodSelector = 1
            print("Forecast Weather Method Selected to \(forecastMethodSelector)")
        }
        
        forecasts.removeAll()
        print("forecasts Array cleared")
        updateAllData()
        print("Data Update Requested")
        
        cityNameField.endEditing(true)
        
        print("Printing URL's.....")
//        print(CURRENT_WEATHER_CITY_URL)
//        print(FORECAST_WEATHER_CITY_URL)
    }

    @IBAction func automaticSelectionPressed(_ sender: Any) {
        currentWeather.currentWeatherMethodSelector = 0
        forecastMethodSelector = 0
        forecasts.removeAll()
        
        updateAllData()
//        print(CURRENT_WEATHER_URL)
//        print(FORECAST_WEATHER_URL)
        cityNameField.endEditing(true)
    }
}






