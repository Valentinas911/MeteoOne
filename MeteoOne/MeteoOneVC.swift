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

class MeteoOneVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var temperatureLabel: UILabel!
    @IBOutlet private weak var weatherLabel: UILabel!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var weatherImage: UIImageView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var cityNameField: UITextField!
    
    private let locationManager = CLLocationManager()
    private var currentLocation: CLLocation!
    
    private var tableCellData = [TableCell]()
    private var currentWeather: CurrentWeatherData!
    private var forecast: ForecastData!
    private var forecasts = [ForecastData]()
    private var forecastMethodSelector: Int = 0
    
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
    
    
    fileprivate func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager.location
            LocationService.instance.latitude = currentLocation.coordinate.latitude
            LocationService.instance.longitude = currentLocation.coordinate.longitude
            currentWeather = CurrentWeatherData()
            updateAllData()
            
            } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    fileprivate func updateAllData() {
        currentWeather.downloadWeatherData {
            self.downloadForecastData {
                self.updateWeatherData()
            }
        }
        debugPrint("Data Request Completed")
    }
    
    fileprivate func updateWeatherData(){
        dateLabel.text = currentWeather.date
        temperatureLabel.text = "\(currentWeather.currentTemp)°"
        cityLabel.text = currentWeather.cityName
        weatherLabel.text = currentWeather.weather
        weatherImage.image = UIImage(named: currentWeather.weather)
    }
    
    fileprivate func downloadForecastData(completed: @escaping DownloadComplete) {
        //let forecastWeatherURL = URL(string: FORECAST_WEATHER_URL)!
        var forecastMethod: URL!
        
        if forecastMethodSelector == 0 {
            forecastMethod = URL(string: "\(FORECAST_BASE_URL)\(LATITUDE)\(LAT!)\(LONGITUDE)\(LON!)\(FORECAST_MODE)\(APP_ID_KEY)")
        } else if forecastMethodSelector == 1 {
            forecastMethod = URL(string: "\(FORECAST_BASE_URL)\(CITY_IDENT)\(LocationCity.instance.city)\(FORECAST_MODE_CITY)\(APP_ID_KEY)")
        }
        
        debugPrint("List of Data passed into downloadForecastData() function")
        debugPrint("Current Weather Method Selector \(forecastMethodSelector)")
        debugPrint("Current Weather Method \(forecastMethod)"

            
        )
        
        Alamofire.request(forecastMethod!).responseJSON { response in
            let result = response.result
            debugPrint("Forecast Method Within Alamofire request - \(forecastMethod)")
            self.tableView.allowsSelection = false
            if let dict = result.value as? Dictionary<String, AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] {
                    
                    for obj in list {
                        let forecast = ForecastData(weatherDict: obj)
                        self.forecasts.append(forecast)
                    }
                    self.forecasts.remove(at: 0)
                    self.tableView.reloadData()
                }
            }
            completed() //This has to be within Alamofire.request body
            self.tableView.allowsSelection = true
            debugPrint("Forecast Data Downloaded")
        }
    }
    
    
    
    @IBAction func manualCitySelectionPressed(_ sender: Any) {
        let defaultCity: String = "London"
        
        if cityNameField.text != "" {
            LocationCity.instance.city = cityNameField.text!
            debugPrint("Setting Selected City")
        } else {
            LocationCity.instance.city = defaultCity
            debugPrint("Setting Default City")
        }
        
        if currentWeather.currentWeatherMethodSelector != 1 {
            currentWeather.currentWeatherMethodSelector = 1
            debugPrint("Current Weather Method Selected to \(currentWeather.currentWeatherMethodSelector)")
        }
        
        if forecastMethodSelector != 1 {
            forecastMethodSelector = 1
            debugPrint("Forecast Weather Method Selected to \(forecastMethodSelector)")
        }
        
        forecasts.removeAll()
        debugPrint("forecasts Array cleared")
        updateAllData()
        debugPrint("Data Update Requested")
        
        cityNameField.endEditing(true)
        
        debugPrint("Printing URL's.....")

    }

    @IBAction func automaticSelectionPressed(_ sender: Any) {
        currentWeather.currentWeatherMethodSelector = 0
        forecastMethodSelector = 0
        forecasts.removeAll()
        
        updateAllData()
        cityNameField.endEditing(true)
    }
}

extension MeteoOneVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
}






