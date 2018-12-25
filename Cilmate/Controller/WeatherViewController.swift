//
//  ViewController.swift
//  Cilmate
//
//  Created by Hansa Anuradha on 12/20/18.
//  Copyright © 2018 Hansa Anuradha. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

//  ChangeCityDelegate is a protocol that WeatherViewController have to conform
class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {

    // Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID : String = "1673431beb2030373dbf969c02455002"
    
    // Declare instance variables
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    // IBOutlets
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Set up the location manager here
        locationManager.delegate = self  // Set the delegate so when the location manager finish fetching the location data, it will send those to the delegate which is the WeatherViewController in this situation
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // Set the desired accuracy, always select the most relevent one since this process is so power consuming when the accuracy gets higher
        locationManager.requestWhenInUseAuthorization() // Request Permission from User
        locationManager.startUpdatingLocation() // Start updating GPS location
    }
    
    //Mark: -   Location Manager Delegate Methods
    /*********************************************************************************************************************************************/
    
    // didUpdateLocations method - When the location manager has new location data it will trigger this method to tell the deligate that new location data is available
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]   // Get the last location of the locations array which is the most accurate one
        // Check whether the location is valid
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation() // If location is valid, stop updating the location since that is a high power intensive process
            print("Longitude = \(location.coordinate.longitude), Latitude = \(location.coordinate.latitude)")
            
            // Get Latitude and Longitude
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            // Create a dictionaty with latitude, longitude and app id
            let params : [String : String] = ["lat" : latitude, "lon" : longitude, "appid" : APP_ID]
            
            // Get weather data from the Web Service
            getWeatherData(url : WEATHER_URL, parameters : params)
        }
    }
    
    
    // didFailWithError method - Tells the deligate that location manager was unable to retrieve a location value
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable" // Tells the User that the location is unavailable
    }
    
    //Mark: -   Networking
    /*********************************************************************************************************************************************/

    // getWeather method - Fetch weather infromation from the web service
    func getWeatherData(url : String, parameters : [String : String]) {
        
        // Alamorefire requests data from the server in the backgroud (Asyncronous), once the background process is completed, we will have a response
        Alamofire.request(url, method : .get, parameters: parameters).responseJSON {
            response in // Now we are trying to tackle with the respond which is a JSON the we have got
            if response.result.isSuccess { // Response is successfull
                print("Success! Got the weather data!") // Print that response is successful
                
                let weatherJSON : JSON = JSON(response.result.value!) // Get the data in response to a JSON / We have force unwrapped the value, since it has been checked and confirmed that it has a value for sure
                print(weatherJSON) // Print the JSON
                // Parse JSON
                self.updateWeatherData(json : weatherJSON)
                
                
                
            } else { // Responce is failure
                print("Error \(String(describing: response.result.error))") // Print the error
                self.cityLabel.text = "Connection Issues" // Show the User the error
            }
        }
    }
    
    
    //Mark: -   JSON Parsing
    /*********************************************************************************************************************************************/
    
    // updateWeatherData method - Parse JSON data then update UI
    func updateWeatherData(json : JSON) {
        
        // Do an Optional binding to be sure this (json["main"]["temp"]) statement has some value (Not a nil value)
        if let temperatureResult = json["main"]["temp"].double { // Capture the temperature data from the json and convert into Double from type JSON
        
        weatherDataModel.temperature = Int(temperatureResult - 273.15) // Convert the temperature into Celsius and convert it into Integer, then store it in weatherDataModel object
        
        weatherDataModel.city = json["name"].stringValue // Capture the name from the json, convert it into String from type JSON, then store it in weatherDataModel object
        
        weatherDataModel.condition = json["weather"][0]["id"].intValue // Capture the weather condition id and convert into a integer
        
        weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition) // Store the weather condition icon name in weatherDataModel object
            
        // Update the UI with weather data
        updateUIWithWeatherData()
            
        } else {
            cityLabel.text = "Weather Unavailable"
        }
        
    }
    
    
    //Mark: -   UI Update
    /*********************************************************************************************************************************************/

    // updateUIWithWeatherData method - Update the UI with weather data
    func updateUIWithWeatherData() {
        
        cityLabel.text = weatherDataModel.city // Update the city label
        temperatureLabel.text = "\(weatherDataModel.temperature)°" // Update the temperature label
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName) // Update the weather icon
        
    }
    
    
    //Mark: -  Change City Deligate methods
    /*********************************************************************************************************************************************/

    // userEnterdANewCityName method -
    func userEnteredANewCityName(city: String) {
        print(city) // print the city name here
        
        let params : [String : String] = ["q" : city, "appid" : APP_ID] // Create a dictionary with required parameters by the OpenWeather Map servic
        
        // Get weather data from the Web Service
        getWeatherData(url: WEATHER_URL, parameters: params)
    }
    
    // prepareForSegue method - Will trigger this method, when user is navigated to the next screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" { // Checks the segue identifier
            
            // Create a object with the type of ChangeCityViewController
            let destinationViewController = segue.destination as! ChangeCityViewController
            // Set the destinationViewController's delegate as WeatherViewController
            destinationViewController.delegate = self
        }
    }
}

